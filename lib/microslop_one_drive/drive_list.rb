module MicroslopOneDrive
  class DriveList < ListResponse
    attr_reader :drives

    def initialize(response_hash)
      super(response_hash)

      @drives = response_hash.fetch("value", []).map do
        MicroslopOneDrive::Drive.new(it)
      end
    end
  end
end
