module MicroslopOneDrive
  module Endpoints
    module Delta
      # Gets a delta of changes in a Drive.
      #
      # @param drive_id [String, nil] The ID of the Drive to get the delta of. If not provided, the current User's default
      # Drive will be used.
      # @param token [String, nil] The token to use for the delta. If not provided, the initial delta will be returned.
      #
      # @return [MicroslopOneDrive::DriveItemList]
      def delta(drive_id: nil, token: nil)
        url = drive_id.nil? ? "me/drive/root/delta" : "me/drives/#{drive_id}/root/delta"
        response = get(path: url, query: {token: token})
        handle_error(response) unless response.success?
        MicroslopOneDrive::ListResponses::DriveItemList.new(response.parsed_response)
      end
    end
  end
end
