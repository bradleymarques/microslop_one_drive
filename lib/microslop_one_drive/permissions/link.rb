module MicroslopOneDrive
  module Permissions
    class Link
      attr_reader :web_url

      def initialize(web_url:)
        @web_url = web_url
      end
    end
  end
end
