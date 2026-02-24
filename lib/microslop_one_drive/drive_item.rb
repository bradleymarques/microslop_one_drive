module MicroslopOneDrive
  class DriveItem
    DIRECTORY_MIME_TYPE = "inode/directory".freeze

    attr_reader :id,
                :name,
                :download_url,
                :web_url,
                :size,
                :created_date_time,
                :last_modified_date_time,
                :e_tag,
                :c_tag,
                :file_or_folder,
                :mime_type,
                :parent_reference,
                :is_deleted,
                :is_shared

    def initialize(
      id:,
      name:,
      download_url:,
      web_url:,
      size:,
      created_date_time:,
      last_modified_date_time:,
      e_tag:,
      c_tag:,
      file_or_folder:,
      mime_type:,
      parent_reference:,
      is_deleted:,
      is_shared:
    )
      @id = id
      @name = name
      @download_url = download_url
      @web_url = web_url
      @size = size
      @created_date_time = created_date_time
      @last_modified_date_time = last_modified_date_time
      @e_tag = e_tag
      @c_tag = c_tag
      @file_or_folder = file_or_folder
      @mime_type = mime_type
      @parent_reference = parent_reference
      @is_deleted = is_deleted
      @is_shared = is_shared
    end

    def deleted?
      @is_deleted
    end

    def shared?
      @is_shared
    end

    def file?
      @file_or_folder == :file
    end

    def folder?
      @file_or_folder == :folder
    end

    def created_at
      @created_date_time
    end

    def updated_at
      @last_modified_date_time
    end

    def root?
      @item_hash.key?("root")
    end

    private

    def build_path
      return "root:" if root?

      full_parent_path = @item_hash.dig("parentReference", "path")
      return nil if full_parent_path.nil?

      full_path_with_name = File.join(full_parent_path, @name)
      full_path_with_name.sub(%r{\A.*root:/}, "root:/")
    end
  end
end
