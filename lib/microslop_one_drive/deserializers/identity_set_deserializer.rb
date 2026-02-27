module MicroslopOneDrive
  module Deserializers
    class IdentitySetDeserializer
      TYPE_MAPPING = {
        siteUser: UserDeserializer,
        user: UserDeserializer,
        application: ApplicationDeserializer,
        group: GroupDeserializer,
        siteGroup: GroupDeserializer,
        device: DeviceDeserializer
      }.freeze

      def self.create_from_hash(identity_set_hash)
        return nil if identity_set_hash.nil?
        return nil if identity_set_hash.empty?

        identity_set_hash = Utils.deep_symbolize_keys(identity_set_hash)

        key, deserializer_class = TYPE_MAPPING.find { identity_set_hash.keys.include?(it.first) }

        return BaseIdentitySetDeserializer.create_from_hash(identity_set_hash.values.first) if deserializer_class.nil?

        deserializer_class.create_from_hash(identity_set_hash[key])
      end
    end
  end
end
