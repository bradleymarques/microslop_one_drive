module MicroslopOneDrive
  class OneDrivePermission
    attr_reader :identifier, :role, :audience

    def initialize(identifier:, role:, audience:)
      @identifier = identifier
      @role = role
      @audience = audience
    end
  end
end
