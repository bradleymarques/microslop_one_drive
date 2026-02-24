require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class DriveDeserializer
      # Creates a new Drive object from a hash.
      #
      # @param drive_hash [Hash] The hash to create the Drive object from.
      # @return [MicroslopOneDrive::Drive] The created Drive object.
      def self.create_from_hash(drive_hash)
        drive_hash = Utils.deep_symbolize_keys(drive_hash)

        created_by = build_created_by(drive_hash)
        last_modified_by = build_last_modified_by(drive_hash)
        owner = build_owner(drive_hash)

        Drive.new(
          id: drive_hash.fetch(:id, nil),
          name: drive_hash.fetch(:name, nil),
          description: drive_hash.fetch(:description, nil),
          web_url: drive_hash.fetch(:webUrl, nil),
          drive_type: drive_hash.fetch(:driveType, nil),
          created_date_time: Utils.safe_parse_time(drive_hash.fetch(:createdDateTime, nil)),
          last_modified_date_time: Utils.safe_parse_time(drive_hash.fetch(:lastModifiedDateTime, nil)),
          created_by: created_by,
          last_modified_by: last_modified_by,
          owner: owner,
          quota: QuotaDeserializer.create_from_hash(drive_hash.fetch(:quota, {}))
        )
      end

      def self.build_created_by(drive_hash)
        created_by_hash = drive_hash.dig(:createdBy, :user)

        return unless created_by_hash

        UserDeserializer.create_from_hash(created_by_hash)
      end

      def self.build_last_modified_by(drive_hash)
        last_modified_by_hash = drive_hash.dig(:lastModifiedBy, :user)

        return unless last_modified_by_hash

        UserDeserializer.create_from_hash(last_modified_by_hash)
      end

      def self.build_owner(drive_hash)
        owner_hash = drive_hash.dig(:owner, :user)

        return unless owner_hash

        UserDeserializer.create_from_hash(owner_hash)
      end
    end
  end
end
