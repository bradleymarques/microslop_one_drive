require "test_helper"
require "json"

module MicroslopOneDrive
  class LoggingTest < BaseTest

    def test_has_logging_disabled_by_default
      stubbed_response = fixture_response("deltas/delta_initial.json")

      access_token = "mock_access_token"
      mock_logger = mock
      mock_logger.expects(:info).never

      mock_get(path: "me/drives/drive-id/root/delta", parsed_response: stubbed_response)

      client = MicroslopOneDrive::Client.new(access_token)

      client.delta(drive_id: "drive-id")
    end

    def test_can_explicitly_disable_logging
      stubbed_response = fixture_response("deltas/delta_initial.json")

      access_token = "mock_access_token"
      mock_logger = mock
      mock_logger.expects(:info).never

      mock_get(path: "me/drives/drive-id/root/delta", parsed_response: stubbed_response)

      client = MicroslopOneDrive::Client.new(access_token, logger: nil)

      client.delta(drive_id: "drive-id")
    end

    def test_can_log_requests_and_responses
      stubbed_response = fixture_response("deltas/delta_initial.json")

      access_token = "mock_access_token"
      mock_logger = mock
      mock_logger.expects(:info).with("").times(2)
      mock_logger.expects(:info).with("==================== START MicroslopOneDrive GET https://graph.microsoft.com/v1.0/me/drives/drive-id/root/delta ====================")
      mock_logger.expects(:info).with("Request method: GET")
      mock_logger.expects(:info).with("Request url: https://graph.microsoft.com/v1.0/me/drives/drive-id/root/delta")
      mock_logger.expects(:info).with("Request query: {token: nil}")
      mock_logger.expects(:info).with("Response code: 200")
      mock_logger.expects(:info).with("Response body:")
      mock_logger.expects(:info).with(JSON.pretty_generate(stubbed_response))
      mock_logger.expects(:info).with("==================== END MicroslopOneDrive GET https://graph.microsoft.com/v1.0/me/drives/drive-id/root/delta ====================")

      mock_get(path: "me/drives/drive-id/root/delta",parsed_response: stubbed_response)

      client = MicroslopOneDrive::Client.new(access_token, logger: mock_logger)
      client.delta(drive_id: "drive-id")
    end
  end
end
