require "httparty"
require "json"

require_relative "microslop_one_drive/version"
require_relative "microslop_one_drive/utils"

# Deserializers
require_relative "microslop_one_drive/deserializers/user_deserializer"
require_relative "microslop_one_drive/deserializers/drive_deserializer"
require_relative "microslop_one_drive/deserializers/quota_deserializer"
require_relative "microslop_one_drive/deserializers/drive_item_deserializer"
require_relative "microslop_one_drive/deserializers/parent_reference_deserializer"
require_relative "microslop_one_drive/deserializers/shared_with_me_item_deserializer"
require_relative "microslop_one_drive/deserializers/permission_deserializer"
require_relative "microslop_one_drive/deserializers/link_deserializer"
require_relative "microslop_one_drive/deserializers/identity_deserializer"
require_relative "microslop_one_drive/deserializers/application_deserializer"
require_relative "microslop_one_drive/deserializers/group_deserializer"
require_relative "microslop_one_drive/deserializers/device_deserializer"

# Drive items
require_relative "microslop_one_drive/file"
require_relative "microslop_one_drive/folder"
require_relative "microslop_one_drive/root_folder"
require_relative "microslop_one_drive/drive_item"

# List Responses
require_relative "microslop_one_drive/list_responses/list_response"
require_relative "microslop_one_drive/list_responses/drive_list"
require_relative "microslop_one_drive/list_responses/drive_item_list"
require_relative "microslop_one_drive/list_responses/permission_list"
require_relative "microslop_one_drive/list_responses/shared_with_me_list"

# Batch
require_relative "microslop_one_drive/batch/batch_response"
require_relative "microslop_one_drive/batch/response"

# Other models
require_relative "microslop_one_drive/audiences/base_audience"
require_relative "microslop_one_drive/audiences/user"
require_relative "microslop_one_drive/audiences/application"
require_relative "microslop_one_drive/audiences/group"
require_relative "microslop_one_drive/audiences/device"
require_relative "microslop_one_drive/parent_reference"
require_relative "microslop_one_drive/drive"
require_relative "microslop_one_drive/quota"
require_relative "microslop_one_drive/shared_with_me_item"
require_relative "microslop_one_drive/permissions/base_permission"
require_relative "microslop_one_drive/permissions/direct_permission"
require_relative "microslop_one_drive/permissions/sharing_link"
require_relative "microslop_one_drive/permissions/sharing_invitation"
require_relative "microslop_one_drive/permissions/link"

# Endpoints
require_relative "microslop_one_drive/endpoints/me"
require_relative "microslop_one_drive/endpoints/drive"
require_relative "microslop_one_drive/endpoints/all_drives"
require_relative "microslop_one_drive/endpoints/drive_exists"
require_relative "microslop_one_drive/endpoints/drive_item"
require_relative "microslop_one_drive/endpoints/drive_item_exists"
require_relative "microslop_one_drive/endpoints/delta"
require_relative "microslop_one_drive/endpoints/permissions"
require_relative "microslop_one_drive/endpoints/batch"
require_relative "microslop_one_drive/endpoints/batch_permissions"
require_relative "microslop_one_drive/endpoints/delete_permission"
require_relative "microslop_one_drive/endpoints/supports_sites"
require_relative "microslop_one_drive/endpoints/revoke_grants"

# Client
require_relative "microslop_one_drive/errors/client_error"
require_relative "microslop_one_drive/client"
