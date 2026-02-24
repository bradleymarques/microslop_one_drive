require "microslop_one_drive/utils"

module MicroslopOneDrive
  module Deserializers
    class QuotaDeserializer
      # Creates a new Quota object from a hash.
      #
      # @param quota_hash [Hash] The hash to create the Quota object from.
      # @return [MicroslopOneDrive::Quota] The created Quota object.
      def self.create_from_hash(quota_hash)
        quota_hash = Utils.deep_symbolize_keys(quota_hash)

        deleted = quota_hash.fetch(:deleted, nil)
        remaining = quota_hash.fetch(:remaining, nil)
        state = quota_hash.fetch(:state, nil)
        total = quota_hash.fetch(:total, nil)
        used = quota_hash.fetch(:used, nil)
        upgrade_available = quota_hash.dig(:storagePlanInformation, :upgradeAvailable)

        Quota.new(
          deleted: deleted,
          remaining: remaining,
          state: state,
          total: total,
          used: used,
          upgrade_available: upgrade_available
        )
      end
    end
  end
end
