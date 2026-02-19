module MicroslopOneDrive
  class PermissionBatch
    # OneDrive roles to generic permission roles
    # @see https://learn.microsoft.com/en-us/onedrive/developer/rest-api/resources/permission#roles-enumeration
    ONE_DRIVE_TO_ROLE_MAP = {
      "read" => :viewer,
      "write" => :editor,
      "owner" => :owner,
      "member" => :editor
    }.freeze

    attr_reader :identifier, :role, :audiences

    def initialize(parsed_response)
      @parsed_response = parsed_response

      @identifier = @parsed_response.fetch("id", nil)
      @role = build_role
      @audiences = build_audiences
    end

    def to_permissions
      @audiences.map { Permission.new(identifier: @identifier, role: @role, audience: it) }
    end

    private

    def build_role
      roles = @parsed_response.fetch("roles", [])
      one_drive_role = roles.is_a?(Array) ? roles.first : roles
      ONE_DRIVE_TO_ROLE_MAP[one_drive_role] || raise("Unknown OneDrive role: '#{one_drive_role}'")
    end

    def build_audiences
      audiences = []

      audiences += audiences_from_site_users
      audiences += audiences_from_anonymous_links

      audiences.compact
    end

    def audiences_from_site_users
      site_users = []
      site_users += @parsed_response.fetch("grantedToIdentitiesV2", []).flat_map { it.fetch("siteUser", nil) }
      site_users << @parsed_response.dig("grantedToV2", "siteUser")
      site_users.compact!

      site_users.map { Audience.from_site_user(it) }
    end

    def audiences_from_anonymous_links
      link = @parsed_response.fetch("link", nil)
      return [] if link.nil? || (link.respond_to?(:empty?) && link.empty?)

      link_scope = link.fetch("scope", nil)

      return [] unless link_scope == "anonymous" # I.e. an "anyone with the link" audience

      [
        Audience.new(
          type: "anyone",
          identifier: "anyone_with_the_link",
          display_name: "Anyone with the link",
          email_address: nil
        )
      ]
    end
  end
end
