require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class RevokeGrantsTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)

        @item_id = "F097864E0CFEA42!s28da53553c234b7588ffb48969c21490"
        @permission_id = "e5778080-9150-43f7-8e9d-acd248bcab54"
      end

      def test_revoke_grants_can_revoke_a_single_grant_from_a_drive_item
        grantees = [{email: "person@example.com"}]

        mock_post(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}/revokeGrants",
          base_url: MicroslopOneDrive::Client::BETA_BASE_URL,
          expected_body: {grantees: grantees}.to_json,
          parsed_response: fixture_response("revoke_grants/success.json"),
          response_code: 200,
          success: true,
          ok: true
        )

        assert_equal true, @client.revoke_grants(item_id: @item_id, permission_id: @permission_id, grantees: grantees)
      end

      def test_returns_true_even_for_no_grantees
        grantees = []

        mock_post(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}/revokeGrants",
          base_url: MicroslopOneDrive::Client::BETA_BASE_URL,
          expected_body: {grantees: grantees}.to_json,
          parsed_response: fixture_response("revoke_grants/success.json"),
          response_code: 200,
          success: true
        )

        assert_equal true, @client.revoke_grants(item_id: @item_id, permission_id: @permission_id, grantees: grantees)
      end

      def test_raises_bad_request_error_if_the_request_is_invalid
        mock_post(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}/revokeGrants",
          base_url: MicroslopOneDrive::Client::BETA_BASE_URL,
          expected_body: {grantees: []}.to_json,
          parsed_response: fixture_response("revoke_grants/bad_request.json"),
          response_code: 400,
          success: false,
          ok: false
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.revoke_grants(item_id: @item_id, permission_id: @permission_id, grantees: [])
        end

        assert_equal 400, error.response_code
        assert_equal "One of the provided arguments is not acceptable.", error.response_body["error"]["message"]
      end

      def test_raises_an_error_if_the_drive_item_does_not_exist
        grantees = [{email: "person@example.com"}]

        mock_post(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}/revokeGrants",
          base_url: MicroslopOneDrive::Client::BETA_BASE_URL,
          expected_body: {grantees: grantees}.to_json,
          parsed_response: fixture_response("revoke_grants/item_not_found.json"),
          response_code: 404,
          success: false
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.revoke_grants(item_id: @item_id, permission_id: @permission_id, grantees: grantees)
        end

        assert_equal 404, error.response_code
        assert_equal "itemNotFound", error.response_body["error"]["code"]
      end

      def test_raises_an_error_if_the_permission_does_not_exist
        grantees = [{email: "person@example.com"}]

        mock_post(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}/revokeGrants",
          base_url: MicroslopOneDrive::Client::BETA_BASE_URL,
          expected_body: {grantees: grantees}.to_json,
          parsed_response: fixture_response("revoke_grants/permission_not_found.json"),
          response_code: 404,
          success: false
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.revoke_grants(item_id: @item_id, permission_id: @permission_id, grantees: grantees)
        end

        assert_equal 404, error.response_code
        assert_equal "Invalid Permission Key. Could not find the permission.", error.response_body["error"]["message"]
      end

      def test_raises_an_error_if_the_grantees_are_invalid
        grantees = [{email: "person@example.com", alias: "person", objectId: "1"}]

        mock_post(
          path: "me/drive/items/#{@item_id}/permissions/#{@permission_id}/revokeGrants",
          base_url: MicroslopOneDrive::Client::BETA_BASE_URL,
          expected_body: {grantees: grantees}.to_json,
          parsed_response: fixture_response("revoke_grants/bad_grantees.json"),
          response_code: 400,
          success: false
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.revoke_grants(item_id: @item_id, permission_id: @permission_id, grantees: grantees)
        end

        assert_equal 400, error.response_code
        assert_equal(
          "One (and only one) of email, alias, or objectid must be specified.",
          error.response_body["error"]["message"]
        )
      end
    end
  end
end
