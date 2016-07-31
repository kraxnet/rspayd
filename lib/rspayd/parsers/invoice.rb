module Rspayd
  module Parser
    class Invoice < Base
      HEADER = 'SID*1.0*'
      MANDATORY_KEYS = %w(ID DD) # FIXME: AM (can be in qr_payment)
      OPTIONAL_KEYS = %w(AM TP TD SA MSG ON VS VII INI VIR INR DUZP DPPD DT
                          TB0 T0 TB1 T1 TB2 T2 NTB CC FX FXA ACC CRC32)

      def convert_keys!
        values[:invoice_id]=values.delete('ID')
        values[:issued_on]=values.delete('DD')
        values[:amount]=values.delete('AM')
        values[:tax_type]=values.delete('TP')
        values[:document_type]=values.delete('TD')
        # values[:]=values.delete('SA') # FIXME
        values[:invoice_msg]=values.delete('MSG')
        values[:order_number]=values.delete('ON')
        values[:variable_symbol]=values.delete('VS')
        values[:issuer_vat_id]=values.delete('VII')
        values[:issuer_id_number]=values.delete('INI')
        values[:receiver_vat_id]=values.delete('VIR')
        values[:receiver_id_number]=values.delete('INR')
        values[:tax_point_date]=values.delete('DUZP')
        # values[:tax_point_date]=values.delete('DPPD') # FIXME
        values[:due_date]=values.delete('DT')
        values[:tax_base_0]=values.delete('TB0')
        values[:tax_0]=values.delete('T0')
        values[:tax_base_1]=values.delete('TB1')
        values[:tax_1]=values.delete('T1')
        values[:tax_base_2]=values.delete('TB2')
        values[:tax_2]=values.delete('T2')
        values[:not_taxable_base]=values.delete('NTB')
        values[:country_code]=values.delete('CC')
        # values[:]=values.delete('FX')  # FIXME
        # values[:]=values.delete('FXA')  # FIXME
        values[:account]=values.delete('ACC')

        values.reject! { |_, v| v.nil? }
      end

    end
  end
end
