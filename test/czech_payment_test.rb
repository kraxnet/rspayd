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

    assert_equal 'SPD*1.0*ACC:CZ9555000000000810883001*AM:430.00*CC:CZK*X-VS:31030001*MSG:PLATBA ZA DOMENU', result
  end
end
