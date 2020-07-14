module FormatHelper
  def currency_format(num, unit: I18n.t('etc.currency_unit'), format: I18n.t('etc.currency_format'), precision: 0, **opt)
    # (ver1) number_to_currency num, unit: unit, format: format, precision: precision, **opt
    negative_mark = num.negative? ? '- ' : ''
    negative_mark + Money.new(num.abs * current_currency.subunit_to_unit, current_country.iso_code).format(thousands_separator: ',', **opt)
  end

  def unit_format(num, unit: I18n.t('etc.quantity_unit'), format: '%n %u', precision: 0, **opt)
    number_to_currency num, unit: unit, format: format, precision: precision, **opt
  end

  def integer_marker(num = 0)
    return '' if num.to_i.zero?

    num.negative? ? '-' : '+'
  end

  def currency_with_marker(num, unit: I18n.t('etc.currency_unit'), format: I18n.t('etc.currency_format'), precision: 0, **opt)
    marker = integer_marker(num) == '-' ? '' : '+'
    marker + currency_format(num, unit: unit, format: format, precision: precision, **opt)
  end

  # @param <Integer> price
  # @return <String> price.00
  def pixel_price_format(price)
    format '%.2f', price
  end

  def safe_l(datetime)
    datetime.respond_to?(:strftime) ? l(datetime) : '-'
  end
end
