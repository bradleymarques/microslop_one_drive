require "test_helper"

module MicroslopOneDrive
  class PermissionsTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_shared_with_me_fetches_the_drive_items_shared_with_me
      skip
      mock_get(
        path: "me/drive/sharedWithMe",
        parsed_response: fixture_response("shared_with_me/shared_with_me.json")
      )

      shared_with_me_list = @client.shared_with_me
      assert_kind_of MicroslopOneDrive::ListResponses::SharedWithMeList, shared_with_me_list
      assert_equal 1, shared_with_me_list.shared_with_me.size
    end
  end
end
