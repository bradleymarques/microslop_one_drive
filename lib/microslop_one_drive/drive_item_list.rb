module MicroslopOneDrive
  class DriveItemList < ListResponse
    attr_reader :items

    def initialize(parsed_response)
      super

      @items = build_items(parsed_response)
    end

    private

    def build_items(parsed_response)
      parsed_response.fetch("value", []).map do
        MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(it)
      end
    end
  end
end
