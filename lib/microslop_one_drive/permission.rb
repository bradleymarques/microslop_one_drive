module MicroslopOneDrive
  class Permission
    attr_reader :id, :drive_item_id, :role, :audience

    def initialize(id:, drive_item_id:, role:, audience:)
      @id = id
      @drive_item_id = drive_item_id
      @role = role
      @audience = audience
    end
  end
end
