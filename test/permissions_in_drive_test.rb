require "test_helper"

module MicroslopOneDrive
  class PermissionsInDriveTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_permissions_in_drive_fetches_the_permissions_for_a_drive_item_in_a_specific_drive
      flunk "Not implemented"
    end
  end
end
