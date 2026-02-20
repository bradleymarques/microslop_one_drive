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

Here's a quickstart showing listing drives, getting some files in a drive, and getting permissions for some files in
a batched manner:

### Creating a client

```rb
access_token = "..." # Get an access token via OAuth 2.0

client = MicroslopOneDrive::Client.new(access_token)
```

### Listing Drives

Note: Microsoft will return all Drives a user has access to. Some of these seem to be for internal Microsoft use only
(they're things like face scans, AI metadata, and other really terrifying and disgusting things). You can use the
`drive_exists?()` method to check if it's a real drive you can interact with.

```rb
drive_list = client.drives
drive_list.drives.size # => 2

drive = drive_list.drives[1]
drive.name # => OneDrive
drive.identifier # => "0f0**********42"

client.drive_exists?(drive.identifier) # => true (it's a real Drive)
```

### Listing Drive Items (Folders and Files)

```rb
page1 = client.delta(drive_id: drive.identifier)
page1.items.size # => 200

page1.next_page? # => true
page2 = client.delta(drive_id: drive.identifier, token: page1.next_token)
page2.items.size # => 14
page2.next_page? # => false

delta_token = page2.delta_token # Save this somewhere and use as "token" in the next client.delta() call so ensure you
# only get new changes, and don't list the whole drive from the beginning again.
```

### Get Permissions for a single Drive Item

```rb
drive_item_list = client.delta(drive_id: drive.identifier)
shared_items = drive_item_list.items.select(&:shared?)

example_item = shared_items.first

permission_list = client.permissions(item_id: example_item.identifier)
permission = permission_list.first

permission.role # => "write"
permission.audience.type # => "user"
permission.audience.identifier # => "person@example.com"
permission.audience.display_name # => "Example Person"
permission.audience.email_address # => "person@example.com"
```

### Get Permissions for multiple Drive Items

Instead of calling `client.permissions(...)` for each item -- which would make N API calls for N items -- we use
Microsoft Graph API [batch](https://learn.microsoft.com/en-us/graph/json-batching?tabs=http) feature.

```rb
drive_item_list = client.delta(drive_id: drive.identifier)
shared_items = drive_item_list.items.select(&:shared?)

permission_batch = client.batch_permissions(item_ids: shared_items.map(&:identifier))

# Under the hood, this will batch the shared_items into batches of 20 (the max Microsoft allows on their batch endpoint)
# and returns an aggregated result.
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
