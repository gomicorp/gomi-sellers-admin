ActiveAdmin.register Sellers::SellerInfo do

  index do
    selectable_column
    column :email do |seller_info|
      para seller_info.seller.email
    end
    column :'seller name' do |seller_info|
      link_to seller_info.seller.name, admin_sellers_seller_info_path(seller_info)
    end
    column :'phone number' do |seller_info|
      para seller_info.seller
    end
    column :country
    column :'Cumulative number of sales' do |seller_info|
      seller_info.order_sold_papers.count
    end
    column :'Cumulative sales amount' do |seller_info|
      seller_info.order_infos.sum do |order_info|
        order_info.payment.total_price_sum
      end
    end
    column :status do |seller_info|
      seller_info.permit_status.name
    end
    column :'joined date' do |seller_info|
      joined_date = seller_info.created_at.tap do |time|
        return '-' if time.nil?
        time.strftime('%Y-%m-%d %H:%M:%S')
      end
      para joined_date
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
