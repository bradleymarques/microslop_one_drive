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
        assert_kind_of MicroslopOneDrive::User, granted_to

        assert_equal "Example Person", granted_to.display_name
        assert_equal "person@example.com", granted_to.email_address
        assert_equal "1", granted_to.id
        assert_equal "i:0#.f|membership|person@example.com", granted_to.login_name
      end
    end
  end
end
