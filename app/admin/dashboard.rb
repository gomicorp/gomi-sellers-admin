ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    dashboard_separator = '&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;'

    columns do
      column do
        panel "Info" do
          para "Welcome to ActiveAdmin."
        end
      end

      column do
        panel "Recent Settlement Statement" do
          ul do
            Sellers::SettlementStatement.order(requested_at: :desc).first(5).map do |statement|
              li do
                name = link_to(statement.seller_info.name, settlements_path(statement))
                date = statement.requested_at.strftime('%Y/%m/%d')
                status = statement.status
                [name, status, date].join(dashboard_separator).html_safe
              end
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Newly applied sellers" do
          ul do
            Sellers::SellerInfo.applied.order(created_at: :desc).first(5).map do |seller|
              li do
                name = link_to(seller.name, seller_info_path(seller))
                others = [seller.email, seller.permit_status.status, seller.created_at.strftime('%Y/%m/%d')]
                ([name] + others).join(dashboard_separator).html_safe
              end
            end
          end
        end
      end
      column do
        panel "Recent sold order" do
          ul do
            Sellers::OrderSoldPaper.order(created_at: :desc).first(5).map do |order_paper|
              li do
                name = link_to(order_paper.order_info.enc_id, sales_info_path(order_paper))
                others = [currency_format(order_paper.order_info.payment.total_price_sum), order_paper.seller_info.name, order_paper.created_at.strftime('%Y/%m/%d')]
                ([name] + others).join(dashboard_separator).html_safe
              end
            end
          end
        end
      end
    end
  end # content
end
