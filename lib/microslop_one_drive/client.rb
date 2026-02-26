require "json"

module MicroslopOneDrive
  class Client
    BASE_URL = "https://graph.microsoft.com/v1.0".freeze

    include Endpoints::Me
    include Endpoints::Drive
    include Endpoints::AllDrives
    include Endpoints::DriveExists
    include Endpoints::DriveItem
    include Endpoints::DriveItemExists
    include Endpoints::Delta
    include Endpoints::Permissions
    include Endpoints::Batch
    include Endpoints::BatchPermissions
    include Endpoints::SupportsSites
    include Endpoints::DeletePermission
    include Endpoints::RevokeGrants

    # @param access_token [String] OAuth access token for Microsoft Graph.
    # @param logger [Object, nil] Optional logger (e.g. Rails.logger) that responds to +#info+, +#debug+, +#warn+, +#error+.
    #   When set, all API requests and responses are logged.
    def initialize(access_token, logger: nil)
      @access_token = access_token
      @logger = logger

      @headers = {
        "Authorization" => "Bearer #{@access_token}",
        "Content-Type" => "application/json",
        "Prefer" => "hierarchicalsharing"
      }
    end

    private

    def get(path:, query: {})
      url = "#{BASE_URL}/#{path}"
      log_request("GET", url, query: query)

      response = HTTParty.get(url, headers: @headers, query: query)
      log_response(response, "GET", url)

      response
    end

    def post(path:, body:)
      url = "#{BASE_URL}/#{path}"
      log_request("POST", url, body: body)

      response = HTTParty.post(url, headers: @headers, body: body)
      log_response(response, "POST", url)

      response
    end

    def delete(path:)
      url = "#{BASE_URL}/#{path}"
      log_request("DELETE", url, body: nil)

      response = HTTParty.delete(url, headers: @headers)
      log_response(response, "DELETE", url)

      response
    end

    def log_request(method, url, query: nil, body: nil)
      return unless @logger

      @logger.info ""
      @logger.info "==================== START MicroslopOneDrive #{method} #{url} ===================="
      @logger.info "Request method: #{method}"
      @logger.info "Request url: #{url}"
      @logger.info "Request query: #{query.inspect}" if query&.any?
      @logger.info "Request body: #{body.inspect}" if body
    end

    def log_response(response, method, url)
      return unless @logger

      @logger.info ""
      @logger.info "Response code: #{response.code}"
      @logger.info "Response body:" if response.parsed_response
      @logger.info JSON.pretty_generate(response.parsed_response) if response.parsed_response
      @logger.info "==================== END MicroslopOneDrive #{method} #{url} ===================="
    end

    def handle_error(response)
      error = MicroslopOneDrive::Errors::ClientError.new(response.parsed_response, response.code)
      raise error
    end
  end
end
