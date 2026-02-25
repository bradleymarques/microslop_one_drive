module MicroslopOneDrive
  module Permissions
    class DirectPermission < MicroslopOneDrive::Permissions::BasePermission
      # A direct permission is a permission that is granted to a specific user or group.
      attr_reader :granted_to

      def initialize(id:, roles:, share_id:, link:, granted_to:)
        super(id: id, roles: roles, share_id: share_id, link: link)
        @granted_to = granted_to
      end
    end
  end
end
