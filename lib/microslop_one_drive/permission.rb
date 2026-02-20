module MicroslopOneDrive
  class Permission
    attr_reader :identifier, :drive_item_id, :role, :audience

    def initialize(identifier:, drive_item_id:, role:, audience:)
      @identifier = identifier
      @drive_item_id = drive_item_id
      @role = role
      @audience = audience
    end
  end
end
