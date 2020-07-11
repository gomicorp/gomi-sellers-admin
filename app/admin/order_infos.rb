# seed data를 생성하기 전까지, Active Admin에 관련한 Reference의 성격으로 작성됩니다.
ActiveAdmin.register OrderInfo do

  index do
    selectable_column
    column :order_id do |order_info|
      order_info.id
    end
    column :order_number do |order_info|
      link_to order_info.enc_id, admin_order_info_path(order_info)
    end
    column :total_product_price do |order_info|
      para order_info.payment.total_price_sum
    end
    column :order_status do |order_info|
      para order_info.order_status
    end
    column :ordered_date do |order_info|
      para order_info.ordered_at
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
