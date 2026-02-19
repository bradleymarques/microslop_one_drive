module MicroslopOneDrive
  class User
    attr_reader :email_address, :display_name

    def initialize(user_hash)
      @user_hash = user_hash

      @email_address = @user_hash.fetch("mail", nil)
      @display_name = @user_hash.fetch("displayName", nil)
    end
  end
end
