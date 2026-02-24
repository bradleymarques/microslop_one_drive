require "microslop_one_drive/drive_item"

module MicroslopOneDrive
  class Folder < DriveItem
    def folder?
      true
    end

    def file?
      false
    end
  end
end
