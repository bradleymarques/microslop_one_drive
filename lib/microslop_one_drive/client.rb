module MicroslopOneDrive
  class Client
    BASE_URL = "https://graph.microsoft.com/v1.0".freeze

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
    # @return [MicroslopOneDrive::OneDrivePermissionList]
    def permissions(item_id:)
      response = get(path: "me/drive/items/#{item_id}/permissions", query: {})

      return MicroslopOneDrive::OneDrivePermissionList.new("value" => []) if response.code == 404

      handle_error(response) unless response.success?
      MicroslopOneDrive::OneDrivePermissionList.new(response.parsed_response)
    end

    private

    def get(path:, query: {})
      response = HTTParty.get("#{BASE_URL}/#{path}", headers: @headers, query: query)

      @debug_response_writer&.call(path, response.parsed_response)

      response
    end

    def handle_error(response)
      error = MicroslopOneDrive::Errors::ClientError.new(response.parsed_response, response.code)
      raise error
    end
  end
end
