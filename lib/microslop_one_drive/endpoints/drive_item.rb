module MicroslopOneDrive
  module Endpoints
    module DriveItem
      # Gets a specific DriveItem (folder or file)
      #
      # @param drive_id [String, nil] The ID of the Drive to get the Drive Item from. If not provided, the current User's
      # default Drive will be used.
      # @param item_id [String] The ID of the Drive Item to get.
      #
      # @return [MicroslopOneDrive::DriveItem]
      def drive_item(item_id:, drive_id: nil)
        url = drive_id.nil? ? "me/drive/items/#{item_id}" : "me/drives/#{drive_id}/items/#{item_id}"
        response = get(path: url, query: {})

        handle_error(response) unless response.success?
        MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(response.parsed_response)
      end
    end
  end
end
