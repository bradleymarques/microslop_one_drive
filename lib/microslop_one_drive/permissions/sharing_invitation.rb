module MicroslopOneDrive
  module Permissions
    class SharingInvitation < MicroslopOneDrive::Permissions::BasePermission
      # From https://learn.microsoft.com/en-us/onedrive/developer/rest-api/resources/permission?view=odsp-graph-online#sharing-invitations:
      #
      # > Permissions sent by the invite API may have additional information in the invitation facet. If an invitation
      # > was sent to an email address that doesn't match a known account, the grantedTo property may not be set until
      # > the invitation is redeemed, which occurs the first time the user clicks the link and signs in.
      #
    end
  end
end
