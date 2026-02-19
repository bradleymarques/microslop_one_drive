module MicroslopOneDrive
  module Errors
    class ClientError < StandardError
      attr_reader :response_body, :response_code

      def initialize(response_body, response_code)
        super(response_body)
        @response_body = response_body
        @response_code = response_code
      end
    end
  end
end
