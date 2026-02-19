module MicroslopOneDrive
  class Drive
    attr_reader :id, :name, :url, :drive_type

    def initialize(drive_hash)
      @drive_hash = drive_hash

      @id = drive_hash.fetch("id", nil)
      @name = drive_hash.fetch("name", nil)
      @url = drive_hash.fetch("webUrl", nil)
      @drive_type = drive_hash.fetch("driveType", nil)
    end
  end
end
