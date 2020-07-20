module Sellers
  class SettlementStatement < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo'
    after_create_commit :write_initial_state

    STATUSES = %w(requested accepted rejected)

    validates_inclusion_of :status, in: STATUSES

    def confirm!
      return false if status != 'requested'

      seller_info.update(present_profit: seller_info.present_profit - settlement_amount)
      update(status: 'accepted', accepted_at: DateTime.now)
    end

    def reject!
      return false if status != 'requested'

      seller_info.update(withdrawable_profit: seller_info.withdrawable_profit + settlement_amount)
      update(status: 'rejected')
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

    def stamped?
      status != 'requested'
    end

    def self.statuses
      STATUSES
    end


    private

    def write_initial_state
      return false unless status.nil?

      update(status: 'requested')
      withdraw_request
    end

    def withdraw_request
      seller_info.update(withdrawable_profit: seller_info.withdrawable_profit - settlement_amount)
    end

  end
end
