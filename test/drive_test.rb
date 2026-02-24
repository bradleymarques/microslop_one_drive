require "test_helper"

module MicroslopOneDrive
  class DriveTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_drive_fetches_the_current_user_main_drive
      mock_get(
        path: "me/drive",
        parsed_response: fixture_response("drives/drive.json")
      )

      drive = @client.drive
      assert_kind_of MicroslopOneDrive::Drive, drive

      assert_equal "0f097864e0cfea42", drive.id
      assert_equal "OneDrive", drive.name
      assert_equal "personal", drive.drive_type
      assert_equal "", drive.description
    end
  end
end
