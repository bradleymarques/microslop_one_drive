module MicroslopOneDrive
  module Endpoints
    module RevokeGrants
      # Revokes a grant from a drive item.
      #
      # NOTE: This is from the beta version of the OneDrive API.
      # https://learn.microsoft.com/en-us/graph/api/permission-revokegrants
      #
      # @param item_id [String] The ID of the DriveItem to revoke the grant from.
      # @param permission_id [String] The ID of the Permission to revoke.
      # @param grantees [Array<Hash>] The grantees to revoke the grant from. Each grantee should be a hash with one
      # (and only one) of the following keys:
      #
      #   - email: The email address of the grantee.
      #   - alias: The alias of the grantee.
      #   - objectId: The object ID of the grantee.
      #
      # @return [boolean] True if successful, else raises an error.
      def revoke_grants(item_id:, permission_id:, grantees:)
        url = "me/drive/items/#{item_id}/permissions/#{permission_id}/revokeGrants"

        response = post(
          path: url,
          body: {grantees: grantees}.to_json,
          base_url: MicroslopOneDrive::Client::BETA_BASE_URL
        )

        return true if response.success?

        handle_error(response)
      end
    end
  end
end
