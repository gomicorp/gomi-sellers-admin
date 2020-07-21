ActiveAdmin.register Sellers::SettlementStatement, as: 'Settlement' do
  actions :index, :show
  filter :seller_info_seller_name_cont, label: 'Seller Name'
  filter :status, as: :select, collection: Sellers::SettlementStatement.statuses
  filter :requested_at, label: 'Requested date [yyyy-mm-dd]', as: :date_range
  filter :accepted_at, label: 'Accepted date [yyyy-mm-dd]', as: :date_range

  member_action :accept, method: :put do
    settlement_statement = Sellers::SettlementStatement.find params[:id]
    if settlement_statement.status != 'requested'
      redirect_to settlement_path(settlement_statement)
      return false
    end

    settlement_statement.confirm!
    redirect_to settlement_path(settlement_statement)
  end

  member_action :reject, method: :put do
    settlement_statement = Sellers::SettlementStatement.find params[:id]
    if settlement_statement.status != 'requested'
      redirect_to settlement_path(settlement_statement)
      return false
    end

    settlement_statement.reject!
    redirect_to settlement_path(settlement_statement)
  end

  index download_links: [:csv] do
    column :'이메일' do |settlement_statement|
      para settlement_statement.seller_info.seller.email
    end
    column :'셀러명' do |settlement_statement|
      link_to settlement_statement.seller_info.name, settlement_path(settlement_statement)
    end
    column :'전화번호' do |settlement_statement|
      para settlement_statement.seller_info.seller.phone_number
    end
    column :country
    column :'정산 금액' do |settlement_statement|
      para currency_format settlement_statement.settlement_amount
    end
    column :'상태' do |settlement_statement|
      para settlement_statement.status
    end
    column :'요청 시간' do |settlement_statement|
      para settlement_statement.requested_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
    column :'수락 시간' do |settlement_statement|
      para settlement_statement.accepted_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  show title: '출금 정보' do
    render 'detail', { settlement: settlement }
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
