require "httparty"
require "json"

# Utilities
require_relative "microslop_one_drive/version"
require_relative "microslop_one_drive/utils"
require_relative "microslop_one_drive/deserializers/deserializers"

# Models
require_relative "microslop_one_drive/file"
require_relative "microslop_one_drive/folder"
require_relative "microslop_one_drive/root_folder"
require_relative "microslop_one_drive/drive_item"
require_relative "microslop_one_drive/list_responses/list_responses"
require_relative "microslop_one_drive/batch/batch"
require_relative "microslop_one_drive/identity_sets/identity_sets"
require_relative "microslop_one_drive/parent_reference"
require_relative "microslop_one_drive/drive"
require_relative "microslop_one_drive/quota"
require_relative "microslop_one_drive/shared_with_me_item"
require_relative "microslop_one_drive/permissions/permissions"

# Client
require_relative "microslop_one_drive/endpoints/endpoints"
require_relative "microslop_one_drive/errors/errors"
require_relative "microslop_one_drive/client"
