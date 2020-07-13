class Seller < User
  default_scope -> { sellers }
  has_one :seller_info, class_name: 'Sellers::SellerInfo'
end
