module MicroslopOneDrive
  class DriveItemList < ListResponse
    attr_reader :items

    def initialize(parsed_response)
      super(parsed_response)

      @parsed_response = parsed_response
      @items = build_items
    end

    private

    def build_items
      items = @parsed_response.fetch("value", []).map do
        MicroslopOneDrive::DriveItem.new(it)
      end

      set_parent_and_child_relationships(items)
    end

    def set_parent_and_child_relationships(items)
      items.each do |item|
        next if item.parent_id.nil?
        parent = items.find { it.id == item.parent_id }
        next if parent.nil?

        item.set_parent(parent)
      end
    end
  end
end
