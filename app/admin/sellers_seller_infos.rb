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
      para seller_info.order_sold_papers.count
    end
    column :'누적 판매 금액' do |seller_info|
      para currency_format seller_info.cumulative_amount
    end
    column :'허가 상태' do |seller_info|
      status = seller_info.permit_status.status
      option = {class: status =='text-primary'}
      para seller_info.permit_status.status
    end
    column :'가입일' do |seller_info|
      para seller_info.created_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  show title: '셀러 정보' do
    h3 '기본 정보'
    div class: 'column_table' do
      columns style: "max-width: 1400px;" do
        column class: 'column th', span: 1 do
          span class: 'th' do '허가 상태' end
        end
        column span: 8 do
          action = if seller_info.permitted?
                     link_to 'stop seller', stop_seller_info_path(seller_info), method: :put, class: 'action-btn'
                   else
                     link_to 'permit seller', permit_seller_info_path(seller_info), method: :put, class: 'action-btn primary'
                   end
          status_tag(seller_info.permit_status.status.to_sym) + span(action)
        end
      end
      columns style: "max-width: 1400px;" do
        column class: 'column th', span: 1 do
          span '이메일'
        end
        column span: 2 do
          span seller_info.seller.email
        end
        column class: 'column th', span: 1 do
          span '셀러명'
        end
        column span: 2 do
          span seller_info.name
        end
        column class: 'column th', span: 1 do
          span '전화번호'
        end
        column span: 2 do
          span seller_info.seller.phone_number
        end
      end
    end

    h3 '판매 요약'
    div class: 'column_table' do
      columns style: "max-width: 1400px;" do
        column class: 'column th', span: 1 do
          span '총 판매 건수'
        end
        column span: 2 do
          span seller_info.order_sold_papers.count
        end
        column class: 'column th', span: 1 do
          span '총 판매 금액'
        end
        column span: 2 do
          span seller_info.cumulative_amount
        end
        column class: 'column th', span: 1 do
          span '미지급 수수료'
        end
        column span: 2 do
          span seller_info.seller.phone_number
        end
      end
    end

    h3 '판매 내역'
    table_for seller_info.order_sold_papers do
      column(:'주문번호') { |order_sold_paper| order_sold_paper.order_info.enc_id }
      column(:'상품명') do |order_sold_paper|
        order = order_sold_paper.order_info
        order.quantity.to_s + 'items includes ' + order.first_product&.translate&.title
      end
      column(:'상품 단위 금액') { |order_sold_paper| order_sold_paper.order_info.items.first.captured_retail_price }
      column(:'판매 개수') { |order_sold_paper| order_sold_paper.order_info.items.sum(:option_count) }
      column(:'총 판매 금액') { |order_sold_paper| order_sold_paper.order_info.cart.price_sum }
      column(:'셀러 수수료율(%)') { |order_sold_paper| (order_sold_paper.order_info.cart.price_sum/order_sold_paper.adjusted_profit).to_i.to_s << '%' }
      column(:'셀러 수수료') { |order_sold_paper| order_sold_paper.adjusted_profit }
      column(:'주문 상태') { |order_sold_paper| order_sold_paper.order_info.order_status }
      column(:'일시') { |order_sold_paper| order_sold_paper.order_info.ordered_at&.strftime('%Y-%m-%d %H:%M:%S') }
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
