module MicroslopOneDrive
  module Endpoints
    module DeletePermission
      # Deletes a permission for a Drive Item.
      #
      # @param drive_id [String, nil] The ID of the Drive to delete the permission from. If not provided, the current
      # User's default Drive will be used.
      # @param item_id [String] The ID of the Drive Item to delete the permission from.
      # @param permission_id [String] The ID of the permission to delete.
      #
      # @return [Boolean] True if the permission was deleted, false if it was not found.
      def delete_permission(item_id:, permission_id:, drive_id: nil)
        url = if drive_id.nil?
                "me/drive/items/#{item_id}/permissions/#{permission_id}"
              else
                "me/drives/#{drive_id}/items/#{item_id}/permissions/#{permission_id}"
              end

        response = delete(path: url)

        handle_error(response) if response.not_found? # Either the Drive or the Drive Item does not exist.

        return true if response.no_content? # Either the permission was deleted now, or never existed in the first place

        handle_error(response)
      end
    end
  end
end
