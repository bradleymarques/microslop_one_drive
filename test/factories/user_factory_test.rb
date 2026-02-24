require "test_helper"

module MicroslopOneDrive
  module Factories
    class UserFactoryTest < BaseTest
      def test_create_from_empty_hash
        user = MicroslopOneDrive::Factories::UserFactory.create_from_hash({})
        assert_kind_of MicroslopOneDrive::User, user

        assert_nil user.principal_name
        assert_nil user.id
        assert_nil user.email_address
        assert_nil user.display_name
        assert_nil user.surname
        assert_nil user.given_name
        assert_nil user.preferred_language
        assert_nil user.mail
        assert_nil user.mobile_phone
        assert_nil user.job_title
        assert_nil user.office_location
        assert_empty user.business_phones
      end

      def test_can_create_a_user_from_a_string_key_hash
        user_hash = {
          "@odata.context" => "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
          "userPrincipalName" => "person@example.com",
          "id" => "0f097864e0cfea42",
          "displayName" => "Example Person",
          "surname" => "Person",
          "givenName" => "Example",
          "preferredLanguage" => "en-GB",
          "mail" => "person@example.com",
          "mobilePhone" => "+27111231234",
          "jobTitle" => "Big Cheese",
          "officeLocation" => nil,
          "businessPhones" => []
        }

        user = MicroslopOneDrive::Factories::UserFactory.create_from_hash(user_hash)
        assert_kind_of MicroslopOneDrive::User, user

        assert_equal "Example Person", user.display_name
        assert_equal "Example", user.given_name
        assert_equal "Person", user.surname
        assert_equal "Person", user.last_name
        assert_equal "en-GB", user.preferred_language
        assert_equal "+27111231234", user.mobile_phone
        assert_equal "Big Cheese", user.job_title
        assert_nil user.office_location
        assert_empty user.business_phones
        assert_equal "person@example.com", user.mail
        assert_equal "person@example.com", user.email_address
      end

      def test_can_create_a_user_from_a_symbol_key_hash
        user_hash = {
          "@odata.context" => "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
          :userPrincipalName => "person@example.com",
          :id => "0f097864e0cfea42",
          :displayName => "Example Person",
          :surname => "Person",
          :givenName => "Example",
          :preferredLanguage => "en-GB",
          :mail => "person@example.com",
          :mobilePhone => "+27111231234",
          :jobTitle => "Big Cheese",
          :officeLocation => nil,
          :businessPhones => []
        }

        user = MicroslopOneDrive::Factories::UserFactory.create_from_hash(user_hash)
        assert_kind_of MicroslopOneDrive::User, user

        assert_equal "Example Person", user.display_name
        assert_equal "Example", user.given_name
        assert_equal "Person", user.surname
        assert_equal "Person", user.last_name
        assert_equal "en-GB", user.preferred_language
        assert_equal "+27111231234", user.mobile_phone
        assert_equal "Big Cheese", user.job_title
        assert_nil user.office_location
        assert_empty user.business_phones
        assert_equal "person@example.com", user.mail
        assert_equal "person@example.com", user.email_address
      end
    end
  end
end
