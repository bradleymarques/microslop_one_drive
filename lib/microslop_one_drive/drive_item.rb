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
                :is_shared,
                :full_path,
                :path

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

      @full_path = build_full_path
      @path = build_path(@full_path)
    end

    def created_at
      @created_date_time
    end

    def updated_at
      @last_modified_date_time
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

    def root?
      false
    end

    def build_full_path
      return nil if parent_reference&.path.nil? || name.nil?

      ::File.join(parent_reference.path, name)
    end

    def build_path(full_path)
      return "" if full_path.nil?

      full_path.gsub(%r{\A/?drive/root:/?}, "").chomp("/")
    end
  end
end
