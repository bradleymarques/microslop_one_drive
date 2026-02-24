require "test_helper"
require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class DriveDeserializerTest < BaseTest
      def test_can_create_a_drive_item_from_a_hash
        drive_item_hash = fixture_response("drive_items/drive_item.json")
        drive_item = MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(drive_item_hash)
        assert_kind_of MicroslopOneDrive::DriveItem, drive_item

        url = "https://onedrive.live.com?cid=0f097864e0cfea42&id=F097864E0CFEA42!sa466b4459868496abe59bb1479272d27"
        download_url = "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/_layouts/15/download.aspx?UniqueId=a466b445-9868-496a-be59-bb1479272d27&Translate=false&tempauth=v1e.eyJzaXRlaWQiOiJkMzQ5YjJjYS0zYmNiLTRmMWMtYTUwOS1hZDhkOTEzODUwMWQiLCJhcHBfZGlzcGxheW5hbWUiOiJHcmFwaCBFeHBsb3JlciIsImFwcGlkIjoiZGU4YmM4YjUtZDlmOS00OGIxLWE4YWQtYjc0OGRhNzI1MDY0IiwiYXVkIjoiMDAwMDAwMDMtMDAwMC0wZmYxLWNlMDAtMDAwMDAwMDAwMDAwL215Lm1pY3Jvc29mdHBlcnNvbmFsY29udGVudC5jb21AOTE4ODA0MGQtNmM2Ny00YzViLWIxMTItMzZhMzA0YjY2ZGFkIiwiZXhwIjoiMTc3MTQ5NDU4MyJ9.AobVp80diPKRuOjrCgyPYBpnpon6c8GulRctvf0mjXF13V-YIAVEeSvrToqBrGAVJuUmJkyN4Vum4BDy_yVXwO0bKjVwC5Jc_hzYs24KjoftUy1ZFWWN-0kCxvlOW71e0pSlSOPOZ3EbjTaALjCzSHOxRIhYNPeGMQ666TUAdfQwvrqrOT6FBj3OHDxQExVGhghSuhzO6d0VtsYY6sDBlnsYSKv2xOwISritHuqEgja9G_ixVvary798M8NonXjV3NPFlR5CkDV_uyYGjfVYy6GkRs5CocaOdWa-NhHxxgvu9inY1KLA3vbAHDz-tuq0m7HsX58FzmlXJZ3_8vaqVOVDis2g6aatwG5RpdMq3mI2gxFPmqafhIkDj0lebx7iat7Wt43_fOFQJeTttuhuE8QNHBtYYpV4cE-xzeDDP1_Ln4huHIL8m1MrCPENrX_DgNHW6TSfezaEtKKvqr_bPA.bcNZa508HLEeJp46owhif2ZjGZlVqtJcTle9BAPZ-nY&ApiVersion=2.0"

        assert_equal "Getting started with OneDrive.pdf", drive_item.name
        assert_equal :file, drive_item.file_or_folder
        assert_equal true, drive_item.file?
        assert_equal false, drive_item.folder?
        assert_equal "application/pdf", drive_item.mime_type
        assert_equal url, drive_item.web_url
        assert_equal download_url, drive_item.download_url
        assert_equal "F097864E0CFEA42!sa466b4459868496abe59bb1479272d27", drive_item.id
        assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.created_at
        assert_equal Time.parse("2026-02-19T07:35:52Z"), drive_item.updated_at
        assert_equal 1_053_417, drive_item.size
      end

      def test_can_create_a_file
        drive_item_hash = fixture_response("drive_items/drive_item.json")
        drive_item = MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(drive_item_hash)
        assert_kind_of MicroslopOneDrive::DriveItem, drive_item
        assert_kind_of MicroslopOneDrive::File, drive_item

        assert_equal true, drive_item.file?
        assert_equal false, drive_item.folder?
        assert_equal false, drive_item.root?
      end

      def test_can_create_a_folder
        drive_item_hash = fixture_response("drive_items/drive_item_folder.json")
        drive_item = MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(drive_item_hash)
        assert_kind_of MicroslopOneDrive::DriveItem, drive_item
        assert_kind_of MicroslopOneDrive::Folder, drive_item

        assert_equal false, drive_item.file?
        assert_equal true, drive_item.folder?
        assert_equal false, drive_item.root?
      end

      def test_can_create_the_root_folder
        drive_item_hash = fixture_response("drive_items/drive_item_root.json")
        drive_item = MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(drive_item_hash)
        assert_kind_of MicroslopOneDrive::DriveItem, drive_item
        assert_kind_of MicroslopOneDrive::Folder, drive_item
        assert_kind_of MicroslopOneDrive::RootFolder, drive_item

        assert_equal false, drive_item.file?
        assert_equal true, drive_item.folder?
        assert_equal true, drive_item.root?
      end

      def test_sets_paths_for_the_root_folder
        drive_item_hash = fixture_response("drive_items/drive_item_root.json")
        drive_item = MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(drive_item_hash)
        assert_kind_of MicroslopOneDrive::RootFolder, drive_item

        assert_equal "/drive/root:", drive_item.full_path
        assert_equal "", drive_item.path
      end

      def test_sets_paths_for_a_folder
        drive_item_hash = fixture_response("drive_items/drive_item_folder.json")
        drive_item = MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(drive_item_hash)
        assert_kind_of MicroslopOneDrive::Folder, drive_item

        assert_equal "/drive/root:/Documents", drive_item.full_path
        assert_equal "Documents", drive_item.path
      end

      def test_sets_paths_for_a_nested_file
        drive_item_hash = fixture_response("drive_items/drive_item_nested_file.json")
        drive_item = MicroslopOneDrive::Deserializers::DriveItemDeserializer.create_from_hash(drive_item_hash)
        assert_kind_of MicroslopOneDrive::File, drive_item

        assert_equal "/drive/root:/Documents/Sub Folder/Project Proposal.docx", drive_item.full_path
        assert_equal "Documents/Sub Folder/Project Proposal.docx", drive_item.path
      end
    end
  end
end
