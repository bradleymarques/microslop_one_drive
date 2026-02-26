require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class MeTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_me_fetches_the_current_user
        mock_get(
          :path => "me",
          :parsed_response => fixture_response("users/me.json"),
          "success?" => true
        )

        me = @client.me
        assert_kind_of MicroslopOneDrive::User, me
        assert_equal "person@example.com", me.email_address
        assert_equal "Person Example", me.display_name
        assert_equal "Example", me.surname
        assert_equal "Person", me.given_name
        assert_equal "en-GB", me.preferred_language
        assert_nil me.mobile_phone
        assert_nil me.job_title
        assert_nil me.office_location
        assert_empty me.business_phones
        assert_equal "person@example.com", me.principal_name
        assert_equal "0f097864e0cfea42", me.id
      end
    end
  end
end
