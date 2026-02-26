module MicroslopOneDrive
  module Deserializers
    class PermissionDeserializer
      # Deserializes a hash into a Permission object. Permissions can be SharingLinks or SharingInvitations.
      def self.create_from_hash(permission_hash)
        permission_hash = Utils.deep_symbolize_keys(permission_hash)

        if sharing_link?(permission_hash)
          build_sharing_link(permission_hash)
        elsif sharing_invitation?(permission_hash)
          build_sharing_invitation(permission_hash)
        elsif direct_permission?(permission_hash)
          build_direct_permission(permission_hash)
        else
          raise NotImplementedError, "Unknown permission type for hash: #{permission_hash.inspect}"
        end
      end

      def self.build_common_parameters(permission_hash)
        link_hash = permission_hash.fetch(:link, nil)
        link = LinkDeserializer.create_from_hash(link_hash) if link_hash

        {
          id: permission_hash.fetch(:id, nil),
          roles: permission_hash.fetch(:roles, []),
          share_id: permission_hash.fetch(:shareId, nil),
          link: link
        }
      end

      def self.sharing_link?(permission_hash)
        link = permission_hash.fetch(:link, nil)
        return false if link.nil?

        link.key?(:scope) && link.key?(:type)
      end

      def self.sharing_invitation?(permission_hash)
        permission_hash.key?(:invitation)
      end

      def self.direct_permission?(permission_hash)
        permission_hash.key?(:grantedToV2)
      end

      def self.build_sharing_link(permission_hash)
        common_parameters = build_common_parameters(permission_hash)

        granted_to_hash_list = permission_hash.fetch(:grantedToIdentitiesV2, [])
        granted_to_list = granted_to_hash_list.map { GrantedToDeserializer.create_from_hash(it) }.compact

        has_password = permission_hash.fetch(:hasPassword, false)

        MicroslopOneDrive::Permissions::SharingLink.new(
          **common_parameters,
          granted_to_list: granted_to_list,
          has_password: has_password
        )
      end

      def self.build_sharing_invitation(permission_hash)
        common_parameters = build_common_parameters(permission_hash)
        MicroslopOneDrive::Permissions::SharingInvitation.new(**common_parameters)
      end

      def self.build_direct_permission(permission_hash)
        common_parameters = build_common_parameters(permission_hash)

        granted_to_hash = permission_hash.fetch(:grantedToV2, nil)
        granted_to = GrantedToDeserializer.create_from_hash(granted_to_hash)

        MicroslopOneDrive::Permissions::DirectPermission.new(**common_parameters, granted_to: granted_to)
      end
    end
  end
end
