module MicroslopOneDrive
  module IdentitySets
    class BaseIdentitySet
      attr_reader :id, :display_name

      def initialize(id:, display_name:)
        @id = id
        @display_name = display_name
      end
    end
  end
end
