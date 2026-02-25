module MicroslopOneDrive
  module Endpoints
    class SupportsSitesTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_supports_sites_returns_false_if_the_user_account_does_not_support_sharepoint
        mock_get(
          path: "me/sites/root",
          parsed_response: fixture_response("sites/not_supported.json"),
          response_code: 400,
          success: false,
          bad_request: true
        )

        assert_equal false, @client.supports_sites?
      end

      def test_supports_sites_returns_true_if_the_user_account_supports_sharepoint
        mock_get(
          path: "me/sites/root",
          parsed_response: fixture_response("sites/root_site.json"),
          response_code: 200,
          success: true
        )

        assert_equal true, @client.supports_sites?
      end

      def test_supports_sites_raises_an_error_for_other_errors_encountered
        mock_get(
          path: "me/sites/root",
          parsed_response: fixture_response("invalid_request.json"),
          response_code: 400,
          success: false
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.supports_sites?
        end

        assert_equal 400, error.response_code
        assert_equal "Invalid request", error.response_body["error"]["message"]
      end
    end
  end
end
