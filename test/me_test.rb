require "test_helper"

module MicroslopOneDrive
  class MeTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_me_fetches_the_current_user
      mock_get(
        path: "me",
        parsed_response: fixture_response("me.json")
      )

      me = @client.me
      assert_kind_of MicroslopOneDrive::User, me
      assert_equal "person@example.com", me.email_address
      assert_equal "Person Example", me.display_name
    end
  end
end
