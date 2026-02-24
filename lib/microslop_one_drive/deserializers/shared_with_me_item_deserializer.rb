require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class SharedWithMeItemDeserializer
      def self.create_from_hash(shared_with_me_item_hash)
        shared_with_me_item_hash = Utils.deep_symbolize_keys(shared_with_me_item_hash)

        SharedWithMeItem.new(
          id: shared_with_me_item_hash.fetch(:id, nil),
          name: shared_with_me_item_hash.fetch(:name, nil),
          web_url: shared_with_me_item_hash.fetch(:webUrl, nil),
          size: shared_with_me_item_hash.fetch(:size, nil),
          last_modified_date_time: Utils.safe_parse_time(shared_with_me_item_hash.fetch(:lastModifiedDateTime, nil)),
          created_date_time: Utils.safe_parse_time(shared_with_me_item_hash.fetch(:createdDateTime, nil))
        )
      end
    end
  end
end
