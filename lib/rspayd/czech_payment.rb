# -*- encoding : utf-8 -*-

module Rspayd
  class CzechPayment < Payment

    # Specifická rozšíření pro ČR:
    # accountPrefix - Předčíslí čísla účtu, na který se mají poslat prostředky.
    # accountNumber - Číslo účtu, na který se mají poslat prostředky.
    # bankCode      - Kód banky účtu, na který se mají poslat prostředky.
    # vs            - Variabilní symbol.
    # ss            - Specifický symbol.

    attr_reader :accountPrefix, :accountNumber, :bankCode, :vs, :ss

    def initialize(options)
      options = Hash[options.map { |(k, v)| [k.to_sym, v] }]

      if options[:accountNumber] && options[:accountNumber].match('/')
        czech_bank_account_number_parser = CzechBankAccountNumberParser.new(options[:accountNumber])

        @accountPrefix = czech_bank_account_number_parser.account_prefix || ''
        @accountNumber = czech_bank_account_number_parser.account_number
        @bankCode = czech_bank_account_number_parser.bank_code
      else
        @accountPrefix = options[:accountPrefix] || ''
        @accountNumber = options[:accountNumber]
        @bankCode = options[:bankCode]
      end

      @vs = options[:vs]
      @ss = options[:ss]

      super
    end

    # generates czech IBAN from accountPrefix, accountNumber and bankCode
    def iban
      return @iban if @iban
      base = "#{bankCode}#{accountPrefix.rjust(6,'0')}#{accountNumber.rjust(10,'0')}"
      checksum = (98 - ("#{base}123500".to_i % 97)).to_s.rjust(2,'0')
      "CZ#{checksum}#{base}"
    end

    # SPAYD string for payment
    def to_s
      out = [ super ]
      out << "*X-VS:#{vs}" if vs
      out << "*X-SS:#{ss}" if ss
      out.join
    end
  end
end
