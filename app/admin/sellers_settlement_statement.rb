ActiveAdmin.register Sellers::SettlementStatement do

  index do
    selectable_column
    column :email do |settlement_statement|
      para settlement_statement.seller.seller.email
    end
    column :'seller name' do |settlement_statement|
      para settlement_statement.seller_info.seller.name
    end
    column :'phone number' do |settlement_statement|
      para settlement_statement.seller_info.seller.phone_number
    end
    column :country
    column :'settlement amount' do |settlement_statement|
      para currency_format settlement_statement.settlement_amount
    end
    column :status do |settlement_statement|
      para settlement_statement.status
    end
    column :'requested time' do |settlement_statement|
      requested_time = settlement_statement.requested_at.tap do |time|
        return '-' if time.nil?
        time.strftime('%Y-%m-%d %H:%M:%S')
      end
      para requested_time
    end
    column :'accepted time' do |settlement_statement|
      accepted_time = settlement_statement.accepted_at.tap do |time|
        return '-' if time.nil?

        time.strftime('%Y-%m-%d %H:%M:%S')
      end
      para accepted_time
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
