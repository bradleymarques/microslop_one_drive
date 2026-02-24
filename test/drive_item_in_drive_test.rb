require "test_helper"

module MicroslopOneDrive
  class DriveItemInDriveTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)

      @drive_id = "0f097864e0cfea42"
    end

    def test_drive_item_in_drive_fetches_a_drive_item_from_a_specific_drive
      item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

      mock_get(
        path: "me/drives/#{@drive_id}/items/#{item_id}",
        parsed_response: fixture_response("drive_items/drive_item.json")
      )

      drive_item = @client.drive_item_in_drive(drive_id: @drive_id, item_id: item_id)
      assert_kind_of MicroslopOneDrive::DriveItem, drive_item

      assert_equal "Getting started with OneDrive.pdf", drive_item.name
      assert_equal "application/pdf", drive_item.mime_type
      assert_equal :file, drive_item.file_or_folder
      assert_equal true, drive_item.file?
      assert_equal false, drive_item.folder?
      assert_equal "https://onedrive.live.com?cid=#{@drive_id}&id=#{item_id}", drive_item.web_url
      assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", drive_item.id
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.created_at
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.updated_at
      assert_equal 1_053_417, drive_item.size
    end
  end
end
