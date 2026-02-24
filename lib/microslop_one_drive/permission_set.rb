module MicroslopOneDrive
  class PermissionSet
    attr_reader :id, :role, :audiences

    def initialize(drive_item_id:, parsed_response:)
      @drive_item_id = drive_item_id
      @id = parsed_response.fetch("id", nil)
      @role = build_role(parsed_response)
      @audiences = build_audiences(parsed_response)
    end

    def to_permissions
      @audiences.map { Permission.new(id: @id, drive_item_id: @drive_item_id, role: @role, audience: it) }
    end

    private

    def build_role(parsed_response)
      roles = parsed_response.fetch("roles", [])
      roles.is_a?(Array) ? roles.first : roles
    end

    def build_audiences(parsed_response)
      audiences = []

      audiences += audiences_from_site_users(parsed_response)
      audiences += audiences_from_anonymous_links(parsed_response)

      audiences.compact
    end

    def audiences_from_site_users(parsed_response)
      site_users = []
      site_users += parsed_response.fetch("grantedToIdentitiesV2", []).flat_map { it.fetch("siteUser", nil) }
      site_users << parsed_response.dig("grantedToV2", "siteUser")
      site_users.compact!

      site_users.map { Audience.from_site_user(it) }
    end

    def audiences_from_anonymous_links(parsed_response)
      link = parsed_response.fetch("link", nil)
      return [] if link.nil? || (link.respond_to?(:empty?) && link.empty?)

      link_scope = link.fetch("scope", nil)

      return [] unless link_scope == "anonymous" # I.e. an "anyone with the link" audience

      [
        Audience.new(
          type: "anyone",
          id: "anyone_with_the_link",
          display_name: "Anyone with the link",
          email_address: nil
        )
      ]
    end
  end
end
