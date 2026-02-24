module MicroslopOneDrive
  class DriveItem
    DIRECTORY_MIME_TYPE = "inode/directory".freeze

    attr_reader :id,
                :name,
                :created_at,
                :updated_at,
                :url,
                :size,
                :file_or_folder,
                :parent_id,
                :mime_type,
                :parent,
                :children,
                :path,
                :full_path

    def initialize(item_hash)
      @item_hash = item_hash

      @id = @item_hash.fetch("id", nil)
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

      @parent_id = @item_hash.dig("parentReference", "id")

      @deleted = @item_hash.dig("deleted", "state") == "deleted"

      @path = build_path

      @parent = nil
      @children = []
    end

    def deleted?
      @deleted
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

    def set_parent(parent)
      @parent.remove_child(self) if @parent

      @parent = parent
      @parent.add_child(self)
    end

    def is_root?
      @item_hash.key?("root")
    end

    protected

    def add_child(child)
      @children << child
    end

    def remove_child(child)
      @children.delete(child)
    end

    private

    def build_path
      return "root:" if is_root?

      full_parent_path = @item_hash.dig("parentReference", "path")
      return nil if full_parent_path.nil?

      full_path_with_name = File.join(full_parent_path, @name)
      full_path_with_name.sub(%r{\A.*root:/}, "root:/")
    end
  end
end
