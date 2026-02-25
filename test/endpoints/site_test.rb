module MicroslopOneDrive
  module Endpoints
    class SiteTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_site_returns_nil_for_the_root_site_if_the_user_account_does_not_support_sharepoint
        skip "TODO: Implement this test"
      end

      def test_site_returns_nil_for_a_site_by_site_id_if_the_user_account_does_not_support_sharepoint
        skip "TODO: Implement this test"
      end

      def test_site_returns_the_root_site
        skip "TODO: Implement this test"
      end

      def test_site_returns_a_site_by_site_id
        skip "TODO: Implement this test"
      end
    end
  end
end
