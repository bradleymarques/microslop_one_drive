require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class AllDrivesTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_all_drives_fetches_the_current_user_drives
        mock_get(
          :path => "me/drives",
          :parsed_response => fixture_response("drives/drives.json"),
          "success?" => true
        )

        drive_list = @client.all_drives
        assert_kind_of MicroslopOneDrive::ListResponses::ListResponse, drive_list
        assert_equal false, drive_list.next_page?
        assert_kind_of MicroslopOneDrive::ListResponses::DriveList, drive_list
        assert_equal 2, drive_list.drives.size
        assert_kind_of MicroslopOneDrive::Drive, drive_list.drives.first

        drive = drive_list.drives[1]

        assert_equal "0f097864e0cfea42", drive.id
        assert_equal "OneDrive", drive.name
        assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.url
        assert_equal "personal", drive.drive_type
        assert_equal "", drive.description

        internal_drive = drive_list.drives[0]
        assert_equal "Document library to store albums and album items", internal_drive.description
      end
    end
  end
end
