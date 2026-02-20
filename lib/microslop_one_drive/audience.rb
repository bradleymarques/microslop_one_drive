module MicroslopOneDrive
  class Audience
    attr_reader :type, :id, :display_name, :email_address

    def initialize(type:, id:, display_name:, email_address: nil)
      @type = type
      @id = id
      @display_name = display_name
      @email_address = email_address
    end

    # Converts a "siteUser" object into an OneDriveAudience object.
    #
    # A siteUser object looks like this:
    #
    # {
    #   "displayName" => "Bob Bentley",
    #   "email" => "bob@haikucode.dev",
    #   "id" => "12",
    #   "loginName" => "i:0#.f|membership|bob@haikucode.dev"
    # }
    #
    def self.from_site_user(site_user)
      new(
        type: "user",
        id: site_user.fetch("email"),
        display_name: site_user.fetch("displayName"),
        email_address: site_user.fetch("email")
      )
    end
  end
end
