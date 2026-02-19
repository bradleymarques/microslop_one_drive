require "test_helper"

module MicroslopOneDrive
  class DriveItemTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)

      @drive_id = "0f097864e0cfea42"
    end

    def test_drive_item_fetches_a_drive_item
      item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("drive_item.json")
      )

      drive_item = @client.drive_item(item_id: item_id)
      assert_kind_of MicroslopOneDrive::DriveItem, drive_item

      assert_equal "Getting started with OneDrive.pdf", drive_item.name
      assert_equal "application/pdf", drive_item.mime_type
      assert_equal :file, drive_item.file_or_folder
      assert_equal true, drive_item.file?
      assert_equal false, drive_item.folder?
      assert_equal "https://onedrive.live.com?cid=#{@drive_id}&id=#{item_id}", drive_item.url
      assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", drive_item.identifier
      assert_equal "F097864E0CFEA42!sea8cc6beffdb43d7976fbc7da445c639", drive_item.parent_identifier
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.created_at
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.updated_at
      assert_equal 1053417, drive_item.size
    end

    def test_drive_item_fetches_a_drive_item
      item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("drive_item.json")
      )

      drive_item = @client.drive_item(item_id: item_id)
      assert_kind_of MicroslopOneDrive::DriveItem, drive_item

      assert_equal "Getting started with OneDrive.pdf", drive_item.name
      assert_equal "application/pdf", drive_item.mime_type
      assert_equal :file, drive_item.file_or_folder
      assert_equal true, drive_item.file?
      assert_equal false, drive_item.folder?
      assert_equal "https://onedrive.live.com?cid=#{@drive_id}&id=#{item_id}", drive_item.url
      assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", drive_item.identifier
      assert_equal "F097864E0CFEA42!sea8cc6beffdb43d7976fbc7da445c639", drive_item.parent_identifier
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.created_at
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.updated_at
      assert_equal 1053417, drive_item.size
    end

    def test_drive_item_for_an_item_that_does_not_exist
      item_id = "F097864E0CFEA42!not-an-item-id"

      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("drive_item_not_found.json"),
        response_code: 404,
        success: false,
      )

      error = assert_raises MicroslopOneDrive::Errors::ClientError do
        @client.drive_item(item_id: item_id)
      end

      assert_equal 404, error.response_code
      assert_includes(error.response_body["error"]["message"], "Item not found")
    end
  end
end
