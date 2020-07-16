ActiveAdmin.register Sellers::OrderSoldPaper, as: 'Sales Info' do

  index do
    selectable_column
    column :order_number do |order_sold_paper|
      link_to order_sold_paper.order_info.enc_id, sales_info_path(order_sold_paper)
    end
    column :total_product_price do |order_sold_paper|
      para currency_format order_sold_paper.order_info.payment.total_price_sum
    end
    column :'seller\'s profit' do |order_sold_paper|
      para currency_format order_sold_paper.adjusted_profit
    end
    column :'seller name' do |order_sold_paper|
      para order_sold_paper.seller_info.name
    end
    column :order_status do |order_sold_paper|
      para order_sold_paper.order_info.order_status
    end
    column :ordered_date do |order_sold_paper|
      ordered_date = order_sold_paper.order_info.ordered_at.tap do |time|
        return '-' if time.nil?
        time.strftime('%Y-%m-%d %H:%M:%S')
      end
      para ordered_date
    end
  end

  show do
    h1 '판매내역 상세'
    h2 '판매 정보'
    div class: 'column_table' do
      columns style: "max-width: 1400px;" do
        column span: 1 do
          span class: 'th' do '주문번호' end
        end
        column span: 2 do
          link_to sales_info.order_info.enc_id, order_info_path(sales_info.order_info)
        end
        column span: 1 do
          span class: 'th' do '주문상태' end
        end
        column span: 2 do
          status_tag(sales_info.order_info.order_status)
        end
        column span: 1 do
          span class: 'th' do '주문상태' end
        end
        column span: 2 do
          status_tag(sales_info.order_info.order_status)
        end
      end
      columns style: "max-width: 1400px;" do
        column span: 1 do
          span '총 주문 금액'
        end
        column span: 2 do
          span currency_format sales_info.order_info.cart.price_sum
        end
        column span: 1 do
          span '총 셀러 수수료'
        end
        column span: 2 do
          span currency_format sales_info.adjusted_profit
        end
        column span: 1 do
          span '셀러명'
        end
        column span: 2 do
          span sales_info.seller_info.name
        end
      end
    end

    h2 '상품 내역'
    table_for sales_info.order_info.cart.items do
      column(:'상품명') { |item| item.product_option.product.translate.title + ' : ' + item.product_option.name }
      column(:'단위상품가격') { |item| currency_format item.captured_retail_price }
      column(:'판매수') { |item| item.option_count }
      column(:'총 판매 가격') { |item| currency_format item.captured_retail_price * item.option_count }
      column(:'셀러 수수료') { |item| currency_format sales_info.seller_info.grade.commission_rate * (item.captured_retail_price * item.option_count) }
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :finished, :cart_id, :enc_id, :admin_memo, :channel_id, :country_id, :ordered_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:finished, :cart_id, :enc_id, :admin_memo, :channel_id, :country_id, :ordered_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end