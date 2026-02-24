module MicroslopOneDrive
  class ParentReference
    attr_reader :drive_type, :drive_id, :id, :name, :path, :site_id

    def initialize(drive_type:, drive_id:, id:, name:, path:, site_id:)
      @drive_type = drive_type
      @drive_id = drive_id
      @id = id
      @name = name
      @path = path
      @site_id = site_id
    end
  end
end
