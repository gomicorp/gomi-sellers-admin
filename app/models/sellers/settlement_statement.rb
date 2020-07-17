module Sellers
  class SettlementStatement < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    STATUSES = %w(requested accepted rejected)

    validates_inclusion_of :status, in: STATUSES

    def confirm!
      update(status: 'accepted', accepted_at: DateTime.now)
    end

    def status_changed_at
      case status
      when 'requested'
        requested_at || created_at
      when 'accepted'
        accepted_at
      else
        updated_at
      end
    end

    def self.statuses
      STATUSES
    end

  end
end
