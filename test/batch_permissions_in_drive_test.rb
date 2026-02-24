require "test_helper"

module MicroslopOneDrive
  class BatchPermissionsInDriveTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_batch_permissions_in_drive_fetches_the_permissions_for_multiple_drive_items_in_a_specific_drive
      skip "Not implemented"
    end
  end
end
