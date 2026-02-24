require "test_helper"

module MicroslopOneDrive
  class DeltaTest < BaseTest
    def setup
      @access_token = "mock_access_token"
      @client = MicroslopOneDrive::Client.new(@access_token)

      @drive_id = "0f097864e0cfea42"
    end

    def test_delta_fetches_an_initial_delta_of_changes_to_my_default_drive
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_initial.json")
      )

      drive_item_list = @client.delta
      assert_kind_of MicroslopOneDrive::ListResponses::DriveItemList, drive_item_list

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
    end

    def test_delta_with_a_delta_link_and_delta_token
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_initial.json")
      )

      drive_item_list = @client.delta
      assert_kind_of MicroslopOneDrive::ListResponses::DriveItemList, drive_item_list
      assert_kind_of MicroslopOneDrive::ListResponses::ListResponse, drive_item_list

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
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_next.json")
      )

      drive_item_list = @client.delta
      assert_kind_of MicroslopOneDrive::ListResponses::DriveItemList, drive_item_list
      assert_kind_of MicroslopOneDrive::ListResponses::ListResponse, drive_item_list

      assert_nil drive_item_list.delta_link
      assert_nil drive_item_list.delta_token

      assert drive_item_list.next_link
      assert drive_item_list.next_token
      assert_equal true, drive_item_list.next_page?

      assert drive_item_list.next_link.include?("token=YzYtOTI4Y")
      assert drive_item_list.next_token.include?("YzYtOTI4Y")
    end

    def test_empty_delta
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_empty.json")
      )

      drive_item_list = @client.delta
      assert_kind_of MicroslopOneDrive::ListResponses::DriveItemList, drive_item_list

      assert drive_item_list.delta_link
      assert drive_item_list.delta_token

      assert_equal false, drive_item_list.next_page?

      assert_equal 0, drive_item_list.items.size
    end

    def test_delta_labels_files_and_folders_that_were_deleted
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_deleted_root_file.json")
      )

      drive_item_list = @client.delta
      drive_items = drive_item_list.items
      assert_equal 2, drive_items.size

      root = drive_items[0]
      assert_equal "root", root.name
      assert_equal false, root.deleted?

      deleted_file = drive_items[1]
      assert_equal "F097864E0CFEA42!sd08d0f9a7b58474fba9cc6172138e9a1", deleted_file.id
      assert_nil deleted_file.name # Name not returned for deleted files
      assert_equal true, deleted_file.deleted?
    end

    def test_delta_for_a_renamed_file
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_renamed.json")
      )

      drive_item_list = @client.delta
      drive_items = drive_item_list.items
      assert_equal 2, drive_items.size

      root = drive_items[0]
      assert_equal "root", root.name

      renamed_file = drive_items[1]
      assert_equal "Getting started with OneDrive (RENAMED).pdf", renamed_file.name
    end

    def test_delta_for_added_nested_items
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_added_nested_items.json")
      )

      drive_item_list = @client.delta
      drive_items = drive_item_list.items
      assert_equal 7, drive_items.size

      expected_names = [
        "root",
        "folder",
        "subfolder",
        "subsubfolder",
        "file_003.txt",
        "file_002.txt",
        "file_001.txt"
      ]

      assert_equal expected_names, drive_items.map(&:name)
    end

    def test_delta_for_deleted_nested_items
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_deleted_nested_items.json")
      )

      drive_item_list = @client.delta
      drive_items = drive_item_list.items

      assert_equal 7, drive_items.size
      root = get_drive_item_by_name(drive_items, "root")

      assert_equal false, root.deleted?
      other_items = drive_items.reject { it.name == "root" }
      assert_equal 6, other_items.size

      other_items.each do
        assert_equal true, it.deleted?
      end
    end

    def test_delta_with_an_initial_set_of_permissions
      mock_get(
        path: "me/drive/root/delta",
        parsed_response: fixture_response("deltas/delta_with_permissions_initial.json")
      )

      drive_item_list = @client.delta
      drive_items = drive_item_list.items

      assert_equal 7, drive_items.size

      root = get_drive_item_by_name(drive_items, "root")
      documents = get_drive_item_by_name(drive_items, "Documents")
      shared_folder = get_drive_item_by_name(drive_items, "Shared Folder")
      word_document = get_drive_item_by_name(drive_items, "A Word Document.docx")

      assert_equal true, root.shared?
      assert_equal false, documents.shared?
      assert_equal true, shared_folder.shared?
      assert_equal false, word_document.shared?
    end

    def test_delta_with_drive_id_fetches_an_initial_delta_of_changes_to_a_specific_drive
      mock_get(
        path: "me/drives/#{@drive_id}/root/delta",
        parsed_response: fixture_response("deltas/delta_with_permissions_initial.json")
      )

      drive_item_list = @client.delta(drive_id: @drive_id)
      drive_items = drive_item_list.items

      assert_equal 7, drive_items.size

      root = get_drive_item_by_name(drive_items, "root")
      documents = get_drive_item_by_name(drive_items, "Documents")
      shared_folder = get_drive_item_by_name(drive_items, "Shared Folder")
      word_document = get_drive_item_by_name(drive_items, "A Word Document.docx")

      assert_equal true, root.shared?
      assert_equal false, documents.shared?
      assert_equal true, shared_folder.shared?
      assert_equal false, word_document.shared?
    end
  end
end
