module MicroslopOneDrive
  module Endpoints
    module Permissions
      # Gets the permissions for a DriveItem (folder or file) in a Drive.
      #
      # @param drive_id [String, nil] The ID of the Drive to get the permissions of. If not provided, the current User's
      # default Drive will be used.
      # @param item_id [String] The ID of the Drive Item to get the permissions of.
      #
      # @return [MicroslopOneDrive::PermissionList]
      def permissions(item_id:, drive_id: nil)
        url = if drive_id.nil?
                "me/drive/items/#{item_id}/permissions"
              else
                "me/drives/#{drive_id}/items/#{item_id}/permissions"
              end

        response = get(path: url, query: {})

        if response.code == 404
          return MicroslopOneDrive::ListResponses::PermissionList.new(
            drive_item_id: item_id,
            parsed_response: {"value" => []}
          )
        end

        handle_error(response) unless response.success?

        MicroslopOneDrive::ListResponses::PermissionList.new(
          drive_item_id: item_id,
          parsed_response: response.parsed_response
        )
      end
    end
  end
end
