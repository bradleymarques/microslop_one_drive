require "microslop_one_drive/drive_item"

module MicroslopOneDrive
  class File < DriveItem
    def folder?
      false
    end

    def file?
      true
    end
  end
end
