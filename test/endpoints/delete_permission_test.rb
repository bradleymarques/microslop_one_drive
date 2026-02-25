require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class DeletePermissionTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)

        @drive_id = "f097864e0cfea42"
        @item_id = "F097864E0CFEA42!s3186a613e3fd4291bf5ee745ff606d20"
        @permission_id = "b2da7f56-9b5d-4dd4-a23a-4c8974105756"
      end

      def test_delete_permission_returns_true_if_the_permission_was_not_found
        permission_id = SecureRandom.uuid # This permission does not exist. Maybe it was already deleted?

        mock_delete(
          path: "me/drive/items/#{@item_id}/permissions/#{permission_id}",
          parsed_response: fixture_response("delete_permission/no_content_response.json"),
          success: true,
          no_content: true
        )

        assert_equal true, @client.delete_permission(item_id: @item_id, permission_id: permission_id)
      end

      def test_delete_permission_with_a_drive_id_returns_true_if_the_permission_was_not_found
        permission_id = SecureRandom.uuid # This permission does not exist. Maybe it was already deleted?

        mock_delete(
          path: "me/drives/#{@drive_id}/items/#{@item_id}/permissions/#{permission_id}",
          parsed_response: fixture_response("delete_permission/no_content_response.json"),
          success: true,
          no_content: true
        )

        assert_equal(
          true,
          @client.delete_permission(
            item_id: @item_id,
            permission_id: permission_id,
            drive_id: @drive_id
          )
        )
      end

      def test_delete_permission_returns_an_error_if_the_drive_does_not_exist
        mock_delete(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}",
          parsed_response: fixture_response("delete_permission/drive_not_found.json"),
          success: false,
          not_found: true,
          response_code: 404
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.delete_permission(item_id: @item_id, permission_id: @permission_id)
        end

        assert_equal 404, error.response_code
        assert_equal "Item does not exist", error.response_body["error"]["message"]
      end

      def test_delete_permission_returns_an_error_if_the_drive_item_does_not_exist
        mock_delete(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}",
          parsed_response: fixture_response("delete_permission/item_not_found.json"),
          success: false,
          not_found: true,
          response_code: 404
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.delete_permission(item_id: @item_id, permission_id: @permission_id)
        end

        assert_equal 404, error.response_code
        assert_equal "Item not found", error.response_body["error"]["message"]
      end

      def test_delete_permission_raises_an_error_if_the_request_is_not_successful_for_another_reason
        mock_delete(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}",
          parsed_response: fixture_response("invalid_request.json"),
          success: false,
          bad_request: true,
          no_content: false,
          response_code: 400
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.delete_permission(item_id: @item_id, permission_id: @permission_id)
        end

        assert_equal 400, error.response_code
        assert_equal "Invalid request", error.response_body["error"]["message"]
      end

      def test_delete_permission_deletes_a_permission_without_a_drive_id
        mock_delete(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}",
          parsed_response: fixture_response("delete_permission/no_content_response.json"),
          success: true,
          no_content: true
        )

        assert_equal true, @client.delete_permission(item_id: @item_id, permission_id: @permission_id)
      end

      def test_delete_permission_deletes_a_permission_with_a_drive_id
        mock_delete(
          path: "me/drives/#{@drive_id}/items/#{@item_id}/permissions/#{@permission_id}",
          parsed_response: fixture_response("delete_permission/no_content_response.json"),
          success: true,
          no_content: true
        )

        assert_equal(
          true,
          @client.delete_permission(
            item_id: @item_id,
            permission_id: @permission_id,
            drive_id: @drive_id
          )
        )
      end
    end
  end
end
