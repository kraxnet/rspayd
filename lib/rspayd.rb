# -*- encoding : utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), 'rspayd/version'))

module Rspayd
  class CzechPayment

    # accountPrefix - Předčíslí čísla účtu, na který se mají poslat prostředky.
    # accountNumber - Číslo účtu, na který se mají poslat prostředky.
    # bankCode      - Kód banky účtu, na který se mají poslat prostředky.
    # amount        - Částka platby.
    # currency      - Měna platby.
    # vs            - Variabilní symbol.
    # message       - Zpráva pro příjemce

    attr_reader :accountPrefix, :accountNumber, :bankCode, :amount, :currency, :vs, :message

    def initialize(options)
      options = Hash[options.map{|(k,v)| [k.to_sym,v]}]
      @accountPrefix  = options[:accountPrefix] || ''
      @accountNumber  = options[:accountNumber]
      @bankCode       = options[:bankCode]
      @amount         = options[:amount]
      @currency       = options[:currency] || 'CZK'
      @vs             = options[:vs]
      @message        = options[:message]
    end

    # generates czech IBAN from accountPrefix, accountNumber and bankCode
    def iban
      base = "#{bankCode}#{accountPrefix.rjust(6,'0')}#{accountNumber.rjust(10,'0')}"
      checksum = 98 - ("#{base}123500".to_i % 97)
      "CZ#{checksum}#{base}"
    end

    # SPAYD string for payment
    def to_s
      out = []
      out << "SPD*1.0"
      out << "*ACC:#{iban}"
      out << "*AM:#{'%.2f' % amount}" if amount
      out << "*CC:#{currency}" if currency
      out << "*X-VS:#{vs}" if vs
      out << "*MSG:#{message.upcase}" if message
      out.join
    end

    # generates SPAYD string for payment
    def self.generate_string(options)
      new(options).to_s
    end

  end
end
