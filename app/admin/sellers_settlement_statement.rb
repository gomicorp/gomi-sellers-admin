ActiveAdmin.register Sellers::SettlementStatement, as: 'Settlement' do

  index do
    selectable_column
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

  show do
    h1 '출금 정보'
    div class: 'column_table' do
      columns style: "max-width: 1400px;" do
        column span: 1 do
          span class: 'th' do '신청 상태' end
        end
        column span: 2 do
          status_tag(settlement.status)
          span class: 'd-block' do
            settlement.status_changed_at
          end
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
