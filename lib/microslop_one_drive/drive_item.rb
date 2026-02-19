module MicroslopOneDrive
  class DriveItem
    DIRECTORY_MIME_TYPE = "inode/directory".freeze

    attr_reader :identifier,
                :name,
                :created_at,
                :updated_at,
                :url,
                :size,
                :file_or_folder,
                :parent_identifier,
                :mime_type

    def initialize(item_hash)
      @item_hash = item_hash

      @identifier = @item_hash.fetch("id", nil)
      @name = @item_hash.fetch("name", nil)
      @url = @item_hash.fetch("webUrl", nil)
      @size = @item_hash.fetch("size", nil)

      @created_at = Utils.safe_parse_time(@item_hash.fetch("createdDateTime", nil))
      @updated_at = Utils.safe_parse_time(@item_hash.fetch("lastModifiedDateTime", nil))

      if @item_hash.key?("file")
        @file_or_folder = :file
        @mime_type = @item_hash.dig("file", "mimeType")
      elsif @item_hash.key?("folder")
        @file_or_folder = :folder
        @mime_type = DIRECTORY_MIME_TYPE
      end

      @parent_identifier = @item_hash.dig("parentReference", "id")
    end

    def shared?
      @item_hash.key?("shared")
    end

    def file?
      @file_or_folder == :file
    end

    def folder?
      @file_or_folder == :folder
    end
  end
end
