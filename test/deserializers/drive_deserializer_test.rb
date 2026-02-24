require "test_helper"
require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class DriveDeserializerTest < BaseTest
      def test_can_create_a_drive_from_an_empty_hash
        drive = MicroslopOneDrive::Deserializers::DriveDeserializer.create_from_hash({})
        assert_kind_of MicroslopOneDrive::Drive, drive

        assert_nil drive.id
        assert_nil drive.name
        assert_nil drive.drive_type
        assert_nil drive.description
      end

      def test_can_create_a_drive_from_a_string_key_hash
        drive_hash = fixture_response("drives/drive.json")
        drive = MicroslopOneDrive::Deserializers::DriveDeserializer.create_from_hash(drive_hash)
        assert_kind_of MicroslopOneDrive::Drive, drive

        assert_equal "0f097864e0cfea42", drive.id
        assert_equal "OneDrive", drive.name
        assert_equal "personal", drive.drive_type
        assert_equal "", drive.description

        assert_equal Time.parse("2026-02-16T05:06:27Z"), drive.created_date_time
        assert_equal Time.parse("2026-02-16T05:06:27Z"), drive.created_at
        assert_equal Time.parse("2026-02-19T07:39:49Z"), drive.last_modified_date_time
        assert_equal Time.parse("2026-02-19T07:39:49Z"), drive.updated_at

        assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.web_url
        assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.url
      end

      def test_can_create_a_drive_from_a_symbol_key_hash
        drive_hash = fixture_response("drives/drive.json")
        drive_hash = Utils.deep_symbolize_keys(drive_hash)

        drive = MicroslopOneDrive::Deserializers::DriveDeserializer.create_from_hash(drive_hash)
        assert_kind_of MicroslopOneDrive::Drive, drive

        assert_equal "0f097864e0cfea42", drive.id
        assert_equal "OneDrive", drive.name
        assert_equal "personal", drive.drive_type
        assert_equal "", drive.description

        assert_equal Time.parse("2026-02-16T05:06:27Z"), drive.created_date_time
        assert_equal Time.parse("2026-02-16T05:06:27Z"), drive.created_at
        assert_equal Time.parse("2026-02-19T07:39:49Z"), drive.last_modified_date_time
        assert_equal Time.parse("2026-02-19T07:39:49Z"), drive.updated_at

        assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.web_url
        assert_equal "https://my.microsoftpersonalcontent.com/personal/0f097864e0cfea42/Documents", drive.url
      end

      def test_assigns_created_by_last_modified_by_and_owner_as_users
        drive_hash = fixture_response("drives/drive.json")
        drive = MicroslopOneDrive::Deserializers::DriveDeserializer.create_from_hash(drive_hash)
        assert_kind_of MicroslopOneDrive::Drive, drive

        created_by = drive.created_by
        assert_kind_of MicroslopOneDrive::User, created_by
        assert_equal "System Account", created_by.display_name

        last_modified_by = drive.last_modified_by
        assert_kind_of MicroslopOneDrive::User, last_modified_by
        assert_equal "System Account", last_modified_by.display_name

        owner = drive.owner
        assert_kind_of MicroslopOneDrive::User, owner
        assert_equal "person@example.com", owner.email_address
        assert_equal "person@example.com", owner.display_name
      end

      def test_assigns_quota_as_a_quota_object
        drive_hash = fixture_response("drives/drive.json")
        drive = MicroslopOneDrive::Deserializers::DriveDeserializer.create_from_hash(drive_hash)
        assert_kind_of MicroslopOneDrive::Drive, drive

        quota = drive.quota
        assert_kind_of MicroslopOneDrive::Quota, quota
        assert_equal 0, quota.deleted
        assert_equal 5_367_655_703, quota.remaining
        assert_equal "normal", quota.state
        assert_equal 5_368_709_120, quota.total
        assert_equal 1_053_417, quota.used
        assert_equal true, quota.upgrade_available
      end
    end
  end
end
