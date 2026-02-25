module MicroslopOneDrive
  module Endpoints
    module Site
      # Gets a SharePoint Site by its ID. If no site_id is provided, the current User's root SharePoint Site will be
      # returned.
      #
      # If the User's account does not support SharePoint, this method will return nil.
      #
      # @param site_id [String, nil] The ID of the SharePoint Site to get. If not provided, the current User's root
      # SharePoint Site will be returned.
      #
      # @return [MicroslopOneDrive::SharePointSite, nil]
      def site(site_id: nil)
        raise NotImplementedError, "Sites are not yet supported"
      end
    end
  end
end
