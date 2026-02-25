require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class BatchPermissionsTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_permissions_batch_can_fetch_permissions_for_multiple_drive_items
        item_ids = [
          "F097864E0CFEA42!se0d408c95b584ccf9403220e8cce56a3",
          "F097864E0CFEA42!sdb175a6fe02b4039886168a4a695387c",
          "F097864E0CFEA42!s76b80a6457684886b4a55cf65da40603"
        ]

        expected_post_body = build_expected_post_body(item_ids)

        mock_post(
          path: "$batch",
          expected_body: expected_post_body,
          parsed_response: fixture_response("batch_permissions/batch_permissions.json")
        )

        permission_batch = @client.batch_permissions(item_ids: item_ids)
        assert_kind_of Array, permission_batch

        assert_equal 6, permission_batch.size

        sample_permission = permission_batch.first
        assert_kind_of MicroslopOneDrive::Permissions::SharingLink, sample_permission
        assert_equal "47f8c2a7-b883-4758-9412-f37c0c203abb", sample_permission.id
        assert_equal true, sample_permission.edit_link?
        assert_equal true, sample_permission.anonymous_link?

        assert_equal 3, sample_permission.granted_to_list.size
        assert_equal ["Amy Smith", "Charles Garcia", "Bob Myers"], sample_permission.granted_to_list.map(&:display_name)

        assert_equal "F097864E0CFEA42!se0d408c95b584ccf9403220e8cce56a3", sample_permission.drive_item_id
      end

      def test_permissions_batch_with_drive_id_can_fetch_permissions_for_multiple_drive_items_in_a_specific_drive
        drive_id = "0f097864e0cfea42"
        item_ids = [
          "F097864E0CFEA42!se0d408c95b584ccf9403220e8cce56a3",
          "F097864E0CFEA42!sdb175a6fe02b4039886168a4a695387c",
          "F097864E0CFEA42!s76b80a6457684886b4a55cf65da40603"
        ]

        expected_post_body = build_expected_post_body_for_drive(item_ids, drive_id)

        mock_post(
          path: "$batch",
          expected_body: expected_post_body,
          parsed_response: fixture_response("batch_permissions/batch_permissions.json")
        )

        permission_batch = @client.batch_permissions(item_ids: item_ids, drive_id: drive_id)
        assert_kind_of Array, permission_batch

        assert_equal 6, permission_batch.size
      end

      private

      def build_expected_post_body(item_ids)
        {
          requests: item_ids.map { {id: it, method: "GET", url: "/me/drive/items/#{it}/permissions"} }
        }.to_json
      end

      def build_expected_post_body_for_drive(item_ids, drive_id)
        {
          requests: item_ids.map { {id: it, method: "GET", url: "/me/drives/#{drive_id}/items/#{it}/permissions"} }
        }.to_json
      end
    end
  end
end
