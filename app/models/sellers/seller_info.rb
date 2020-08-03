module Sellers
  class SellerInfo < ApplicationRecord
    belongs_to :seller
    has_one :store_info, class_name: 'Sellers::StoreInfo', dependent: :destroy
    has_one :account_info, class_name: 'Sellers::AccountInfo', dependent: :destroy
    belongs_to :grade, class_name: 'Sellers::Grade'

    has_many :permit_change_lists, class_name: 'Sellers::PermitChangeList', dependent: :destroy
    has_one :permission, -> { order('created_at DESC') }, class_name: 'Sellers::PermitChangeList'
    has_one :permit_status, through: :permission, class_name: 'Sellers::PermitStatus'

    has_many :settlement_statements, class_name: 'Sellers::SettlementStatement', dependent: :destroy
    has_many :item_sold_papers, class_name: 'Sellers::ItemSoldPaper', dependent: :destroy
    has_many :items, through: :item_sold_papers
    has_many :order_infos, -> { distinct }, through: :items
    scope :order_infos, -> { OrderInfo.where(items: items) }

    scope :permitted, -> { where(permission: Sellers::PermitChangeList.where(permit_status: Sellers::PermitStatus.permitted)) }
    scope :applied, -> { where(permission: Sellers::PermitChangeList.where(permit_status: Sellers::PermitStatus.applied)) }

    delegate :name, to: :seller
    delegate :email, to: :seller
    delegate :phone_number, to: :seller
    delegate :commission_rate, to: :grade

    def permitted?
      update_status_cache
      permit_status == Sellers::PermitStatus.permitted
    end

    def play_permit!(reason = nil)
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.permitted,
        reason: reason
      )
      update_status_cache
    end

    def play_stop!(reason)
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.stopped,
        reason: reason
      )
      update_status_cache
    end

    def init_permit_status!
      permit_change_lists << Sellers::PermitChangeList.new(
        permit_status: Sellers::PermitStatus.applied
      )
      update_status_cache
    end

    def update_counter_cache(item_sold_paper = nil)
      if item_sold_paper.nil?
        update_columns(
          cumulative_amount: items.sum(&:captured_retail_price),
          cumulative_profit: item_sold_papers.sum(&:adjusted_profit)
        )
      else
        cart_item = item_sold_paper.cart_item
        update_columns(
          cumulative_amount: cumulative_amount + cart_item.captured_retail_price,
          cumulative_profit: cumulative_profit + item_sold_paper.adjusted_profit
        )
      end
    end

    private

    def update_status_cache
      update(permit_status: permission.permit_status)
    end
  end
end
