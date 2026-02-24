module MicroslopOneDrive
  class SharedWithMeItem
    attr_reader :id, :name, :web_url, :size, :last_modified_date_time, :created_date_time, :created_by,
                :last_modified_by

    def initialize(
      id:,
      name:,
      web_url:,
      size:,
      last_modified_date_time:,
      created_date_time:,
      created_by:,
      last_modified_by:
    )
      @id = id
      @name = name
      @web_url = web_url
      @size = size
      @last_modified_date_time = last_modified_date_time
      @created_date_time = created_date_time
      @created_by = created_by
      @last_modified_by = last_modified_by
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
  end
end
