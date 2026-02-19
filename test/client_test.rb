require "test_helper"

module MicroslopOneDrive
  class ClientTest < Minitest::Test
    def setup
      @base_url = MicroslopOneDrive::Client::BASE_URL
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)

      @drive_id = "0f097864e0cfea42"
    end

    def test_handles_errors
      stubbed_response = stub(
        code: 400,
        success?: false,
        parsed_response: {
          error: {
            message: "error_message"
          }
        }
      )

      HTTParty
        .expects(:get)
        .with("#{@base_url}/me", headers: anything, query: anything)
        .returns(stubbed_response)

      error =assert_raises MicroslopOneDrive::Errors::ClientError do
        @client.me
      end

      assert_equal 400, error.response_code
      assert_equal({error: {message: "error_message"}}, error.response_body)
    end

    def test_me_fetches_the_current_user
      mock_get(
        path: "me",
        parsed_response: fixture_response("me.json")
      )

      me = @client.me
      assert_kind_of MicroslopOneDrive::User, me
      assert_equal "person@example.com", me.email_address
      assert_equal "Person Example", me.display_name
    end

    def test_drives_fetches_the_current_user_drives
      mock_get(
        path: "me/drives",
        parsed_response: fixture_response("drives.json")
      )

      drive_list = @client.drives
      assert_kind_of MicroslopOneDrive::ListResponse, drive_list
      assert_equal false, drive_list.next_page?
      assert_kind_of MicroslopOneDrive::DriveList, drive_list
      assert_equal 2, drive_list.drives.size
      assert_kind_of MicroslopOneDrive::Drive, drive_list.drives.first

      drive = drive_list.drives[1]

      assert_equal "0f097864e0cfea42", drive.id
      assert_equal "OneDrive", drive.name
      assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.url
      assert_equal "personal", drive.drive_type
    end

    def test_drive_fetches_a_drive
      mock_get(
        path: "me/drives/#{@drive_id}",
        parsed_response: fixture_response("drive.json")
      )

    drive = @client.drive(drive_id: @drive_id)
      assert_kind_of MicroslopOneDrive::Drive, drive
      assert_equal "0f097864e0cfea42", drive.id
      assert_equal "OneDrive", drive.name
      assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.url
      assert_equal "personal", drive.drive_type
    end

    def test_delta_fetches_an_initial_delta_of_changes_to_a_drive
      mock_get(
        path: "me/drives/#{@drive_id}/root/delta",
        parsed_response: fixture_response("delta_initial.json")
      )

      drive_item_list = @client.delta(drive_id: @drive_id)
      assert_kind_of MicroslopOneDrive::DriveItemList, drive_item_list

      items = drive_item_list.items
      assert_equal 4, items.size

      assert_equal "root", items[0].name
      assert_equal "Documents", items[1].name
      assert_equal "Pictures", items[2].name
      assert_equal "Getting started with OneDrive.pdf", items[3].name

      sample_item = items[3]
      assert_kind_of MicroslopOneDrive::DriveItem, sample_item
      assert_equal "Getting started with OneDrive.pdf", sample_item.name
      assert_equal "application/pdf", sample_item.mime_type
      assert_equal :file, sample_item.file_or_folder
      assert_equal true, sample_item.file?
      assert_equal false, sample_item.folder?
      assert_equal "https://onedrive.live.com?cid=0f097864e0cfea42&id=01BVTN66CFWRTKI2EYNJE34WN3CR4SOLJH", sample_item.url
      assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", sample_item.identifier
      assert_equal "F097864E0CFEA42!sea8cc6beffdb43d7976fbc7da445c639", sample_item.parent_identifier
      assert_equal Time.parse("2026-02-19T07:35:52Z"), sample_item.created_at
      assert_equal Time.parse("2026-02-19T07:35:52Z"), sample_item.updated_at
      assert_equal 1053417, sample_item.size
    end

    def test_delta_with_a_delta_link_and_delta_token
      mock_get(
        path: "me/drives/#{@drive_id}/root/delta",
        parsed_response: fixture_response("delta_initial.json")
      )

      drive_item_list = @client.delta(drive_id: @drive_id)
      assert_kind_of MicroslopOneDrive::DriveItemList, drive_item_list
      assert_kind_of MicroslopOneDrive::ListResponse, drive_item_list

      assert_nil drive_item_list.next_link
      assert_nil drive_item_list.next_token
      assert_equal false, drive_item_list.next_page?

      assert drive_item_list.delta_link
      assert drive_item_list.delta_token

      assert drive_item_list.delta_link.include?("token=NDslMjM0")
      assert drive_item_list.delta_token.include?("NDslMjM0")
    end

    def test_delta_with_a_next_link_and_next_token
      mock_get(
        path: "me/drives/#{@drive_id}/root/delta",
        parsed_response: fixture_response("delta_next.json")
      )

      drive_item_list = @client.delta(drive_id: @drive_id)
      assert_kind_of MicroslopOneDrive::DriveItemList, drive_item_list
      assert_kind_of MicroslopOneDrive::ListResponse, drive_item_list

      assert_nil drive_item_list.delta_link
      assert_nil drive_item_list.delta_token

      assert drive_item_list.next_link
      assert drive_item_list.next_token
      assert_equal true, drive_item_list.next_page?

      assert drive_item_list.next_link.include?("token=YzYtOTI4Y")
      assert drive_item_list.next_token.include?("YzYtOTI4Y")
    end

    def test_drive_item_fetches_a_drive_item
      item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("drive_item.json")
      )

      drive_item = @client.drive_item(item_id: item_id)
      assert_kind_of MicroslopOneDrive::DriveItem, drive_item

      assert_equal "Getting started with OneDrive.pdf", drive_item.name
      assert_equal "application/pdf", drive_item.mime_type
      assert_equal :file, drive_item.file_or_folder
      assert_equal true, drive_item.file?
      assert_equal false, drive_item.folder?
      assert_equal "https://onedrive.live.com?cid=#{@drive_id}&id=#{item_id}", drive_item.url
      assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", drive_item.identifier
      assert_equal "F097864E0CFEA42!sea8cc6beffdb43d7976fbc7da445c639", drive_item.parent_identifier
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.created_at
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.updated_at
      assert_equal 1053417, drive_item.size
    end

    def test_drive_item_fetches_a_drive_item
      item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"

      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("drive_item.json")
      )

      drive_item = @client.drive_item(item_id: item_id)
      assert_kind_of MicroslopOneDrive::DriveItem, drive_item

      assert_equal "Getting started with OneDrive.pdf", drive_item.name
      assert_equal "application/pdf", drive_item.mime_type
      assert_equal :file, drive_item.file_or_folder
      assert_equal true, drive_item.file?
      assert_equal false, drive_item.folder?
      assert_equal "https://onedrive.live.com?cid=#{@drive_id}&id=#{item_id}", drive_item.url
      assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", drive_item.identifier
      assert_equal "F097864E0CFEA42!sea8cc6beffdb43d7976fbc7da445c639", drive_item.parent_identifier
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.created_at
      assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.updated_at
      assert_equal 1053417, drive_item.size
    end

    def test_drive_item_for_an_item_that_does_not_exist
      item_id = "F097864E0CFEA42!not-an-item-id"

      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("item_not_found.json"),
        response_code: 404,
        success: false,
      )

      error = assert_raises MicroslopOneDrive::Errors::ClientError do
        @client.drive_item(item_id: item_id)
      end

      assert_equal 404, error.response_code
      assert_includes(error.response_body["error"]["message"], "Item not found")
    end

    def test_item_exists_returns_true_if_the_item_exists
      item_id = "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"
      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("drive_item.json"),
        response_code: 200,
        success: true,
      )

      assert_equal true, @client.item_exists?(item_id: item_id)
    end

    def test_item_exists_returns_false_if_the_item_does_not_exist
      item_id = "F097864E0CFEA42!not-an-item-id"
      mock_get(
        path: "me/drive/items/#{item_id}",
        parsed_response: fixture_response("item_not_found.json"),
        response_code: 404,
        success: false,
      )

      assert_equal false, @client.item_exists?(item_id: item_id)
    end

    def test_something
      flunk
    end

    private

    def fixture_response(fixture_file_name)
      fixture_path = File.expand_path("fixtures/#{fixture_file_name}", __dir__)
      JSON.parse(File.read(fixture_path))
    end

    def mock_get(path:, response_code: 200, success: true, parsed_response: {})
      stubbed_response = stub(code: response_code, success?: success, parsed_response: parsed_response)

      HTTParty
        .expects(:get)
        .with("#{@base_url}/#{path}", headers: anything, query: anything)
        .returns(stubbed_response)
    end
  end
end
