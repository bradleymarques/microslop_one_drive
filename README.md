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

Quickstart: current user, drives, drive items, shared-with-me, delta (changes), and permissions (single or batched).

### Creating a client

```rb
access_token = "..." # Get an access token via OAuth 2.0

client = MicroslopOneDrive::Client.new(access_token)

# Optional: pass a logger to log all API requests and responses (e.g. Rails.logger)
client = MicroslopOneDrive::Client.new(access_token, logger: Rails.logger)
```

### Get current user

```rb
user = client.me
user.display_name # => "Jane Doe"
user.email_address # => "jane@example.com"
```

### Listing Drives

Note: Microsoft will return all Drives a user has access to. Some of these seem to be for internal Microsoft use only
(they're things like face scans, AI metadata, and other really terrifying and disgusting things). You can use the
`drive_exists?()` method to check if it's a real drive you can interact with.

```rb
drive_list = client.all_drives
drive_list.drives.size # => 2

drive = drive_list.drives[1]
drive.name # => OneDrive
drive.id # => "0f0**********42"

client.drive_exists?(drive.id) # => true (it's a real Drive)
```

### Get a single drive

```rb
# Default (current user's) drive
drive = client.drive

# Or a specific drive by ID
drive = client.drive(drive_id: "0f0**********42")
drive.name # => "OneDrive"
```

### Get a single drive item

```rb
item = client.drive_item(item_id: "01ABC123...", drive_id: drive.id)
item.name # => "My Document.docx"
item.file? # => true
item.folder? # => false

# Check if an item exists without raising
client.drive_item_exists?(item_id: "01ABC123...", drive_id: drive.id) # => true
```

### Listing Drive Items (Folders and Files)

```rb
page1 = client.delta(drive_id: drive.id)
page1.items.size # => 200

page1.next_page? # => true
page2 = client.delta(drive_id: drive.id, token: page1.next_token)
page2.items.size # => 14
page2.next_page? # => false

delta_token = page2.delta_token # Save this somewhere and use as "token" in the next client.delta() call so ensure you
# only get new changes, and don't list the whole drive from the beginning again.
```

### Shared with me

Get drive items (files and folders) that others have shared with the current user.

```rb
shared_list = client.shared_with_me
shared_list.shared_with_me_items.size # => 5

item = shared_list.shared_with_me_items.first
item.name # => "Spreadsheet One.xlsx"
item.id # => "64E5DD3210FD6004!s1d8ad87a1d6e4d4e..."
item.web_url # => "https://onedrive.live.com?cid=..."
item.size # => 6183
item.created_at # => 2026-02-17 14:27:26 UTC
item.updated_at # => 2026-02-17 14:27:27 UTC

# Who shared it
item.created_by.display_name # => "Someone Else"
item.created_by.email_address # => "outlook_64E5DD3210FD6004@outlook.com"
item.last_modified_by.display_name # => "Someone Else"

# The underlying drive item (with file?, folder?, mime_type, shared?, etc.)
item.remote_item.file? # => true
item.remote_item.shared? # => true
```

Use `shared_list.next_page?` and `shared_list.next_token` to paginate when there are many items.

### Get Permissions for a single Drive Item

```rb
drive_item_list = client.delta(drive_id: drive.id)
shared_items = drive_item_list.items.select(&:shared?)

example_item = shared_items.first

permission_list = client.permissions(item_id: example_item.id)
permission = permission_list.first

permission.role # => "write"
permission.audience.type # => "user"
permission.audience.id # => "person@example.com"
permission.audience.display_name # => "Example Person"
permission.audience.email_address # => "person@example.com"
```

### Get Permissions for multiple Drive Items

Instead of calling `client.permissions(...)` for each item -- which would make N API calls for N items -- we use
Microsoft Graph API [batch](https://learn.microsoft.com/en-us/graph/json-batching?tabs=http) feature.

```rb
drive_item_list = client.delta(drive_id: drive.id)
shared_items = drive_item_list.items.select(&:shared?)

permissions = client.batch_permissions(item_ids: shared_items.map(&:id))
# Returns a flat array of MicroslopOneDrive::Permission (batches of 20 are made under the hood).
permissions.each { |p| puts "#{p.audience.display_name}: #{p.role}" }
```

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
