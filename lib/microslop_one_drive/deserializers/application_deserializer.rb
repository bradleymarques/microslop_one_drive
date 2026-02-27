module MicroslopOneDrive
  module Deserializers
    class ApplicationDeserializer
      def self.create_from_hash(application_hash)
        return nil if application_hash.nil?
        return nil if application_hash.empty?

        application_hash = Utils.deep_symbolize_keys(application_hash)

        MicroslopOneDrive::Audiences::Application.new(
          id: application_hash.fetch(:id, nil),
          display_name: application_hash.fetch(:displayName, nil)
        )
      end
    end
  end
end
