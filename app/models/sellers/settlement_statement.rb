module Sellers
  class SettlementStatement < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'

    validates_inclusion_of :status, in: %w(requested accepted rejected)

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
  end
end
