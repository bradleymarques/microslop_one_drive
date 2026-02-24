module MicroslopOneDrive
  class User
    attr_reader :principal_name, :id, :display_name, :surname, :given_name, :preferred_language, :mail, :mobile_phone,
                :job_title, :office_location, :business_phones

    def initialize(
      principal_name: nil,
      id: nil,
      display_name: nil,
      surname: nil,
      given_name: nil,
      preferred_language: nil,
      mail: nil,
      mobile_phone: nil,
      job_title: nil,
      office_location: nil,
      business_phones: []
    )
      @principal_name = principal_name
      @id = id
      @display_name = display_name
      @surname = surname
      @given_name = given_name
      @preferred_language = preferred_language
      @mail = mail
      @mobile_phone = mobile_phone
      @job_title = job_title
      @office_location = office_location
      @business_phones = business_phones
    end

    def email_address
      mail
    end

    def last_name
      surname
    end
  end
end
