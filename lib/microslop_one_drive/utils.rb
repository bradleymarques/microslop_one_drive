require "time"

module MicroslopOneDrive
  module Utils
    def self.deep_symbolize_keys(hash)
      hash.transform_keys(&:to_sym).transform_values do
        case it
        when Hash then deep_symbolize_keys(it)
        when Array then it.map { it.is_a?(Hash) ? deep_symbolize_keys(it) : it }
        else it
        end
      end
    end

    def self.safe_parse_time(value)
      return nil if value.nil? || value.to_s.strip.empty?

      Time.parse(value)
    end
  end
end
