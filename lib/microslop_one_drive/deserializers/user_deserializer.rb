require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class UserDeserializer
      # Creates a new User identity (IdentitySet user) object from a hash.
      #
      # @param user_hash [Hash] The hash to create the User object from.
      # @return [MicroslopOneDrive::IdentitySets::User] The created User object.
      def self.create_from_hash(user_hash)
        user_hash = Utils.deep_symbolize_keys(user_hash)

        MicroslopOneDrive::IdentitySets::User.new(
          id: user_hash.fetch(:id, nil),
          principal_name: user_hash.fetch(:userPrincipalName, nil),
          display_name: user_hash.fetch(:displayName, nil),
          surname: user_hash.fetch(:surname, nil),
          given_name: user_hash.fetch(:givenName, nil),
          preferred_language: user_hash.fetch(:preferredLanguage, nil),
          mail: user_hash.fetch(:mail, nil) || user_hash.fetch(:email, nil),
          mobile_phone: user_hash.fetch(:mobilePhone, nil),
          job_title: user_hash.fetch(:jobTitle, nil),
          office_location: user_hash.fetch(:officeLocation, nil),
          business_phones: user_hash.fetch(:businessPhones, []),
          login_name: user_hash.fetch(:loginName, nil)
        )
      end
    end
  end
end
