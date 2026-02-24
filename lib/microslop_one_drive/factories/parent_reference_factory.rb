require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Factories
    class ParentReferenceFactory
      def self.create_from_hash(parent_reference_hash)
        parent_reference_hash = Utils.deep_symbolize_keys(parent_reference_hash)

        drive_type = parent_reference_hash.fetch(:driveType, nil)
        drive_id = parent_reference_hash.fetch(:driveId, nil)
        id = parent_reference_hash.fetch(:id, nil)
        name = parent_reference_hash.fetch(:name, nil)
        path = parent_reference_hash.fetch(:path, nil)
        site_id = parent_reference_hash.fetch(:siteId, nil)

        ParentReference.new(
          drive_type: drive_type,
          drive_id: drive_id,
          id: id,
          name: name,
          path: path,
          site_id: site_id
        )
      end
    end
  end
end
