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

      permissions = @client.permissions(item_id: item_id)
    end
  end
end
