module MicroslopOneDrive
  class PermissionList < ListResponse
    attr_reader :permissions

    def initialize(drive_item_id:, parsed_response: )
      super(parsed_response)

      @drive_item_id = drive_item_id
      @parsed_response = parsed_response
      @permissions = build_permissions(@drive_item_id, @parsed_response)
    end

    private

    def build_permissions(drive_item_id, parsed_response)
      value_list = parsed_response.is_a?(Array) ? parsed_response : parsed_response.fetch("value", [])

      permission_sets = value_list.map do
        MicroslopOneDrive::PermissionSet.new(drive_item_id: drive_item_id, parsed_response: it)
      end

      # At this stage, the permissions could contain multiple Audiences for the same Permission.
      # This is because OneDrive can return multiple permissions for the same thing.
      # For example, a file shared with one person and a public link will return in a single permission object.
      # We therefore need to "explode" the permission sets into multiple permissions, one for each Audience.
      permission_sets.flat_map(&:to_permissions)
    end
  end
end
