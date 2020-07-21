module Sellers
  class SelectedProduct < ApplicationRecord
    belongs_to :store_info, class_name: 'Sellers::StoreInfo', dependent: :destroy
    belongs_to :product, dependent: :destroy

  end
end
