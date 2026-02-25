module MicroslopOneDrive
  module Endpoints
    module AllDrives
      # Gets ALL Drives the current user has access to.
      #
      # NOTE: This will include some internal Microsoft drives that aren't real drives, such as AI, Face scans, and other
      # shitty things.
      #
      # @return [MicroslopOneDrive::DriveList]
      def all_drives
        response = get(path: "me/drives", query: {})
        handle_error(response) unless response.success?
        MicroslopOneDrive::ListResponses::DriveList.new(response.parsed_response)
      end
    end
  end
end
