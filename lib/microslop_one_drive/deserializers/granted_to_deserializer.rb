module MicroslopOneDrive
  module Deserializers
    class GrantedToDeserializer
      def self.create_from_hash(granted_to_hash)
        granted_to_hash = Utils.deep_symbolize_keys(granted_to_hash)

        if granted_to_hash.key?(:siteUser)
          UserDeserializer.create_from_hash(granted_to_hash[:siteUser])
        elsif granted_to_hash.key?(:group)
          raise NotImplementedError, "Group permissions are not supported yet"
        else
          raise NotImplementedError, "Unknown granted to type for hash: #{granted_to_hash.inspect}"
        end
      end
    end
  end
end
