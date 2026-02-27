module MicroslopOneDrive
  module Deserializers
    class IdentityDeserializer
      def self.create_from_hash(identity_set_hash)
        return nil if identity_set_hash.nil?
        return nil if identity_set_hash.empty?

        identity_set_hash = Utils.deep_symbolize_keys(identity_set_hash)

        if identity_set_hash.key?(:siteUser)
          UserDeserializer.create_from_hash(identity_set_hash[:siteUser])
        elsif identity_set_hash.key?(:user)
          UserDeserializer.create_from_hash(identity_set_hash[:user])
        elsif identity_set_hash.key?(:application)
          ApplicationDeserializer.create_from_hash(identity_set_hash[:application])
        elsif identity_set_hash.key?(:group)
          GroupDeserializer.create_from_hash(identity_set_hash[:group])
        elsif identity_set_hash.key?(:siteGroup)
          GroupDeserializer.create_from_hash(identity_set_hash[:siteGroup])
        elsif identity_set_hash.key?(:device)
          DeviceDeserializer.create_from_hash(identity_set_hash[:device])
        else
          raise NotImplementedError, "Unknown identity set type for hash: #{identity_set_hash.inspect}"
        end
      end
    end
  end
end
