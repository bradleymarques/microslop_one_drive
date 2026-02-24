module MicroslopOneDrive
  class Quota
    attr_reader :deleted, :remaining, :state, :total, :used, :upgrade_available

    def initialize(deleted:, remaining:, state:, total:, used:, upgrade_available:)
      @deleted = deleted
      @remaining = remaining
      @state = state
      @total = total
      @used = used
      @upgrade_available = upgrade_available
    end
  end
end
