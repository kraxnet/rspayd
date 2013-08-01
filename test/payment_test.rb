require 'test_helper'

class PaymentTest < MiniTest::Unit::TestCase
  def test_sample_payment
    result = Rspayd::Payment.generate_string(
      :iban => 'CZ5855000000001265098001',
      :amount => 480.5,
      :currency => 'CZK',
      :rf => '7004139146',
      :dt => '20120524',
      :message => 'Platba za zbozi'
    )

    assert_equal 'SPD*1.0*ACC:CZ5855000000001265098001*AM:480.50*CC:CZK*RF:7004139146*DT:20120524*MSG:PLATBA ZA ZBOZI', result
  end

end
