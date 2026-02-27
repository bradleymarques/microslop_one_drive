module MicroslopOneDrive
  module Endpoints
    module Me
      # Gets the current user
      #
      # @return [MicroslopOneDrive::Audiences::User]
      def me
        response = get(path: "me", query: {})
        handle_error(response) unless response.success?
        MicroslopOneDrive::Deserializers::UserDeserializer.create_from_hash(response.parsed_response)
      end
    end
  end
end
