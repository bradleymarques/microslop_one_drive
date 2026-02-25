module MicroslopOneDrive
  module Permissions
    class SharingLink < MicroslopOneDrive::Permissions::BasePermission
      # From https://learn.microsoft.com/en-us/onedrive/developer/rest-api/resources/permission?view=odsp-graph-online#sharing-links:
      #
      # > Permissions with a link facet represent sharing links created on the item. These are the most common kinds of
      # > permissions. Sharing links provide a unique URL that can be used to access a file or folder. They can be set
      # > up to grant access in a variety of ways. For example, you can use the createLink API to create a link that
      # > works for anyone signed into your organization, or you can create a link that works for anyone, without
      # > needing to sign in. You can use the invite API to create a link that only works for specific people, whether
      # > they're in your company or not.
      #
      # Concrete examples:
      #   1. https://learn.microsoft.com/en-us/onedrive/developer/rest-api/resources/permission?view=odsp-graph-online#view-link
      #   2. https://learn.microsoft.com/en-us/onedrive/developer/rest-api/resources/permission?view=odsp-graph-online#edit-link
      #   3. https://learn.microsoft.com/en-us/onedrive/developer/rest-api/resources/permission?view=odsp-graph-online#specific-people-link
      #
      attr_reader :has_password, :granted_to_list

      def initialize(id:, roles:, share_id:, link:, has_password:, granted_to_list:)
        super(id: id, roles: roles, share_id: share_id, link: link)
        @has_password = has_password
        @granted_to_list = granted_to_list
      end

      def view_link?
        link.view_link?
      end

      def edit_link?
        link.edit_link?
      end

      def specific_people_link?
        link.specific_people_link?
      end

      def anonymous_link?
        link.anonymous_link?
      end
    end
  end
end
