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
require_relative "microslop_one_drive/list_responses/response"

# Other models
require_relative "microslop_one_drive/user"
require_relative "microslop_one_drive/parent_reference"
require_relative "microslop_one_drive/drive"
require_relative "microslop_one_drive/permission_set"
require_relative "microslop_one_drive/permission"
require_relative "microslop_one_drive/audience"
require_relative "microslop_one_drive/batch_response"
require_relative "microslop_one_drive/quota"

# Client
require_relative "microslop_one_drive/errors/client_error"
require_relative "microslop_one_drive/client"
