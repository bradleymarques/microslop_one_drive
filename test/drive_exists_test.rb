require "test_helper"

module MicroslopOneDrive
  class DriveExistsTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_drive_exists_returns_true_if_the_drive_exists
      drive_id = "0f097864e0cfea42"
      mock_get(
        path: "me/drives/#{drive_id}",
        parsed_response: fixture_response("drives/drive.json"),
        response_code: 200,
        success: true
      )

      assert_equal true, @client.drive_exists?(drive_id: drive_id)
    end

    def test_drive_exists_returns_false_if_if_an_invalid_request_is_returned
      drive_id = "not-a-drive"
      mock_get(
        path: "me/drives/#{drive_id}",
        parsed_response: fixture_response("invalid_request.json"),
        response_code: 404,
        success: false
      )

      assert_equal false, @client.drive_exists?(drive_id: drive_id)
    end
  end
end
