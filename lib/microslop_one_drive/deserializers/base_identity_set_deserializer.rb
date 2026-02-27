module MicroslopOneDrive
  module Deserializers
    class BaseIdentitySetDeserializer
      def self.create_from_hash(identity_set_hash)
        MicroslopOneDrive::IdentitySets::BaseIdentitySet.new(
          id: identity_set_hash.fetch(:id, nil),
          display_name: identity_set_hash.fetch(:displayName, nil)
        )
      end
    end
  end
end
