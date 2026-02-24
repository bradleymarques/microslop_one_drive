require "test_helper"

module MicroslopOneDrive
  class PermissionsTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)
    end

    def test_shared_with_me_fetches_the_drive_items_shared_with_me
      mock_get(
        path: "me/drive/sharedWithMe",
        parsed_response: fixture_response("shared_with_me/shared_with_me.json")
      )

      shared_with_me_list = @client.shared_with_me
      assert_kind_of MicroslopOneDrive::ListResponses::SharedWithMeList, shared_with_me_list

      shared_with_me_items = shared_with_me_list.shared_with_me_items
      assert_equal 1, shared_with_me_items.size

      item = shared_with_me_items.first
      assert_kind_of MicroslopOneDrive::SharedWithMeItem, item

      assert_equal "Spreadsheet One.xlsx", item.name
      assert_equal "64E5DD3210FD6004!s1d8ad87a1d6e4d4eaa001e67ba140996", item.id
      assert_equal "https://onedrive.live.com?cid=64e5dd3210fd6004&id=64E5DD3210FD6004!s1d8ad87a1d6e4d4eaa001e67ba140996",
                   item.web_url
      assert_equal 6_183, item.size
      assert_equal Time.parse("2026-02-17T14:27:27Z"), item.last_modified_date_time
      assert_equal Time.parse("2026-02-17T14:27:26Z"), item.created_date_time
    end

    def test_shared_with_me_assigns_created_by
      skip
      mock_get(
        path: "me/drive/sharedWithMe",
        parsed_response: fixture_response("shared_with_me/shared_with_me.json")
      )

      shared_with_me_list = @client.shared_with_me
      item = shared_with_me_list.shared_with_me_items.first

      created_by = item.created_by
      assert_kind_of MicroslopOneDrive::User, created_by
    end
  end
end
