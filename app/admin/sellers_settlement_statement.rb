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
    column :email do |settlement_statement|
      para settlement_statement.seller_info.seller.email
    end
    column :'seller name' do |settlement_statement|
      link_to settlement_statement.seller_info.name, settlement_path(settlement_statement)
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
      para settlement_statement.requested_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
    column :'accepted time' do |settlement_statement|
      para settlement_statement.accepted_at&.strftime('%Y-%m-%d %H:%M:%S')
    end
  end

  show title: '출금 정보' do
    div do
      span link_to '승인', accept_settlement_path(settlement), method: :put unless settlement.stamped?
      span link_to '거절', reject_settlement_path(settlement), method: :put unless settlement.stamped?
    end
    div class: 'column_table' do
      columns style: "max-width: 1400px;" do
        column span: 1 do
          span class: 'th' do '신청 상태' end
        end
        column span: 2 do
          status_tag(settlement.status)
          para settlement.status_changed_at&.strftime('%Y-%m-%d %H:%M:%S')
        end
        column span: 1 do
          span class: 'th' do '신청 계좌' end
        end
        column span: 2 do
          #TODO : account info가 독립적인 값으로 쓰여져 저장돼야 할 필요가 있습니다.
          account = settlement.seller_info.account_info
          span class: 'd-block' do
            account.bank + '/' + account.owner_name
          end
          span class: 'd-block' do
            account.account_number
          end
        end
        column span: 1 do
          span class: 'th' do '요청 금액' end
        end
        column span: 2 do
          currency_format settlement.settlement_amount
        end
      end
      columns style: "max-width: 1400px;" do
        column span: 1 do
          span '이메일'
        end
        column span: 2 do
          span settlement.seller_info.seller.email
        end
        column span: 1 do
          span '셀러명'
        end
        column span: 2 do
          span settlement.seller_info.name
        end
        column span: 1 do
          span '전화번호'
        end
        column span: 2 do
          span settlement.seller_info.seller.phone_number
        end
      end
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
