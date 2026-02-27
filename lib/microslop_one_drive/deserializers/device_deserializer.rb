module MicroslopOneDrive
  module Deserializers
    class DeviceDeserializer
      def self.create_from_hash(device_hash)
        return nil if device_hash.nil?
        return nil if device_hash.empty?

        device_hash = Utils.deep_symbolize_keys(device_hash)

        MicroslopOneDrive::IdentitySets::Device.new(
          id: device_hash.fetch(:id, nil),
          display_name: device_hash.fetch(:displayName, nil)
        )
      end
    end
  end
end

