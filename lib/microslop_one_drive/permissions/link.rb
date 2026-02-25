module MicroslopOneDrive
  module Permissions
    class Link
      attr_reader :web_url, :scope, :type, :prevents_download

      def initialize(web_url:, scope:, type:, prevents_download:)
        @web_url = web_url
        @scope = scope
        @type = type
        @prevents_download = prevents_download
      end
    end
  end
end
