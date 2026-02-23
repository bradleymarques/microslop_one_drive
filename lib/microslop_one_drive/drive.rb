module MicroslopOneDrive
  class Drive
    attr_reader :id, :name, :description, :url, :drive_type, :created_at, :updated_at

    def initialize(drive_hash)
      @drive_hash = drive_hash

      @id = drive_hash.fetch("id", nil)
      @name = drive_hash.fetch("name", nil)
      @description = drive_hash.fetch("description", nil)
      @url = drive_hash.fetch("webUrl", nil)
      @drive_type = drive_hash.fetch("driveType", nil)

      @created_at = Utils.safe_parse_time(drive_hash.fetch("createdDateTime", nil))
      @updated_at = Utils.safe_parse_time(drive_hash.fetch("lastModifiedDateTime", nil))
    end
  end
end
