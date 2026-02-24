require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class SharedWithMeItemDeserializer
      def self.create_from_hash(shared_with_me_item_hash)
        shared_with_me_item_hash = Utils.deep_symbolize_keys(shared_with_me_item_hash)

        created_by = build_created_by(shared_with_me_item_hash)
        last_modified_by = build_last_modified_by(shared_with_me_item_hash)

        SharedWithMeItem.new(
          id: shared_with_me_item_hash.fetch(:id, nil),
          name: shared_with_me_item_hash.fetch(:name, nil),
          web_url: shared_with_me_item_hash.fetch(:webUrl, nil),
          size: shared_with_me_item_hash.fetch(:size, nil),
          last_modified_date_time: Utils.safe_parse_time(shared_with_me_item_hash.fetch(:lastModifiedDateTime, nil)),
          created_date_time: Utils.safe_parse_time(shared_with_me_item_hash.fetch(:createdDateTime, nil)),
          created_by: created_by,
          last_modified_by: last_modified_by
        )
      end

      def self.build_created_by(shared_with_me_item_hash)
        created_by_hash = shared_with_me_item_hash.dig(:createdBy, :user)
        return unless created_by_hash

        UserDeserializer.create_from_hash(created_by_hash)
      end

      def self.build_last_modified_by(shared_with_me_item_hash)
        last_modified_by_hash = shared_with_me_item_hash.dig(:lastModifiedBy, :user)
        return unless last_modified_by_hash

        UserDeserializer.create_from_hash(last_modified_by_hash)
      end
    end
  end
end
