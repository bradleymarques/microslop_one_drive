require "test_helper"

module MicroslopOneDrive
  class PermissionsTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_permissions_fetches_the_permissions_for_a_drive_item_with_an_anonymous_link
      item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

      mock_get(
        path: "me/drive/items/#{item_id}/permissions",
        parsed_response: fixture_response("permissions/permissions_with_anonymous_link.json")
      )

      permission_list = @client.permissions(item_id: item_id)
      permissions = permission_list.permissions

      assert_equal 4, permissions.size

      assert_permission(permissions[0], "Amy Smith", "amy@example.com", "amy@example.com", "write", "user")
      assert_permission(permissions[1], "Bob Myers", "bob@example.com", "bob@example.com", "write", "user")
      assert_permission(permissions[2], "Anyone with the link", nil, "anyone_with_the_link", "write", "anyone")
      assert_permission(permissions[3], "Example Person", "person@example.com", "person@example.com", "owner", "user")
    end

    def test_permissions_removed
      item_id = "F097864E0CFEA42!s76b80a6457684886b4a55cf65da40603"

      mock_get(
        path: "me/drive/items/#{item_id}/permissions",
        parsed_response: fixture_response("permissions/permissions_removed.json")
      )

      permission_list = @client.permissions(item_id: item_id)
      permissions = permission_list.permissions

      assert_equal 1, permissions.size

      assert_permission(permissions[0], "Example Person", "person@example.com", "person@example.com", "owner", "user")
    end

    private

    def assert_permission(permission, display_name, email, identifier, role, audience_type)
      assert_equal role, permission.role
      assert_equal audience_type, permission.audience.type
      assert_equal display_name, permission.audience.display_name
      assert_equal identifier, permission.audience.identifier
      if email
        assert_equal email, permission.audience.email_address
      else
        assert_nil permission.audience.email_address
      end
    end
  end
end
