require 'test_helper'

class ParserTest < MiniTest::Test

  def test_crc_error
    code="SPD*1.0*CC:CZK*ACC:CZ5855000000001265098001*AM:100.00*CRC32:AAD80227X"
    assert_raises Rspayd::Parser::Error do
      Rspayd::Parser.parse(code)
    end
  end

  def test_missing_keys
    code="SPD*1.0*CC:CZK*AM:100.00"
    assert_raises Rspayd::Parser::Error do
      Rspayd::Parser.parse(code)
    end
  end

  def test_sample_payment
    code="SPD*1.0*ACC:CZ5855000000001265098001*AM:480.50*CC:CZK*RF:7004139146*X-SS:1234567890*DT:20120524*MSG:PLATBA ZA ZBOZI"
    parsed = Rspayd::Parser.parse(code)
    assert_equal({
      account: "CZ5855000000001265098001",
      amount: "480.50",
      country_code: "CZK",
      message: "PLATBA ZA ZBOZI",
      payment_identification: "7004139146",
      specific_symbol: "1234567890",
      due_date: "20120524"
    }, parsed)
  end

  def test_sample_1_invoice
    code="SID*1.0*ID:012150672*DD:20151201*TP:0*AM:495.00*VS:012150672*VII:CZ60194383*INI:60194383*VIR:CZ12345678*DUZP:20151201*DT:20151217*TB0:409.09*T0:85.91*CC:CZK*ACC:CZ3103000000270016060243*"
    parsed = Rspayd::Parser.parse(code)
    assert_equal({
      invoice_id: "012150672",
      issued_on: "20151201",
      amount: "495.00",
      tax_type: "0",
      variable_symbol: "012150672",
      issuer_vat_id: "CZ60194383",
      issuer_id_number: "60194383",
      receiver_vat_id: "CZ12345678",
      tax_point_date: "20151201",
      due_date: "20151217",
      tax_base_0: "409.09",
      tax_0: "85.91",
      country_code: "CZK",
      account: "CZ3103000000270016060243"
    }, parsed)
  end

  def test_sample_1_invoice_in_payment
    code="SPD*1.0*CC:CZK*ACC:CZ3103000000270016060243*AM:495.00*X-VS:012150672*X-INV:SID%2A1.0%2AID:012150672%2ADD:20151201%2ATP:0%2AVII:CZ60194383%2AINI:60194383%2AVIR:CZ12345678%2ADUZP:20151201%2ADT:20151217%2ATB0:409.09%2AT0:85.91*"
    parsed = Rspayd::Parser.parse(code)
    assert_equal({
      invoice_id: "012150672",
      issued_on: "20151201",
      amount: "495.00",
      tax_type: "0",
      variable_symbol: "012150672",
      issuer_vat_id: "CZ60194383",
      issuer_id_number: "60194383",
      receiver_vat_id: "CZ12345678",
      tax_point_date: "20151201",
      due_date: "20151217",
      tax_base_0: "409.09",
      tax_0: "85.91",
      country_code: "CZK",
      account: "CZ3103000000270016060243"
    }, parsed)
  end

  def test_sample_2_invoice
    code="SID*1.0*ID:2001401154*DD:20140404*TP:9*AM:61189.00*MSG:Dodávka vybavení interiéru hotelu Kamzík*VS:3310001054*VII:CZ25568736*INI:25568736*INR:25568736*VIR:CZ25568736*DUZP:20140404*DT:20140412*TB0:26492.70*T0:5563.47*TB1:25333.10*T1:3799.97*NTB:-0.24*CC:CZK*TD:0*SA:0*ACC:CZ9701000000007098760287+KOMBCZPP*X-SW:MoneyS5-1.7.1"
    parsed = Rspayd::Parser.parse(code)
    assert_equal({
      "SA" => "0",
      "X-SW" => "MoneyS5-1.7.1",
      invoice_id: "2001401154",
      issued_on: "20140404",
      amount: "61189.00",
      tax_type: "9",
      document_type: "0",
      invoice_msg: "Dodávka vybavení interiéru hotelu Kamzík",
      variable_symbol: "3310001054",
      issuer_vat_id: "CZ25568736",
      issuer_id_number: "25568736",
      receiver_vat_id: "CZ25568736",
      receiver_id_number: "25568736",
      tax_point_date: "20140404",
      due_date: "20140412",
      tax_base_0: "26492.70",
      tax_0: "5563.47",
      tax_base_1: "25333.10",
      tax_1: "3799.97",
      not_taxable_base: "-0.24",
      country_code: "CZK",
      account: "CZ9701000000007098760287+KOMBCZPP"
    }, parsed)
  end

  def test_sample_2_invoice_in_payment
    code="SPD*1.0*AM:61189.00*X-VS:3310001054*DT:20140412*CC:CZK*ACC:CZ9701000000007098760287+KOMBCZPP*X-INV:SID%2A1.0%2AID:2001401154%2AMSG:Dodávka vybavení interiéru hotelu Kamzík%2ADD:20140404%2ATP:9%2AVII:CZ25568736%2AINI:25568736%2AINR:25568736%2AVIR:CZ25568736%2ADUZP:20140404%2ADT:20140412%2ATB0:26492.70%2AT0:5563.47%2ATB1:25333.10%2AT1:3799.97%2ANTB:-0.24%2ATD:0%2ASA:0%2AX-SW:MoneyS5-1.7.1*"
    parsed = Rspayd::Parser.parse(code)
    assert_equal({
      "SA" => "0",
      "X-SW" => "MoneyS5-1.7.1",
      invoice_id: "2001401154",
      issued_on: "20140404",
      amount: "61189.00",
      tax_type: "9",
      document_type: "0",
      invoice_msg: "Dodávka vybavení interiéru hotelu Kamzík",
      variable_symbol: "3310001054",
      issuer_vat_id: "CZ25568736",
      issuer_id_number: "25568736",
      receiver_vat_id: "CZ25568736",
      receiver_id_number: "25568736",
      tax_point_date: "20140404",
      due_date: "20140412",
      tax_base_0: "26492.70",
      tax_0: "5563.47",
      tax_base_1: "25333.10",
      tax_1: "3799.97",
      not_taxable_base: "-0.24",
      country_code: "CZK",
      account: "CZ9701000000007098760287+KOMBCZPP"
    }, parsed)
  end
end
