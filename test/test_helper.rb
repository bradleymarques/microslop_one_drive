$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "microslop_one_drive"
require "debug"
require "minitest/autorun"
require "mocha/minitest"

class BaseTest < Minitest::Test
  private

  def fixture_response(fixture_file_name)
    fixture_path = File.expand_path("fixtures/#{fixture_file_name}", __dir__)
    JSON.parse(File.read(fixture_path))
  end

  def mock_get(path:, response_code: 200, success: true, parsed_response: {})
    stubbed_response = stub(code: response_code, success?: success, parsed_response: parsed_response)

    HTTParty
      .expects(:get)
      .with("#{MicroslopOneDrive::Client::BASE_URL}/#{path}", headers: anything, query: anything)
      .returns(stubbed_response)
  end

  def get_drive_item_by_name(drive_items, name)
    drive_item = drive_items.find { it.name == name }
    assert(drive_item, "Drive item with name #{name} not found")
    drive_item
  end

  def mock_post(path:, expected_body:, response_code: 200, success: true, parsed_response: {})
    stubbed_response = stub(code: response_code, success?: success, parsed_response: parsed_response)

    HTTParty
      .expects(:post)
      .with("#{MicroslopOneDrive::Client::BASE_URL}/#{path}", headers: anything, body: expected_body)
      .returns(stubbed_response)
  end

  def assert_permission(permission, drive_item_id, display_name, email, identifier, role, audience_type)
    assert_equal drive_item_id, permission.drive_item_id
    assert_equal role, permission.role
    assert_equal audience_type, permission.audience.type
    assert_equal display_name, permission.audience.display_name
    assert_equal identifier, permission.audience.identifier
    if email
      assert_equal email, permission.audience.email_address
    else
      assert_nil permission.audience.email_address
    end
  end
end
