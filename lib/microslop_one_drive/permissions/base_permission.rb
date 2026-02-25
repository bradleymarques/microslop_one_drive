module MicroslopOneDrive
  module Permissions
    class BasePermission
      attr_reader :id, :roles, :share_id, :link

      def initialize(id:, roles:, share_id:, link:)
        @id = id
        @roles = roles
        @share_id = share_id
        @link = link
      end
    end
  end
end
