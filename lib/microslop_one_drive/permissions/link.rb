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

      def view_link?
        type == "view"
      end

      def edit_link?
        type == "edit"
      end

      def specific_people_link?
        scope == "users"
      end

      def anonymous_link?
        scope == "anonymous"
      end
    end
  end
end
