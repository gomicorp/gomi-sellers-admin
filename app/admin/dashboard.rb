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
                li link_to("#{statement.seller_info.seller.name} ", '#')
              end
            end
          end
        end
      end

      columns do
        column do
          panel "Newly applied students" do
            ul do
              # Sellers::SellerInfo.order()
            end
          end
        end
      end
  end # content
end
