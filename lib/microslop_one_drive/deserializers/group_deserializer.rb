module MicroslopOneDrive
  module Deserializers
    class GroupDeserializer
      def self.create_from_hash(group_hash)
        return nil if group_hash.nil?
        return nil if group_hash.empty?

        group_hash = Utils.deep_symbolize_keys(group_hash)

        MicroslopOneDrive::Audiences::Group.new(
          id: group_hash.fetch(:id, nil),
          display_name: group_hash.fetch(:displayName, nil)
        )
      end
    end
  end
end

