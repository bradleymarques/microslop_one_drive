# MicroslopOneDrive

Microslop OneDrive API client.

See <https://learn.microsoft.com/en-us/onedrive/developer/rest-api/>

Graph explorer (API sandbox): <https://developer.microsoft.com/en-us/graph/graph-explorer>

## Installation

Add this to your Gemfile:

```rb
gem "microslop_one_drive"
```

## Usage

### Create a client

```rb
access_token = "..." # Get an access token via OAuth 2.0

client = MicroslopOneDrive::Client.new(access_token)
```

### Get the current user

```rb
me = client.me
me.class # => MicroslopOneDrive::User
me.email_address # => person@example.com
me.display_name # => Example Person
```

### Get a list of the user's Drives

```rb
drive_list = client.drives

drive_list.class # => MicroslopOneDrive::DriveList
drive_list.next_page? # => false
drive_list.drives # => [MicroslopOneDrive::Drive, ...]

drive = drive_list.drives.first
drive.class # => MicroslopOneDrive::Drive
drive.identifier # => "0f0**********42"
drive.name # => "OneDrive"
drive.url # => "https://my.microsoftpersonalcontent.com/..."
drive.drive_type # => "personal"
drive.created_at
drive.updated_at
```

### Get a single Drive

```rb
drive = client.drive(drive_id: "0f097********a42")

drive.class # => MicroslopOneDrive::Drive
drive.identifier # => "0f097********a42"
drive.name # => "OneDrive"
drive.url # => "https://my.microsoftpersonalcontent.com/personal/..."
drive.drive_type # => "personal"
```

### Get a delta of changes to a Drive

```rb
# Initial delta (all current items + token for later)
drive_item_list = client.delta(drive_id: "0f097********a42")

drive_item_list.class # => MicroslopOneDrive::DriveItemList
drive_item_list.items # => [MicroslopOneDrive::DriveItem, ...]

drive_item_list.next_page? # => true if more pages
drive_item_list.next_token # => use with delta(drive_id:, token:) for next page
drive_item_list.delta_link # => URL for incremental sync (when no next_page?)
drive_item_list.delta_token # => use with delta(drive_id:, token:) for incremental sync

# Next page (if next_page? was true)
client.delta(drive_id: "0f097********a42", token: drive_item_list.next_token)

# Incremental sync (only changes since last delta)
client.delta(drive_id: "0f097********a42", token: saved_delta_token)
```

Delta items have parent/child set: `item.parent`, `item.children`, and `item.path` (e.g. `"root:/folder/subfolder/file.txt"`).

### Get a DriveItem (file or folder)

```rb
item = client.drive_item(item_id: "F0**********42!sa466********************1479272d27")

item.class # => MicroslopOneDrive::DriveItem
item.name # => "Getting started with OneDrive.pdf"
item.identifier # => "F0**********42!sa466********************1479272d27"
item.url # => "https://onedrive.live.com?cid=..."
item.file? # => true
item.folder? # => false
item.mime_type # => "application/pdf"
item.size # => 1053417
item.created_at # => 2026-02-19 07:35:52 UTC
item.updated_at # => 2026-02-19 07:35:52 UTC
item.parent_identifier # => "F0**********42!sea8cc6b********************5c639"
item.deleted? # => false
item.shared? # => true if the item has sharing info
item.path # => "root:/Documents/Getting started with OneDrive.pdf" (from delta only; nil for single item)
item.is_root? # => true for root folder
```

### Check if a DriveItem exists

```rb
client.item_exists?(item_id: "F0**********42!sa466********************1479272d27") # => true
client.item_exists?(item_id: "F0**********42!not-an-item-id") # => false
```

### Get permissions for a DriveItem

```rb
permission_list = client.permissions(item_id: "F0**********42!sa466********************1479272d27")
permission_list.class # => MicroslopOneDrive::PermissionList
permission_list.permissions # => [MicroslopOneDrive::Permission, ...]

permission = permission_list.permissions.first
permission.role # => "write" or "owner" etc.
permission.audience.type # => "user" or "anyone"
permission.audience.identifier # => email for user, "anyone_with_the_link" for link
permission.audience.display_name # => "Amy Smith"
permission.audience.email_address # => "amy@example.com" (nil for "anyone with the link")
```

Returns an empty permission list if the item does not exist (404).

## Contributing

### Setup

```sh
mise init
bundle install
```

### Running tests

```sh
bundle exec rake test
```

## Building and publishing

```sh
# Signin if not already:
gem signin

# Bump version in lib/microslop_one_drive/version.rb

# Then build:
gem build microslop_drive.gemspec
# You will get a *.gem file like microslop_one_drive-X.Y.Z.gem

gem push microslop_one_drive-X.Y.Z.gem
```
