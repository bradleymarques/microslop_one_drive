module MicroslopOneDrive
  module Deserializers
    class IdentitySetDeserializerTest < BaseTest
      def test_create_from_nil
        identity_set_hash = nil
        identity_set = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)
        assert_nil identity_set
      end

      def test_create_from_empty_hash
        identity_set_hash = {}
        identity_set = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)
        assert_nil identity_set
      end

      def test_create_from_site_user_hash
        identity_set_hash = {
          siteUser: {
            displayName: "Example Person",
            email: "person@example.com",
            id: "1",
            loginName: "i:0#.f|membership|person@example.com"
          }
        }
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)
        assert_kind_of MicroslopOneDrive::IdentitySets::User, identity

        assert_equal "Example Person", identity.display_name
        assert_equal "person@example.com", identity.email_address
        assert_equal "1", identity.id
        assert_equal "i:0#.f|membership|person@example.com", identity.login_name
      end

      def test_create_from_v1_site_user_hash
        identity_set_hash = fixture_response("granted_to/v1_site_user.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::User, identity

        assert_equal "Example User", identity.display_name
        assert_equal "user@example.com", identity.email_address
        assert_equal "1", identity.id
        assert_equal "i:0#.f|membership|user@example.com", identity.login_name
      end

      def test_create_from_v1_user_hash
        identity_set_hash = fixture_response("granted_to/v1_user.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::User, identity

        assert_equal "Example User", identity.display_name
        assert_equal "user@example.com", identity.email_address
        assert_equal "GUID", identity.id
      end

      def test_create_from_v1_application_hash
        identity_set_hash = fixture_response("granted_to/v1_application.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::Application, identity

        assert_equal "GUID", identity.id
        assert_equal "My App", identity.display_name
      end

      def test_create_from_v1_group_hash
        identity_set_hash = fixture_response("granted_to/v1_group.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::Group, identity

        assert_equal "GUID", identity.id
        assert_equal "Finance Team", identity.display_name
      end

      def test_create_from_v1_site_group_hash
        identity_set_hash = fixture_response("granted_to/v1_site_group.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::Group, identity

        assert_equal "GUID", identity.id
        assert_equal "Finance Team", identity.display_name
      end

      def test_create_from_v1_device_hash
        identity_set_hash = fixture_response("granted_to/v1_device.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::Device, identity

        assert_equal "GUID", identity.id
        assert_equal "Device Name", identity.display_name
      end

      def test_create_from_v2_user_hash
        identity_set_hash = fixture_response("granted_to/v2_user.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::User, identity

        assert_equal "User Name", identity.display_name
        assert_equal "user@example.com", identity.email_address
        assert_equal "GUID", identity.id
        assert_equal "i:0#.f|membership|user@example.com", identity.login_name
      end

      def test_create_from_v2_group_hash
        identity_set_hash = fixture_response("granted_to/v2_group.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::Group, identity

        assert_equal "GUID", identity.id
        assert_equal "Finance Team", identity.display_name
      end

      def test_create_from_v2_site_group_hash
        identity_set_hash = fixture_response("granted_to/v2_site_group.json")
        identity = MicroslopOneDrive::Deserializers::IdentitySetDeserializer.create_from_hash(identity_set_hash)

        assert_kind_of MicroslopOneDrive::IdentitySets::Group, identity

        assert_equal "5", identity.id
        assert_equal "Members", identity.display_name
      end
    end
  end
end
