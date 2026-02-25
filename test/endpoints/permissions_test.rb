require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class PermissionsTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_permissions_returns_a_list_of_permissions_for_a_drive_item
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

        mock_get(
          path: "me/drive/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
        )

        permission_list = @client.permissions(item_id: item_id)
        assert_kind_of MicroslopOneDrive::ListResponses::PermissionList, permission_list
        permissions = permission_list.permissions

        assert_equal 2, permissions.size
        permission1 = permissions[0]
        assert_kind_of MicroslopOneDrive::Permissions::SharingLink, permission1

        permission2 = permissions[1]
        assert_kind_of MicroslopOneDrive::Permissions::DirectPermission, permission2
      end

      def test_permissions_can_correctly_structure_the_owners_direct_permission
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

        mock_get(
          path: "me/drive/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
        )

        permission_list = @client.permissions(item_id: item_id)
        permission = permission_list.permissions[1]
        assert_kind_of MicroslopOneDrive::Permissions::DirectPermission, permission

        assert_equal "aTowIy5mfG1lbWJlcnNoaXB8YnJhZEBoYWlrdWNvZGUuZGV2", permission.id
        assert_equal "aTowIy5mfG1lbWJlcnNoaXB8YnJhZEBoYWlrdWNvZGUuZGV2", permission.share_id
        assert_equal ["owner"], permission.roles

        granted_to = permission.granted_to
        assert_kind_of MicroslopOneDrive::User, granted_to

        assert_equal "Example Person", granted_to.display_name
        assert_equal "person@example.com", granted_to.email
        assert_equal "4", granted_to.id
        assert_equal "i:0#.f|membership|person@example.com", granted_to.login_name

        link = permission.link
        assert_kind_of MicroslopOneDrive::Permissions::Link, link

        assert_equal "https://1drv.ms/f/c/0f097864e0cfea42/AskI1OBYW89MlAMiDozOVqM", link.web_url
      end

      def test_permissions_removed
        skip "TODO: FIX THIS TEST!"
        item_id = "F097864E0CFEA42!s76b80a6457684886b4a55cf65da40603"

        mock_get(
          path: "me/drive/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_removed.json")
        )

        permission_list = @client.permissions(item_id: item_id)
        permissions = permission_list.permissions

        assert_equal 1, permissions.size

        assert_permission(
          permissions[0],
          item_id,
          "Example Person",
          "person@example.com",
          "person@example.com",
          "owner",
          "user"
        )
      end

      def test_permissions_with_drive_id_fetches_the_permissions_for_a_drive_item_in_a_specific_drive # rubocop:disable Metrics/MethodLength
        skip "TODO: FIX THIS TEST!"
        drive_id = "0f097864e0cfea42"
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

        mock_get(
          path: "me/drives/#{drive_id}/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
        )

        permission_list = @client.permissions(item_id: item_id, drive_id: drive_id)
        permissions = permission_list.permissions

        assert_equal 4, permissions.size

        assert_permission(
          permissions[0],
          item_id,
          "Amy Smith",
          "amy@example.com",
          "amy@example.com",
          "write",
          "user"
        )
        assert_permission(
          permissions[1],
          item_id,
          "Bob Myers",
          "bob@example.com",
          "bob@example.com",
          "write",
          "user"
        )
        assert_permission(
          permissions[2],
          item_id,
          "Anyone with the link",
          nil,
          "anyone_with_the_link",
          "write",
          "anyone"
        )
        assert_permission(
          permissions[3],
          item_id,
          "Example Person",
          "person@example.com",
          "person@example.com",
          "owner",
          "user"
        )
      end
    end
  end
end
