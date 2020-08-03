ActiveAdmin.register Sellers::SellerInfo, as: 'Seller Info' do
  actions :index, :show
  filter :seller_name_cont, label: 'Seller Name'
  filter :permit_status

  member_action :permit, method: :put do
    seller_info = Sellers::SellerInfo.find(params[:id])
    seller_info.play_permit!
    seller_info.reload
    redirect_to seller_info_path seller_info, notice: 'The seller is permitted!'
  end

  member_action :stop, method: :put do
    seller_info = Sellers::SellerInfo.find(params[:id])
    seller_info.play_stop!(reason: params[:stop_reason])
    seller_info.reload
    redirect_to seller_info_path seller_info, notice: 'The seller is stopped!'
  end

  index download_links: [:csv] do

    column :'순번' do |seller_info|
      para seller_info.seller.id
    end
    column :'이메일' do |seller_info|
      para seller_info.seller.email
    end
    column :'셀러명' do |seller_info|
      link_to seller_info.name, seller_info_path(seller_info)
    end
    column :'전화번호' do |seller_info|
      para seller_info.seller.phone_number
    end
    column :'국가'
    column :'누적 판매 건수' do |seller_info|
      para seller_info.order_infos.count
    end
    column :'누적 판매 금액' do |seller_info|
      para currency_format seller_info.cumulative_amount
    end
    column :'허가 상태' do |seller_info|
      status = seller_info.permit_status.status
      class_option = if status == 'permitted'
                       {class: 'text-primary font-weight-bold'}
                     elsif status == 'stopped'
                       {class: 'text-danger font-weight-bold'}
                     end

      para(class_option) do
        seller_info.permit_status.status
      end
    end
    column :'가입일' do |seller_info|
      para seller_info.created_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  show title: '셀러 정보' do
    h3 '기본 정보'
    render 'detail', {seller_info: seller_info}

    h3 '판매 요약'
    render 'sales_summery', {seller_info: seller_info}

    h3 '판매 내역'
    table_for seller_info.order_infos do
      column(:'주문번호') { |order_info| order_info.enc_id }
      column(:'상품명') do |order_info|
        order_info.quantity.to_s + 'items includes ' + order_info.first_product&.translate&.title
      end
      column(:'상품 단위 금액') { |order_info| order_info.items.first.captured_retail_price }
      column(:'판매 개수') { |order_info| order_info.items.sum(:option_count) }
      column(:'총 판매 금액') { |order_info| order_info.cart.price_sum }
      column(:'셀러 수수료율(%)') do |order_info|
        items = order_info.sellers_items
        (items.sum(:captured_retail_price) / items.map(&:item_sold_paper).sum(:adjusted_profit)).to_i.to_s << '%'
      end
      column(:'셀러 수수료') do |order_info|
        order_info.sellers_items.map(&:item_sold_paper).sum(:adjusted_profit)
      end
      column(:'주문 상태') do |order_info| order_info.order_status end
      column(:'일시') do |order_info| order_info.ordered_at&.strftime('%Y-%m-%d %H:%M:%S') end
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
