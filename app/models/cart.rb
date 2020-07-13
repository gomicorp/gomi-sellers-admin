class CartCalculator
  attr_reader :cart, :items

  def initialize(cart)
    @cart = cart
    @items = cart.items
  end

  # 품목 단위 수량 합계
  def unit_count
    items.map(&:unit_count_sum).sum
  end

  # 정가 합계
  def base_price
    items.map(&:base_price).sum
  end

  # 정가 총 합계
  def base_price_sum
    items.map(&:base_price_sum).sum
  end

  # 변동가 합계
  # 일반적인 경우, 음수값을 가짐
  def discount_amount
    items.map(&:price_change_sum).sum
  end

  # 할인/변동을 반영한 상품 총 합계 가격
  # 정가 총 합계 + 변동가 합계
  def price_sum
    base_price_sum + discount_amount
  end

  def delivery_amount
    cart.delivery_amount.to_i
  end

  def final_result_price
    price_sum + delivery_amount
  end
end

class Cart < NationRecord
  # 신규(desk) 입금대기(pay) 결제완료(paid) 배송준비(ship_ready) 배송중(ship_ing) 취소요청(cancel-request) 반품요청(refund-request) 환불실패 보관함(complete)

  # 요청 -> 접수(처리중) -> { 반려 -> 요청 -> ... } -> 완료
  statuses = %w[request receive reject complete]
  status_cancel = statuses.map { |s| 'cancel-' + s }
  status_refund = statuses.map { |s| 'refund-' + s }

  ORDER_STATUSES = (%w[hand desk pay paid ship_ready ship_ing complete] + status_cancel + status_refund).freeze
  PRE_SALE_STATUSES = %w[hand desk].freeze
  NEGATIVE_STATUSES = %w[cancel-complete refund-complete].freeze
  SOLD_STATUSES = (ORDER_STATUSES - PRE_SALE_STATUSES - NEGATIVE_STATUSES).freeze
  enum order_status: ORDER_STATUSES

  belongs_to :user
  has_many :items, class_name: 'CartItem', dependent: :destroy
  has_one :order_info, dependent: :nullify

  delegate :ordered_at, to: :order_info, allow_nil: true
  delegate :delivery_amount, to: :order_info, allow_nil: true

  scope :active, -> { where(active: true) }
  scope :sold, -> { where(order_status: SOLD_STATUSES) }

  def self.current
    @_current = find_or_create_by(order_status: 0, current: true)
  end

  # 품목 단위 수량 합계
  def unit_count
    calculator.unit_count
  end

  # 총 정가 합계
  def base_price_sum
    calculator.base_price_sum
  end

  # 총 할인 가격
  def discount_amount
    calculator.discount_amount
  end

  alias _delivery_amount delivery_amount

  def delivery_amount
    return 0 if items.empty?

    #== TODO: ship_type 헬퍼 메소드가 생기면 사라질 코드입니다 ==
    ship_type = case current_country.short_name
                when 'th'
                  unit_count < 3 ? 'express' : 'bulk_express'
                else
                  'normal'
                end
    _delivery_amount || ShipInfo.fee_table(ship_type) # 배송비
    #====
  end

  # 총 합계 (최종 결제액)
  def final_price
    calculator.final_result_price
  end

  # 총 상품 가격 (할인 반영 총 합계)
  def price_sum
    calculator.price_sum
  end

  def sender_name
    user.name
  end

  def receiver_name
    order_info.receiver_name
  end

  def can_create_order
    return false unless current?
    return false unless hand?

    return false if order_info.present? && order_info.persisted?

    true
  end

  def cannot_create_order
    !can_create_order
  end

  private

  def calculator
    @calculator ||= CartCalculator.new(self)
  end
end
