module MicroslopOneDrive
  module Endpoints
    module DriveExists
      # Asks if a Drive exists by its ID.
      #
      # @param drive_id [String] The ID of the Drive to check.
      #
      # @return [Boolean]
      def drive_exists?(drive_id:)
        response = get(path: "me/drives/#{drive_id}", query: {})
        response.success?
      end
    end
  end
end
