module MicroslopOneDrive
  module Endpoints
    module DriveItemExists
      # Asks if a DriveItem (folder or file) exists by its ID.
      #
      # @param drive_id [String, nil] The ID of the Drive to check the Drive Item in. If not provided, the current User's
      # default Drive will be used.
      # @param item_id [String] The ID of the Drive Item to check.
      #
      # @return [Boolean]
      def drive_item_exists?(item_id:, drive_id: nil)
        url = drive_id.nil? ? "me/drive/items/#{item_id}" : "me/drives/#{drive_id}/items/#{item_id}"
        response = get(path: url, query: {})

        return false if response.code == 404
        return true if response.success?

        handle_error(response)
      end
    end
  end
end
