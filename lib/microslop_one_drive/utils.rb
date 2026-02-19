require "time"

module MicroslopOneDrive
  module Utils
    def self.safe_parse_time(value)
      return nil if value.nil? || value.to_s.strip.empty?

      Time.parse(value)
    end
  end
end
