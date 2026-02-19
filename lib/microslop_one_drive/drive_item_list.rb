module MicroslopOneDrive
  class DriveItemList < ListResponse
    attr_reader :items

    def initialize(parsed_response)
      super(parsed_response)

      @items = parsed_response.fetch("value", []).map do
        MicroslopOneDrive::DriveItem.new(it)
      end
    end
  end
end
