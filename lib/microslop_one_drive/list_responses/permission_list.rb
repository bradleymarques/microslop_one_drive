module MicroslopOneDrive
  module ListResponses
    class PermissionList < ListResponse
      attr_reader :permissions

      def initialize(drive_item_id:, parsed_response:)
        super(parsed_response)

        @permissions = build_permissions(drive_item_id, parsed_response)
      end

      private

      def build_permissions(drive_item_id, parsed_response)
        permissions = parsed_response.fetch("value", []).map do
          MicroslopOneDrive::Deserializers::PermissionDeserializer.create_from_hash(it)
        end

        permissions.each do
          it.drive_item_id = drive_item_id
        end

        permissions
      end
    end
  end
end
