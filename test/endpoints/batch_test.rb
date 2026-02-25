require "test_helper"

module MicroslopOneDrive
  module Endpoints
    class BatchTest < BaseTest
      def setup
        @access_token = "mock_access_token"
        @client = MicroslopOneDrive::Client.new(@access_token)
      end

      def test_batch_raises_an_error_if_an_error_is_returned_by_microsoft
        requests = [
          {id: "1", method: "GET", url: "/me"}
        ]

        mock_post(
          path: "$batch",
          expected_body: {requests: requests}.to_json,
          response_code: 400,
          success: false,
          parsed_response: fixture_response("batch/invalid_format.json")
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.batch(requests: requests)
        end

        assert_equal 400, error.response_code
        assert_equal "Invalid batch payload format.", error.response_body["error"]["message"]
      end

      def test_batch_raises_an_error_for_non_unique_request_ids
        requests = [
          {id: "1", method: "GET", url: "/me"},
          {id: "1", method: "GET", url: "/me"}
        ]

        mock_post(
          path: "$batch",
          expected_body: {requests: requests}.to_json,
          response_code: 400,
          success: false,
          parsed_response: fixture_response("batch/non_unique_ids.json")
        )

        error = assert_raises MicroslopOneDrive::Errors::ClientError do
          @client.batch(requests: requests)
        end

        assert_equal 400, error.response_code
        assert_equal "Request Id 1 has to be unique in a batch.", error.response_body["error"]["message"]
      end

      def test_batch_for_no_requests
        requests = []
        batch_response = @client.batch(requests: requests)
        assert_kind_of MicroslopOneDrive::Batch::BatchResponse, batch_response
        assert_equal 0, batch_response.responses.size
      end

      def test_batch_for_one_request
        requests = [
          {id: "1", method: "GET", url: "/me"}
        ]

        mock_post(
          path: "$batch",
          expected_body: {requests: requests}.to_json,
          response_code: 200,
          success: true,
          parsed_response: fixture_response("batch/one_response.json")
        )

        batch_response = @client.batch(requests: requests)
        assert_kind_of MicroslopOneDrive::Batch::BatchResponse, batch_response
        assert_equal 1, batch_response.responses.size

        response = batch_response.responses.first
        assert_kind_of MicroslopOneDrive::Batch::Response, response

        assert_equal "1", response.id
        assert_equal 200, response.status
        assert response.headers
        assert response.body

        assert response.success?
      end

      def test_batch_for_multiple_requests
        requests = [
          {id: "1", method: "GET", url: "/me"},
          {id: "2", method: "GET", url: "/me"}
        ]

        mock_post(
          path: "$batch",
          expected_body: {requests: requests}.to_json,
          response_code: 200,
          success: true,
          parsed_response: fixture_response("batch/multiple_responses.json")
        )

        batch_response = @client.batch(requests: requests)
        assert_kind_of MicroslopOneDrive::Batch::BatchResponse, batch_response
        assert_equal 2, batch_response.responses.size

        response1 = batch_response.responses[0]
        assert_kind_of MicroslopOneDrive::Batch::Response, response1
        response2 = batch_response.responses[1]
        assert_kind_of MicroslopOneDrive::Batch::Response, response2

        assert_equal "1", response1.id
        assert_equal 200, response1.status
        assert response1.success?

        assert_equal "2", response2.id
        assert_equal 200, response2.status
        assert response2.success?
      end

      def test_batch_for_multiple_requests_where_some_responses_are_invalid
        requests = [
          {id: "1", method: "GET", url: "/me"},
          {id: "2", method: "GET", url: "/me/this/is/not/a/valid/url"}
        ]

        mock_post(
          path: "$batch",
          expected_body: {requests: requests}.to_json,
          response_code: 200,
          success: true,
          parsed_response: fixture_response("batch/some_responses_invalid.json")
        )

        batch_response = @client.batch(requests: requests)
        assert_kind_of MicroslopOneDrive::Batch::BatchResponse, batch_response
        assert_equal 2, batch_response.responses.size

        response1 = batch_response.responses[0]
        assert_kind_of MicroslopOneDrive::Batch::Response, response1
        response2 = batch_response.responses[1]
        assert_kind_of MicroslopOneDrive::Batch::Response, response2

        assert_equal "1", response1.id
        assert_equal 200, response1.status
        assert_equal true, response1.success?

        assert_equal "2", response2.id
        assert_equal 404, response2.status
        assert_equal false, response2.success?
      end

      def test_batch_for_the_maximum_number_of_requests
        requests = (1..20).map { {id: it.to_s, method: "GET", url: "/me"} }

        mock_post(
          path: "$batch",
          expected_body: {requests: requests}.to_json,
          response_code: 200,
          success: true,
          parsed_response: fixture_response("batch/twenty_responses.json")
        )

        batch_response = @client.batch(requests: requests)
        assert_kind_of MicroslopOneDrive::Batch::BatchResponse, batch_response
        assert_equal 20, batch_response.responses.size

        assert batch_response.responses.all?(&:success?)
      end

      def test_batch_for_more_than_the_maximum_number_of_requests_effectively_makes_multiple_requests
        requests = (1..21).map { {id: it.to_s, method: "GET", url: "/me"} }

        mock_post(
          path: "$batch",
          expected_body: {requests: requests.first(20)}.to_json,
          response_code: 200,
          success: true,
          parsed_response: fixture_response("batch/twenty_responses.json")
        )

        mock_post(
          path: "$batch",
          expected_body: {requests: requests.last(1)}.to_json,
          response_code: 200,
          success: true,
          parsed_response: fixture_response("batch/one_response.json")
        )

        batch_response = @client.batch(requests: requests)
        assert_kind_of MicroslopOneDrive::Batch::BatchResponse, batch_response
        assert_equal 21, batch_response.responses.size

        assert batch_response.responses.all?(&:success?)
      end
    end
  end
end
