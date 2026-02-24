require "json"

module MicroslopOneDrive
  class Client
    BASE_URL = "https://graph.microsoft.com/v1.0".freeze
    BATCH_REQUEST_LIMIT = 20 # This is set by Microsoft

    # @param access_token [String] OAuth access token for Microsoft Graph.
    # @param logger [Object, nil] Optional logger (e.g. Rails.logger) that responds to +#info+, +#debug+, +#warn+, +#error+.
    #   When set, all API requests and responses are logged.
    def initialize(access_token, logger: nil)
      @access_token = access_token
      @logger = logger

      @headers = {
        "Authorization" => "Bearer #{@access_token}",
        "Content-Type" => "application/json",
        "Prefer" => "hierarchicalsharing"
      }
    end

    # Gets the current user
    #
    # @return [MicroslopOneDrive::User]
    def me
      response = get(path: "me", query: {})
      handle_error(response) unless response.success?
      MicroslopOneDrive::Factories::UserFactory.create_from_hash(response.parsed_response)
    end

    # Gets the current User's "main" OneDrive drive.
    #
    # From the docs:
    #
    # > Most users will only have a single Drive resource.
    # > Groups and Sites may have multiple Drive resources available.
    #
    # @return [MicroslopOneDrive::Drive]
    def my_drive
      response = get(path: "me/drive", query: {})
      handle_error(response) unless response.success?
      MicroslopOneDrive::Factories::DriveFactory.create_from_hash(response.parsed_response)
    end

    # Gets ALL Drives the current user has access to.
    #
    # NOTE: This will include some internal Microsoft drives that aren't real drives, such as AI, Face scans, and other
    # shitty things.
    #
    # @return [MicroslopOneDrive::DriveList]
    def drives
      response = get(path: "me/drives", query: {})
      handle_error(response) unless response.success?
      MicroslopOneDrive::DriveList.new(response.parsed_response)
    end

    # Gets a specific Drive by its ID.
    #
    # @param drive_id [String] The ID of the Drive to get.
    #
    # @return [MicroslopOneDrive::Drive]
    def drive(drive_id:)
      response = get(path: "me/drives/#{drive_id}", query: {})
      handle_error(response) unless response.success?
      MicroslopOneDrive::Factories::DriveFactory.create_from_hash(response.parsed_response)
    end

    # Asks if a Drive exists by its ID.
    #
    # @param drive_id [String] The ID of the Drive to check.
    #
    # @return [Boolean]
    def drive_exists?(drive_id:)
      response = get(path: "me/drives/#{drive_id}", query: {})
      response.success?
    end

    # Gets a specific DriveItem (folder or file) by its ID.
    #
    # @param item_id [String] The ID of the Drive Item to get.
    #
    # @return [MicroslopOneDrive::DriveItem]
    def drive_item(item_id:)
      response = get(path: "me/drive/items/#{item_id}", query: {})
      handle_error(response) unless response.success?
      MicroslopOneDrive::DriveItem.new(response.parsed_response)
    end

    # Asks if a DriveItem (folder or file) exists by its ID.
    #
    # @param item_id [String] The ID of the Drive Item to check.
    #
    # @return [Boolean]
    def item_exists?(item_id:)
      response = get(path: "me/drive/items/#{item_id}", query: {})

      return false if response.code == 404
      return true if response.success?

      handle_error(response)
    end

    # Gets a delta of changes to a Drive.
    #
    # @param drive_id [String] The ID of the Drive to get the delta of.
    # @param token [String] The token to use for the delta. If not provided, the initial delta will be returned.
    #
    # @return [MicroslopOneDrive::DriveItemList]
    def delta(drive_id:, token: nil)
      response = get(path: "me/drives/#{drive_id}/root/delta", query: {token: token})
      handle_error(response) unless response.success?
      MicroslopOneDrive::DriveItemList.new(response.parsed_response)
    end

    # Gets the permissions for a DriveItem (folder or file).
    #
    # @param item_id [String] The ID of the Drive Item to get the permissions of.
    #
    # @return [MicroslopOneDrive::PermissionList]
    def permissions(item_id:)
      response = get(path: "me/drive/items/#{item_id}/permissions", query: {})

      if response.code == 404
        return MicroslopOneDrive::PermissionList.new(drive_item_id: item_id, parsed_response: {"value" => []})
      end

      handle_error(response) unless response.success?

      MicroslopOneDrive::PermissionList.new(drive_item_id: item_id, parsed_response: response.parsed_response)
    end

    # Gets the permissions for multiple Drive Items.
    #
    # Uses the batch Microsoft Graph API to make multiple API calls in batches of 20 (the max Microsoft allows on their
    # batch endpoint).
    #
    # See: https://learn.microsoft.com/en-us/graph/json-batching
    #
    # @param item_ids [Array<String>] The IDs of the Drive Items to get the permissions of.
    #
    # @return [Array<MicroslopOneDrive::Permission>]
    def batch_permissions(item_ids:)
      requests = item_ids.map {
        {id: it, method: "GET", url: "/me/drive/items/#{it}/permissions"}
      }
      batch_response = batch(requests: requests)
      successful_responses = batch_response.responses.select(&:success?)

      permission_lists = successful_responses.map do
        MicroslopOneDrive::PermissionList.new(drive_item_id: it.id, parsed_response: it.body)
      end

      permission_lists.flat_map(&:permissions)
    end

    # Makes a batch request to the Microsoft Graph API.
    #
    # @param requests [Array<Hash>] The requests to make. Each request should be a hash with the following keys:
    #   - id: The ID of the request.
    #   - method: The HTTP method to use for the request.
    #   - url: The URL to make the request to.
    #
    # Note: Microsoft allows a maximum of 20 requests per batch. If you pass more than 20 requests, the client will
    # make multiple batch requests to Microsoft. This might make this a slow method.
    #
    # @return [MicroslopOneDrive::BatchResponse]
    def batch(requests:)
      batch_response = MicroslopOneDrive::BatchResponse.new

      # No requests, so simply return an empty batch response:
      return batch_response if requests.empty?

      batches = requests.each_slice(BATCH_REQUEST_LIMIT).to_a
      batches.each do
        response = post(path: "$batch", body: {requests: it}.to_json)
        handle_error(response) unless response.success?
        new_responses = response.parsed_response.fetch("responses", [])
        new_responses.each do
          batch_response.add_response(MicroslopOneDrive::Response.new(it))
        end
      end

      batch_response
    end

    private

    def get(path:, query: {})
      url = "#{BASE_URL}/#{path}"

      log_request("GET", url, query: query)

      response = HTTParty.get(url, headers: @headers, query: query)

      log_response(response, "GET", url)

      response
    end

    def post(path:, body:)
      url = "#{BASE_URL}/#{path}"

      log_request("POST", url, body: body)

      response = HTTParty.post(url, headers: @headers, body: body)

      log_response(response, "POST", url)

      response
    end

    def log_request(method, url, query: nil, body: nil)
      return unless @logger

      @logger.info ""
      @logger.info "==================== START MicroslopOneDrive #{method} #{url} ===================="
      @logger.info "Request method: #{method}"
      @logger.info "Request url: #{url}"
      @logger.info "Request query: #{query.inspect}" if query && query.any?
      @logger.info "Request body: #{body.inspect}" if body
    end

    def log_response(response, method, url)
      return unless @logger

      @logger.info ""
      @logger.info "Response code: #{response.code}"
      @logger.info "Response body:" if response.parsed_response
      @logger.info JSON.pretty_generate(response.parsed_response) if response.parsed_response
      @logger.info "==================== END MicroslopOneDrive #{method} #{url} ===================="
    end

    def handle_error(response)
      error = MicroslopOneDrive::Errors::ClientError.new(response.parsed_response, response.code)
      raise error
    end
  end
end
