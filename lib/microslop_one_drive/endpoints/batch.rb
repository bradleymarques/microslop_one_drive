module MicroslopOneDrive
  module Endpoints
    module Batch
      BATCH_REQUEST_LIMIT = 20 # This is set by Microsoft

      # Makes a batch request to the Microsoft Graph API.
      #
      # @param requests [Array<Hash>] The requests to make. Each request should be a hash with the following keys:
      #   - id: The ID of the request.
      #   - method: The HTTP method to use for the request.
      #   - url: The URL to make the request to.
      #
      # Note: Microsoft allows a maximum of 20 requests per batch. If you pass more than 20 requests, the client will
      # make multiple batch requests to Microsoft. This might make this a slow method.
      #
      # @return [MicroslopOneDrive::BatchResponse]
      def batch(requests:)
        batch_response = MicroslopOneDrive::Batch::BatchResponse.new

        # No requests, so simply return an empty batch response:
        return batch_response if requests.empty?

        batches = requests.each_slice(BATCH_REQUEST_LIMIT).to_a
        batches.each do
          response = post(path: "$batch", body: {requests: it}.to_json)
          handle_error(response) unless response.success?
          new_responses = response.parsed_response.fetch("responses", [])
          new_responses.each do
            batch_response.add_response(MicroslopOneDrive::Batch::Response.new(it))
          end
        end

        batch_response
      end
    end
  end
end
