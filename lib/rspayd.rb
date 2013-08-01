# -*- encoding : utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), 'rspayd/version'))

module Rspayd
  class Payment

    # iban          - Číslo účtu, na který se mají poslat prostředky, ve formátu IBAN.
    # amount        - Částka platby.
    # currency      - Měna platby.
    # rf            - Identifikátor platby pro příjemce.
    # dt            - Datum splatnosti.
    # message       - Zpráva pro příjemce.

    attr_reader :iban, :amount, :currency, :rf, :dt, :message

    def initialize(options)
      options = Hash[options.map{|(k,v)| [k.to_sym,v]}]
      @iban           = options[:iban]
      @amount         = options[:amount]
      @currency       = options[:currency] || 'CZK'
      @rf             = options[:rf]
      @dt             = options[:dt]
      @message        = options[:message]
    end

    # SPAYD string for payment
    def to_s
      out = []
      out << "SPD*1.0"
      out << "*ACC:#{iban}"
      out << "*AM:#{'%.2f' % amount}" if amount
      out << "*CC:#{currency}" if currency
      out << "*RF:#{rf}" if rf
      out << "*DT:#{dt}" if dt
      out << "*MSG:#{message.upcase}" if message
      out.join
    end

    # generates SPAYD string for payment
    def self.generate_string(options)
      new(options).to_s
    end
  end

  class CzechPayment < Payment

    # Specifická rozšíření pro ČR:
    # accountPrefix - Předčíslí čísla účtu, na který se mají poslat prostředky.
    # accountNumber - Číslo účtu, na který se mají poslat prostředky.
    # bankCode      - Kód banky účtu, na který se mají poslat prostředky.
    # vs            - Variabilní symbol.
    # ss            - Specifický symbol.

    attr_reader :accountPrefix, :accountNumber, :bankCode, :vs, :ss

    def initialize(options)
      options = Hash[options.map{|(k,v)| [k.to_sym,v]}]
      @accountPrefix  = options[:accountPrefix] || ''
      @accountNumber  = options[:accountNumber]
      @bankCode       = options[:bankCode]
      @vs             = options[:vs]
      @ss             = options[:ss]
      super
    end

    # generates czech IBAN from accountPrefix, accountNumber and bankCode
    def iban
      return @iban if @iban
      base = "#{bankCode}#{accountPrefix.rjust(6,'0')}#{accountNumber.rjust(10,'0')}"
      checksum = 98 - ("#{base}123500".to_i % 97)
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
