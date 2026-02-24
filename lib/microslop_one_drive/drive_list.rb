module MicroslopOneDrive
  class DriveList < ListResponse
    attr_reader :drives

    def initialize(response_hash)
      super

      @drives = response_hash.fetch("value", []).map do
        MicroslopOneDrive::Factories::DriveFactory.create_from_hash(it)
      end
    end
  end
end
