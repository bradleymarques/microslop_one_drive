require "test_helper"

module MicroslopOneDrive
  class DriveByIdTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
      @drive_id = "0f097864e0cfea42"
    end

    def test_drive_by_id_fetches_a_drive
      mock_get(
        path: "me/drives/#{@drive_id}",
        parsed_response: fixture_response("drives/drive.json")
      )

      drive = @client.drive_by_id(drive_id: @drive_id)
      assert_kind_of MicroslopOneDrive::Drive, drive
      assert_equal "0f097864e0cfea42", drive.id
      assert_equal "OneDrive", drive.name
      assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.url
      assert_equal "personal", drive.drive_type
      assert_equal Time.parse("2026-02-16T05:06:27Z"), drive.created_at
      assert_equal Time.parse("2026-02-19T07:39:49Z"), drive.updated_at
      assert_equal "", drive.description
    end
  end
end
