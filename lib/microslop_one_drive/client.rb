module MicroslopOneDrive
  class Client
    BASE_URL = "https://graph.microsoft.com/v1.0".freeze
    BATCH_REQUEST_LIMIT = 20.freeze

    def initialize(access_token)
      @access_token = access_token

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
      MicroslopOneDrive::User.new(response.parsed_response)
    end

    # Gets all Drives the current user has access to.
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
      MicroslopOneDrive::Drive.new(response.parsed_response)
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
        return MicroslopOneDrive::PermissionList.new(drive_item_id: item_id, parsed_response: { "value" => [] })
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
      requests = item_ids.map { |item_id| { id: item_id, method: "GET", url: "/me/drive/items/#{item_id}/permissions" } }
      batch_response = batch(requests: requests)
      successful_responses = batch_response.responses.select(&:success?)

      permission_lists = successful_responses.map do |response|
        MicroslopOneDrive::PermissionList.new(drive_item_id: response.id, parsed_response: response.body)
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
      batches.each do |batch|
        response = post(path: "$batch", body: { requests: batch }.to_json)
        handle_error(response) unless response.success?
        new_responses = response.parsed_response.fetch("responses", [])
        new_responses.each do |new_response_hash|
          batch_response.add_response(MicroslopOneDrive::Response.new(new_response_hash))
        end
      end

      batch_response
    end

    private

    def get(path:, query: {})
      HTTParty.get("#{BASE_URL}/#{path}", headers: @headers, query: query)
    end

    def post(path:, body:)
      HTTParty.post("#{BASE_URL}/#{path}", headers: @headers, body: body)
    end

    def handle_error(response)
      error = MicroslopOneDrive::Errors::ClientError.new(response.parsed_response, response.code)
      raise error
    end
  end
end
