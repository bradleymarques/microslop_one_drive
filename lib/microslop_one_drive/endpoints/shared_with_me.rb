module MicroslopOneDrive
  module Endpoints
    module SharedWithMe
      # Gets the Drive Items shared with the current user.
      #
      # @return [MicroslopOneDrive::SharedWithMeList]
      def shared_with_me
        response = get(path: "me/drive/sharedWithMe")
        handle_error(response) unless response.success?
        MicroslopOneDrive::ListResponses::SharedWithMeList.new(response.parsed_response)
      end
    end
  end
end
