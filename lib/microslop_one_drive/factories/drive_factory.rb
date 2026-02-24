require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Factories
    class DriveFactory
      # Creates a new Drive object from a hash.
      #
      # @param drive_hash [Hash] The hash to create the Drive object from.
      # @return [MicroslopOneDrive::Drive] The created Drive object.
      def self.create_from_hash(drive_hash)
        drive_hash = Utils.deep_symbolize_keys(drive_hash)

        id = drive_hash.fetch(:id, nil)
        name = drive_hash.fetch(:name, nil)
        description = drive_hash.fetch(:description, nil)
        web_url = drive_hash.fetch(:webUrl, nil)
        drive_type = drive_hash.fetch(:driveType, nil)
        created_date_time = Utils.safe_parse_time(drive_hash.fetch(:createdDateTime, nil))
        last_modified_date_time = Utils.safe_parse_time(drive_hash.fetch(:lastModifiedDateTime, nil))

        created_by_hash = drive_hash.dig(:createdBy, :user)
        last_modified_by_hash = drive_hash.dig(:lastModifiedBy, :user)
        owner_hash = drive_hash.dig(:owner, :user)

        created_by = created_by_hash.nil? ? nil : UserFactory.create_from_hash(created_by_hash)
        last_modified_by = last_modified_by_hash.nil? ? nil : UserFactory.create_from_hash(last_modified_by_hash)
        owner = owner_hash.nil? ? nil : UserFactory.create_from_hash(owner_hash)
        quota = QuotaFactory.create_from_hash(drive_hash.fetch(:quota, {}))

        Drive.new(
          id: id,
          name: name,
          description: description,
          web_url: web_url,
          drive_type: drive_type,
          created_date_time: created_date_time,
          last_modified_date_time: last_modified_date_time,
          created_by: created_by,
          last_modified_by: last_modified_by,
          owner: owner,
          quota: quota
        )
      end
    end
  end
end
