module MicroslopOneDrive
  class ListResponse
    attr_reader :next_link, :next_token, :delta_link, :delta_token, :context

    def initialize(response_hash)
      @response_hash = response_hash

      @context = response_hash.fetch("@odata.context", nil)

      @next_link = response_hash.fetch("@odata.nextLink", nil)
      @next_token = @next_link.split("?token=").last if @next_link && !@next_link.empty?

      @delta_link = response_hash.fetch("@odata.deltaLink", nil)
      @delta_token = @delta_link.split("?token=").last if @delta_link && !@delta_link.empty?
    end

    def next_page?
      !next_link.nil?
    end
  end
end
