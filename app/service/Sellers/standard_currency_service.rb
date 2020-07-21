module Sellers
  class StandardCurrencyService
    def self.exchange_rate(target_currency=nil)
      target_currency = Country.current_country.iso_code if target_currency.nil?
      uri = URI.parse('https://api.exchangerate-api.com/v4/latest/' << target_currency.upcase)
      req = Net::HTTP::new(uri.host, uri.port)
      req.use_ssl = true
      res = req.get(uri.request_uri)
      JSON.parse(res.body)
    end
  end
end
