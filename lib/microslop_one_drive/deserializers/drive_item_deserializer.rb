require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class DriveItemDeserializer
      # Creates a new DriveItem object from a hash.
      #
      # @param drive_item_hash [Hash] The hash to create the DriveItem object from.
      # @return [MicroslopOneDrive::DriveItem] The created DriveItem object.
      def self.create_from_hash(drive_item_hash)
        drive_item_hash = Utils.deep_symbolize_keys(drive_item_hash)

        id = drive_item_hash.fetch(:id, nil)
        name = drive_item_hash.fetch(:name, nil)

        download_url = drive_item_hash.fetch(:"@microsoft.graph.downloadUrl", nil)
        web_url = drive_item_hash.fetch(:webUrl, nil)

        size = drive_item_hash.fetch(:size, nil)

        created_date_time = Utils.safe_parse_time(drive_item_hash.fetch(:createdDateTime, nil))
        last_modified_date_time = Utils.safe_parse_time(drive_item_hash.fetch(:lastModifiedDateTime, nil))

        e_tag = drive_item_hash.fetch(:eTag, nil)
        c_tag = drive_item_hash.fetch(:cTag, nil)

        file_or_folder = drive_item_hash.key?(:file) ? :file : :folder
        mime_type = if file_or_folder == :file
                      drive_item_hash.dig(:file, :mimeType)
                    else
                      MicroslopOneDrive::DriveItem::DIRECTORY_MIME_TYPE
                    end

        parent_reference_hash = drive_item_hash.fetch(:parentReference, nil)
        parent_reference = (if parent_reference_hash
                              ParentReferenceDeserializer.create_from_hash(parent_reference_hash)
                            end)

        is_deleted = drive_item_hash.dig(:deleted, :state) == "deleted"
        is_shared = drive_item_hash.key?(:shared)

        parameters = {
          id: id,
          name: name,
          download_url: download_url,
          web_url: web_url,
          size: size,
          created_date_time: created_date_time,
          last_modified_date_time: last_modified_date_time,
          e_tag: e_tag,
          c_tag: c_tag,
          file_or_folder: file_or_folder,
          mime_type: mime_type,
          parent_reference: parent_reference,
          is_deleted: is_deleted,
          is_shared: is_shared
        }

        root = drive_item_hash.key?(:root) && file_or_folder == :folder

        if root
          RootFolder.new(**parameters)
        elsif file_or_folder == :file
          File.new(**parameters)
        elsif file_or_folder == :folder
          Folder.new(**parameters)
        else
          DriveItem.new(**parameters)
        end
      end
    end
  end
end
