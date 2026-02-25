module MicroslopOneDrive
  module Endpoints
    module SupportsSites
      # Asks if the user's account supports SharePoint.
      #
      # Does this by checking if the user's account has a root SharePoint Site.
      #
      # @return [Boolean]
      def supports_sites?
        response = get(path: "me/sites/root", query: {})

        return true if response.success?
        return false if response.bad_request? && response.parsed_response["error"]["code"] == "BadRequest"

        handle_error(response)
      end
    end
  end
end
