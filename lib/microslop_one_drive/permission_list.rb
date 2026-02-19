module MicroslopOneDrive
  class PermissionList < ListResponse
    attr_reader :permissions

    def initialize(parsed_response)
      super(parsed_response)

      @parsed_response = parsed_response
      @permissions = build_permissions
    end

    private

    def build_permissions
      value_list = @parsed_response.is_a?(Array) ? @parsed_response : @parsed_response.fetch("value", [])
      permission_batches = value_list.map { MicroslopOneDrive::PermissionBatch.new(it) }

      # At this stage, the permissions could contain multiple Audiences for the same Permission.
      # This is because OneDrive can return multiple permissions for the same thing.
      # For example, a file shared with one person and a public link will return in a single permission object.
      # We therefore need to "explode" the permissions into multiple permissions, one for each Audience.
      permission_batches.flat_map(&:to_permissions)
    end
  end
end
