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
        return false if response_indicates_no_sites?(response)

        handle_error(response)
      end

      private

      def response_indicates_no_sites?(response)
        response.bad_request? &&
        response.parsed_response.dig("error", "code") == "BadRequest" &&
        response.parsed_response.dig("error", "message").match?(/This API is not supported for MSA accounts/i)
      end
    end
  end
end
