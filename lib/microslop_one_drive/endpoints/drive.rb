module MicroslopOneDrive
  module Endpoints
    module Drive
      # Gets a Drive.
      #
      # If no drive_id is provided, the current User's default Drive will be returned, else, the specific Drive identified
      # by the drive_id will be returned.
      #
      # From the docs:
      #
      # > Most users will only have a single Drive resource.
      # > Groups and Sites may have multiple Drive resources available.
      #
      # @param drive_id [String, nil] The ID of the Drive to get. If not provided, the current User's default Drive will
      # be returned.
      #
      # @return [MicroslopOneDrive::Drive]
      def drive(drive_id: nil)
        url = drive_id.nil? ? "me/drive" : "me/drives/#{drive_id}"
        response = get(path: url, query: {})

        handle_error(response) unless response.success?
        MicroslopOneDrive::Deserializers::DriveDeserializer.create_from_hash(response.parsed_response)
      end
    end
  end
end
