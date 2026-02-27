module MicroslopOneDrive
  module Deserializers
    class GrantedToDeserializerTest < BaseTest
      def test_create_from_nil
        granted_to_hash = nil
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)
        assert_nil granted_to
      end

      def test_create_from_empty_hash
        granted_to_hash = {}
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)
        assert_nil granted_to
      end

      def test_create_from_site_user_hash
        granted_to_hash = {
          siteUser: {
            displayName: "Example Person",
            email: "person@example.com",
            id: "1",
            loginName: "i:0#.f|membership|person@example.com"
          }
        }
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)
        assert_kind_of MicroslopOneDrive::Audiences::User, granted_to

        assert_equal "Example Person", granted_to.display_name
        assert_equal "person@example.com", granted_to.email_address
        assert_equal "1", granted_to.id
        assert_equal "i:0#.f|membership|person@example.com", granted_to.login_name
      end

      def test_create_from_v1_site_user_hash
        granted_to_hash = fixture_response("granted_to/v1_site_user.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::User, granted_to

        assert_equal "Example User", granted_to.display_name
        assert_equal "user@example.com", granted_to.email_address
        assert_equal "1", granted_to.id
        assert_equal "i:0#.f|membership|user@example.com", granted_to.login_name
      end

      def test_create_from_v1_user_hash
        granted_to_hash = fixture_response("granted_to/v1_user.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::User, granted_to

        assert_equal "Example User", granted_to.display_name
        assert_equal "user@example.com", granted_to.email_address
        assert_equal "GUID", granted_to.id
      end

      def test_create_from_v1_application_hash
        granted_to_hash = fixture_response("granted_to/v1_application.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::Application, granted_to

        assert_equal "GUID", granted_to.id
        assert_equal "My App", granted_to.display_name
      end

      def test_create_from_v1_group_hash
        granted_to_hash = fixture_response("granted_to/v1_group.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::Group, granted_to

        assert_equal "GUID", granted_to.id
        assert_equal "Finance Team", granted_to.display_name
      end

      def test_create_from_v1_site_group_hash
        granted_to_hash = fixture_response("granted_to/v1_site_group.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::Group, granted_to

        assert_equal "GUID", granted_to.id
        assert_equal "Finance Team", granted_to.display_name
      end

      def test_create_from_v1_device_hash
        granted_to_hash = fixture_response("granted_to/v1_device.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::Device, granted_to

        assert_equal "GUID", granted_to.id
        assert_equal "Device Name", granted_to.display_name
      end

      def test_create_from_v2_user_hash
        granted_to_hash = fixture_response("granted_to/v2_user.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::User, granted_to

        assert_equal "User Name", granted_to.display_name
        assert_equal "user@example.com", granted_to.email_address
        assert_equal "GUID", granted_to.id
        assert_equal "i:0#.f|membership|user@example.com", granted_to.login_name
      end

      def test_create_from_v2_group_hash
        granted_to_hash = fixture_response("granted_to/v2_group.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::Group, granted_to

        assert_equal "GUID", granted_to.id
        assert_equal "Finance Team", granted_to.display_name
      end

      def test_create_from_v2_site_group_hash
        granted_to_hash = fixture_response("granted_to/v2_site_group.json")
        granted_to = MicroslopOneDrive::Deserializers::GrantedToDeserializer.create_from_hash(granted_to_hash)

        assert_kind_of MicroslopOneDrive::Audiences::Group, granted_to

        assert_equal "5", granted_to.id
        assert_equal "Members", granted_to.display_name
      end
    end
  end
end
