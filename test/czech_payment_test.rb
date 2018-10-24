require 'test_helper'

class CzechPaymentTest < MiniTest::Test
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

  def test_simple_czech_payment_using_full_account_number
    result = Rspayd::CzechPayment.generate_string(
      :accountNumber => '810883001/5500',
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

  def test_czech_payment_with_account_prefix_using_full_account_number
    result = Rspayd::CzechPayment.generate_string(
      :accountNumber => '7755-77628031/0710',
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

  def test_czech_payment_with_constant_symbol
    result = Rspayd::CzechPayment.generate_string(
      :accountNumber => '810883001',
      :bankCode => '5500',
      :amount => 430.00,
      :vs => '31030001',
      :ks => '1234567890',
      :message => 'Platba za domenu'
    )

    assert_equal 'SPD*1.0*ACC:CZ9555000000000810883001*AM:430.00*CC:CZK*MSG:PLATBA ZA DOMENU*X-VS:31030001*X-KS:1234567890', result
  end


  def test_iban_checksum_prepend
    result = Rspayd::CzechPayment.new(
      :accountNumber => '2950281886',
      :bankCode => '2010'
    )
    assert_equal 'CZ0420100000002950281886', result.iban
  end

  def test_striping_spaces_from_account_number
    result = Rspayd::CzechPayment.new(
      :accountNumber => '1230 - 2950281888 / 2010'
    )
    assert_equal 'CZ2920100012302950281888', result.iban
  end

end
