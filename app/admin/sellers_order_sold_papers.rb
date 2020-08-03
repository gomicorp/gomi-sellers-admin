# ActiveAdmin.register OrderInfo.sellers_order, as: 'Sales Info' do
#   actions :index, :show
#   filter :seller_info_seller_name_cont, label: 'Seller Name'
#   filter :order_info_cart_order_status, label: 'Order status', as: :select, collection: -> { Cart.order_statuses }
#   filter :created_at, label: 'Ordered date [yyyy-mm-dd]', as: :date_range
#
#   # index download_links: [:csv] do
#   #   column :'주문 번호' do |order_info|
#   #     link_to order_info.enc_id, sales_info_path(order_info)
#   #   end
#   #   column :'판매 금액' do |order_sold_paper|
#   #     order = order_sold_paper.order_info
#   #     amount = order.payment.total_price_sum
#   #     para class: 'mb-1' do number_to_currency(krw_exchange(amount, order.country.iso_code), locale: :ko) end
#   #     para class: 'mb-1 text-secondary' do currency_format amount end
#   #   end
#   #   column :'셀러 수익' do |order_sold_paper|
#   #     amount = order_sold_paper.adjusted_profit
#   #     para class: 'mb-1' do number_to_currency(krw_exchange(amount, order_sold_paper.order_info.country.iso_code), locale: :ko) end
#   #     para class: 'mb-1 text-secondary' do currency_format amount end
#   #   end
#   #   column :'셀러명' do |order_sold_paper|
#   #     para order_sold_paper.seller_info.name
#   #   end
#   #   column :'주문 상태' do |order_sold_paper|
#   #     para order_sold_paper.order_info.order_status
#   #   end
#   #   column :'주문 일시' do |order_sold_paper|
#   #     para order_sold_paper.order_info.ordered_at&.strftime('%Y-%m-%d %H:%M:%S')
#   #   end
#   # end
#   #
#   # show title: '판매내역 상세' do
#   #
#   #   h3 '판매 정보'
#   #   render 'detail', { sales_info: sales_info }
#   #
#   #   h3 '상품 내역'
#   #   table_for sales_info.order_info.cart.items do
#   #     column(:'상품명') { |item| item.product_option.product.translate.title + ' : ' + item.product_option.name }
#   #     column(:'단위상품가격') { |item| currency_format item.captured_retail_price }
#   #     column(:'판매수') { |item| item.option_count }
#   #     column(:'총 판매 가격') { |item| currency_format item.captured_retail_price * item.option_count }
#   #     column(:'셀러 수수료') { |item| currency_format sales_info.seller_info.commission_rate * (item.captured_retail_price * item.option_count) }
#   #   end
#   # end
#
#   # See permitted parameters documentation:
#   # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#   #
#   # Uncomment all parameters which should be permitted for assignment
#   #
#   # permit_params :finished, :cart_id, :enc_id, :admin_memo, :channel_id, :country_id, :ordered_at
#   #
#   # or
#   #
#   # permit_params do
#   #   permitted = [:finished, :cart_id, :enc_id, :admin_memo, :channel_id, :country_id, :ordered_at]
#   #   permitted << :other if params[:action] == 'create' && current_user.admin?
#   #   permitted
#   # end
# end