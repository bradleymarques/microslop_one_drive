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
require_relative "microslop_one_drive/user"
require_relative "microslop_one_drive/parent_reference"
require_relative "microslop_one_drive/drive"
require_relative "microslop_one_drive/permission_set"
require_relative "microslop_one_drive/permission"
require_relative "microslop_one_drive/audience"
require_relative "microslop_one_drive/quota"
require_relative "microslop_one_drive/shared_with_me_item"

# Endpoints
require_relative "microslop_one_drive/endpoints/me"
require_relative "microslop_one_drive/endpoints/drive"
require_relative "microslop_one_drive/endpoints/all_drives"
require_relative "microslop_one_drive/endpoints/drive_exists"
require_relative "microslop_one_drive/endpoints/drive_item"
require_relative "microslop_one_drive/endpoints/drive_item_exists"
require_relative "microslop_one_drive/endpoints/delta"
require_relative "microslop_one_drive/endpoints/shared_with_me"
require_relative "microslop_one_drive/endpoints/permissions"
require_relative "microslop_one_drive/endpoints/batch"
require_relative "microslop_one_drive/endpoints/batch_permissions"
require_relative "microslop_one_drive/endpoints/supports_sites"

# Client
require_relative "microslop_one_drive/errors/client_error"
require_relative "microslop_one_drive/client"
