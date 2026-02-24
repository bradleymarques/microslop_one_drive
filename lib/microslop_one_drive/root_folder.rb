require "microslop_one_drive/folder"

module MicroslopOneDrive
  class RootFolder < Folder
    def root?
      true
    end

    def build_full_path
      "/drive/root:"
    end
  end
end
