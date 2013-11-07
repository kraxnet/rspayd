# -*- encoding : utf-8 -*-

module Rspayd
  class CzechBankAccountNumberParser

    attr_reader :bank_account_number

    def initialize(bank_account_number)
      @bank_account_number = bank_account_number
    end

    def bank_code
      bank_account_number_parts[1]
    end

    def account_prefix
      bank_account_number_account_number_parts_reversed[1]
    end

    def account_number
      bank_account_number_account_number_parts_reversed[0]
    end

    private

    def bank_account_number_parts
      bank_account_number.split('/')
    end

    def bank_account_number_account_number_parts_reversed
      bank_account_number_parts[0].split('-').reverse
    end

  end
end
