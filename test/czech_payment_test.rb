require 'test_helper'

class CzechPaymentTest < MiniTest::Unit::TestCase
  def test_simple_czech_payment
    result = Rspayd::CzechPayment.generate_string(
      :accountNumber => '810883001',
      :bankCode => '5500',
      :amount => 430.00,
      :vs => '31030001',
      :message => 'Platba za domenu'
    )

    assert_equal 'SPD*1.0*ACC:CZ9555000000000810883001*AM:430.00*CC:CZK*MSG:PLATBA ZA DOMENU*X-VS:31030001', result
  end

  def test_czech_payment_with_account_prefix
    result = Rspayd::CzechPayment.generate_string(
      :accountPrefix => '7755',
      :accountNumber => '77628031',
      :bankCode => '0710',
      :amount => 500.00,
      :vs => '1234567890'
    )

    assert_equal 'SPD*1.0*ACC:CZ5607100077550077628031*AM:500.00*CC:CZK*X-VS:1234567890', result
  end

  def test_sample_payment
    result = Rspayd::CzechPayment.generate_string(
      :iban => 'CZ5855000000001265098001',
      :amount => 480.5,
      :currency => 'CZK',
      :rf => '7004139146',
      :dt => '20120524',
      :message => 'Platba za zbozi',
      :ss => 1234567890
    )

    assert_equal 'SPD*1.0*ACC:CZ5855000000001265098001*AM:480.50*CC:CZK*RF:7004139146*DT:20120524*MSG:PLATBA ZA ZBOZI*X-SS:1234567890', result
  end
end
