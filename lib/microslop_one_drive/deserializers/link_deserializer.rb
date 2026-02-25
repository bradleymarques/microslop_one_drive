module MicroslopOneDrive
  module Deserializers
    class LinkDeserializer
      def self.create_from_hash(link_hash)
        link_hash = Utils.deep_symbolize_keys(link_hash)

        MicroslopOneDrive::Permissions::Link.new(
          web_url: link_hash.fetch(:webUrl, nil),
          scope: link_hash.fetch(:scope, nil),
          type: link_hash.fetch(:type, nil),
          prevents_download: link_hash.fetch(:preventsDownload, false)
        )
      end
    end
  end
end
