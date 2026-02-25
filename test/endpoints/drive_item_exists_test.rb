require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class DriveItemExistsTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)

        @drive_id = "0f097864e0cfea42"
      end

      def test_drive_item_exists_returns_true_if_the_item_exists
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"
        mock_get(
          path: "me/drive/items/#{item_id}",
          parsed_response: fixture_response("drive_items/drive_item.json"),
          response_code: 200,
          success: true
        )

        assert_equal true, @client.drive_item_exists?(item_id: item_id)
      end

      def test_drive_item_exists_returns_false_if_the_item_does_not_exist
        item_id = "F097864E0CFEA42!not-an-item-id"
        mock_get(
          path: "me/drive/items/#{item_id}",
          parsed_response: fixture_response("drive_items/drive_item_not_found.json"),
          response_code: 404,
          success: false
        )

        assert_equal false, @client.drive_item_exists?(item_id: item_id)
      end

      def test_drive_item_exists_with_drive_id_returns_true_if_the_item_exists
        item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"
        mock_get(
          path: "me/drives/#{@drive_id}/items/#{item_id}",
          parsed_response: fixture_response("drive_items/drive_item.json"),
          response_code: 200,
          success: true
        )

        assert_equal true, @client.drive_item_exists?(item_id: item_id, drive_id: @drive_id)
      end

      def test_drive_item_exists_with_drive_id_returns_false_if_the_item_does_not_exist
        item_id = "F097864E0CFEA42!not-an-item-id"
        mock_get(
          path: "me/drives/#{@drive_id}/items/#{item_id}",
          parsed_response: fixture_response("drive_items/drive_item_not_found.json"),
          response_code: 404,
          success: false
        )

        assert_equal false, @client.drive_item_exists?(item_id: item_id, drive_id: @drive_id)
      end
    end
  end
end
