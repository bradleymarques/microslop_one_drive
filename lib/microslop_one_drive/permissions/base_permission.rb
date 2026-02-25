module MicroslopOneDrive
  module Permissions
    class BasePermission
      attr_accessor :drive_item_id
      attr_reader :id, :roles, :share_id, :link

      def initialize(id:, roles:, share_id:, link:, drive_item_id: nil)
        @id = id
        @roles = roles
        @share_id = share_id
        @link = link
        @drive_item_id = drive_item_id
      end
    end
  end
end
