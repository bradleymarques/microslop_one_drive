module MicroslopOneDrive
  class Drive
    attr_reader :id, :name, :description, :web_url, :drive_type, :created_date_time, :last_modified_date_time,
                :created_by, :last_modified_by, :owner, :quota

    def initialize(
      id:,
      name:,
      description:,
      web_url:,
      drive_type:,
      created_date_time:,
      last_modified_date_time:,
      created_by:,
      last_modified_by:,
      owner:,
      quota:
    )
      @id = id
      @name = name
      @description = description
      @web_url = web_url
      @drive_type = drive_type
      @created_date_time = created_date_time
      @last_modified_date_time = last_modified_date_time
      @created_by = created_by
      @last_modified_by = last_modified_by
      @owner = owner
      @quota = quota
    end

    def created_at
      @created_date_time
    end

    def updated_at
      @last_modified_date_time
    end

    def url
      @web_url
    end

    def updated_by
      @last_modified_by
    end
  end
end
