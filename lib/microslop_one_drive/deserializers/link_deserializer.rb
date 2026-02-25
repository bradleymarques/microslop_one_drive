module MicroslopOneDrive
  module Deserializers
    class LinkDeserializer
      def self.create_from_hash(link_hash)
        link_hash = Utils.deep_symbolize_keys(link_hash)

        MicroslopOneDrive::Permissions::Link.new(web_url: link_hash.fetch(:webUrl, nil))
      end
    end
  end
end
