require "test_helper"

module MicroslopOneDrive
  class DriveTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
      @drive_id = "0f097864e0cfea42"
    end

    def test_drive_fetches_a_drive
      mock_get(
        path: "me/drives/#{@drive_id}",
        parsed_response: fixture_response("drives/drive.json")
      )

    drive = @client.drive(drive_id: @drive_id)
      assert_kind_of MicroslopOneDrive::Drive, drive
      assert_equal "0f097864e0cfea42", drive.id
      assert_equal "OneDrive", drive.name
      assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.url
      assert_equal "personal", drive.drive_type
    end
  end
end
