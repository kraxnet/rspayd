require 'rspayd/parsers/base'
require 'rspayd/parsers/payment'
require 'rspayd/parsers/invoice'

module Rspayd
  module Parser
    def self.parse(code)
      if code.match(/\ASPD/)
        values = Payment.parse(code)
        unless values['X-INV'].nil?
          invoice_values = Invoice.parse(values.delete('X-INV').gsub(/%2A/,'*'))
          values.merge!(invoice_values)
        end
        values
      elsif code.match(/\ASID/)
        Invoice.parse(code)
      end
    end
  end
end
