require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class PermissionsTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_permissions_returns_a_list_of_permissions_for_a_drive_item_in_the_default_drive
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

        mock_get(
          path: "me/drive/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
        )

        permission_list = @client.permissions(item_id: item_id)
        assert_kind_of MicroslopOneDrive::ListResponses::PermissionList, permission_list
        permissions = permission_list.permissions

        assert_equal 2, permissions.size
        assert_kind_of MicroslopOneDrive::Permissions::SharingLink, permissions[0]
        assert_kind_of MicroslopOneDrive::Permissions::DirectPermission, permissions[1]
      end

      def test_permissions_returns_a_list_of_permissions_for_a_drive_item_in_a_specific_drive
        drive_id = "0f097864e0cfea42"
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

        mock_get(
          path: "me/drives/#{drive_id}/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
        )

        permission_list = @client.permissions(drive_id: drive_id, item_id: item_id)
        assert_kind_of MicroslopOneDrive::ListResponses::PermissionList, permission_list
        permissions = permission_list.permissions

        assert_equal 2, permissions.size
        assert_kind_of MicroslopOneDrive::Permissions::SharingLink, permissions[0]
        assert_kind_of MicroslopOneDrive::Permissions::DirectPermission, permissions[1]
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

      def test_permissions_can_correctly_structure_a_sharing_link # rubocop:disable Metrics/AbcSize
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

        mock_get(
          path: "me/drive/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
        )

        permission_list = @client.permissions(item_id: item_id)
        permission = permission_list.permissions[0]
        assert_kind_of MicroslopOneDrive::Permissions::SharingLink, permission

        assert_equal "47f8c2a7-b883-4758-9412-f37c0c203abb", permission.id
        assert permission.share_id.start_with?("u!aHR0cHM6Ly8xZHJ2Lm1zL2YvYy8wZjA5N")
        assert_equal ["write"], permission.roles
        assert_equal false, permission.has_password

        granted_to_list = permission.granted_to_list
        assert_equal 2, granted_to_list.size
        assert_kind_of MicroslopOneDrive::User, granted_to_list[0]
        assert_kind_of MicroslopOneDrive::User, granted_to_list[1]

        assert_equal "Amy Smith", granted_to_list[0].display_name
        assert_equal "amy@example.com", granted_to_list[0].email
        assert_equal "6", granted_to_list[0].id
        assert_equal "i:0#.f|membership|amy@example.com", granted_to_list[0].login_name

        link = permission.link
        assert_kind_of MicroslopOneDrive::Permissions::Link, link

        assert link.web_url.start_with?("https://1drv.ms/f/c/0f097864e0cfea42/")
        assert_equal "anonymous", link.scope
        assert_equal "edit", link.type
        assert_equal false, link.prevents_download
      end

      def test_permissions_anonymous_link_responds_correctly_to_some_methods
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

        mock_get(
          path: "me/drive/items/#{item_id}/permissions",
          parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
        )

        permission_list = @client.permissions(item_id: item_id)
        permission = permission_list.permissions[0]
        assert_kind_of MicroslopOneDrive::Permissions::SharingLink, permission

        assert_equal false, permission.view_link?
        assert_equal true, permission.edit_link?
        assert_equal false, permission.specific_people_link?
        assert_equal true, permission.anonymous_link?

        assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", permission.drive_item_id
      end
    end
  end
end
