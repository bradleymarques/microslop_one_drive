require "test_helper"

module MicroslopOneDrive
  class PermissionsTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_shared_with_me_fetches_the_drive_items_shared_with_me
      skip "Not implemented"
    end
  end
end
