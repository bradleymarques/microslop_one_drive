module MicroslopOneDrive
  module Batch
    class Response
      attr_reader :id, :status, :headers, :body

      def initialize(response_hash)
        @id = response_hash.fetch("id")
        @status = response_hash.fetch("status")
        @headers = response_hash.fetch("headers")
        @body = response_hash.fetch("body")
      end

      def success?
        @status.between?(200, 299)
      end
    end
  end
end
