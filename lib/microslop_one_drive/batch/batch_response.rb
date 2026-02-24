module MicroslopOneDrive
  module Batch
    class BatchResponse
      attr_reader :responses

      def initialize
        @responses = []
      end

      def add_response(response)
        @responses << response
      end
    end
  end
end
