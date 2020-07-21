module Sellers
  class AccountInfo < ApplicationRecord
    belongs_to :seller_info, class_name: 'Sellers::SellerInfo', dependent: :destroy
  end
end
