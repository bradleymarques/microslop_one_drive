require "test_helper"

module MicroslopOneDrive
  class HandlesErrorsTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)

      @drive_id = "0f097864e0cfea42"
    end

    def test_handles_errors
      stubbed_response = stub(
        code: 400,
        success?: false,
        parsed_response: {
          error: {
            message: "error_message"
          }
        }
      )

      HTTParty
        .expects(:get)
        .with("#{MicroslopOneDrive::Client::BASE_URL}/me", headers: anything, query: anything)
        .returns(stubbed_response)

      error = assert_raises MicroslopOneDrive::Errors::ClientError do
        @client.me
      end

      assert_equal 400, error.response_code
      assert_equal({error: {message: "error_message"}}, error.response_body)
    end
  end
end
