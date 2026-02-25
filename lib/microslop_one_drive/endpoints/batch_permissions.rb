module MicroslopOneDrive
  module Endpoints
    module BatchPermissions
      # Gets the permissions for multiple Drive Items.
      #
      # Uses the batch Microsoft Graph API to make multiple API calls in batches of 20 (the max Microsoft allows on their
      # batch endpoint).
      #
      # See: https://learn.microsoft.com/en-us/graph/json-batching
      #
      # @param drive_id [String, nil] The ID of the Drive to get the permissions of. If not provided, the current User's
      # default Drive will be used.
      # @param item_ids [Array<String>] The IDs of the Drive Items to get the permissions of.
      #
      # @return [Array<MicroslopOneDrive::Permission>]
      def batch_permissions(item_ids:, drive_id: nil)
        requests = build_batch_permissions_requests(item_ids: item_ids, drive_id: drive_id)
        batch_response = batch(requests: requests)
        successful_responses = batch_response.responses.select(&:success?)

        permission_lists = successful_responses.map do
          MicroslopOneDrive::ListResponses::PermissionList.new(
            drive_item_id: it.id,
            parsed_response: it.body
          )
        end

        permission_lists.flat_map(&:permissions)
      end

      private

      def build_batch_permissions_requests(item_ids:, drive_id: nil)
        if drive_id.nil?
          item_ids.map { {id: it, method: "GET", url: "/me/drive/items/#{it}/permissions"} }
        else
          item_ids.map { {id: it, method: "GET", url: "/me/drives/#{drive_id}/items/#{it}/permissions"} }
        end
      end
    end
  end
end
