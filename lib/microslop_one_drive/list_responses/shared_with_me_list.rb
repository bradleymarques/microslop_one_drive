module MicroslopOneDrive
  module ListResponses
    class SharedWithMeList < ListResponse
      attr_reader :shared_with_me_items

      def initialize(response_hash)
        super

        @shared_with_me_items = response_hash.fetch("value", []).map do
          MicroslopOneDrive::Deserializers::SharedWithMeItemDeserializer.create_from_hash(it)
        end
      end
    end
  end
end
