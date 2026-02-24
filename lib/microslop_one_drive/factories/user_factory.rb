require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Factories
    class UserFactory
      # Creates a new User object from a hash.
      #
      # @param user_hash [Hash] The hash to create the User object from.
      # @return [MicroslopOneDrive::User] The created User object.
      def self.create_from_hash(user_hash)
        user_hash = Utils.deep_symbolize_keys(user_hash)

        principal_name = user_hash.fetch(:userPrincipalName, nil)
        id = user_hash.fetch(:id, nil)
        display_name = user_hash.fetch(:displayName, nil)
        surname = user_hash.fetch(:surname, nil)
        given_name = user_hash.fetch(:givenName, nil)
        preferred_language = user_hash.fetch(:preferredLanguage, nil)
        mail = user_hash.fetch(:mail, nil) || user_hash.fetch(:email, nil)
        mobile_phone = user_hash.fetch(:mobilePhone, nil)
        job_title = user_hash.fetch(:jobTitle, nil)
        office_location = user_hash.fetch(:officeLocation, nil)
        business_phones = user_hash.fetch(:businessPhones, [])

        User.new(
          id: id,
          principal_name: principal_name,
          display_name: display_name,
          surname: surname,
          given_name: given_name,
          preferred_language: preferred_language,
          mail: mail,
          mobile_phone: mobile_phone,
          job_title: job_title,
          office_location: office_location,
          business_phones: business_phones
        )
      end
    end
  end
end
