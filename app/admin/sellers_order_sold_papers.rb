ActiveAdmin.register Sellers::OrderSoldPaper do

  index do
    selectable_column
    column :order_number do |order_sold_paper|
      link_to order_sold_paper.order_info.enc_id, admin_sellers_order_sold_paper_path(order_sold_paper)
    end
    column :total_product_price do |order_sold_paper|
      para currency_format order_sold_paper.order_info.payment.total_price_sum
    end
    column :'seller\'s profit' do |order_sold_paper|
      para currency_format order_sold_paper.adjusted_profit
    end
    column :'seller name' do |order_sold_paper|
      para order_sold_paper.seller_info.seller.name
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
