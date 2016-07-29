require 'test_helper'

class CzechBankAccountNumberParserTest < MiniTest::Test
  def test_bank_account_number_parsing_with_prefix
    parser = Rspayd::CzechBankAccountNumberParser.new('111222-1122334455/1234')

    assert_equal '111222', parser.account_prefix
    assert_equal '1122334455', parser.account_number
    assert_equal '1234', parser.bank_code
  end

  def test_bank_account_number_parsing_without_prefix
    parser = Rspayd::CzechBankAccountNumberParser.new('1122334455/1234')

    assert_nil parser.account_prefix
    assert_equal '1122334455', parser.account_number
    assert_equal '1234', parser.bank_code
  end
end
