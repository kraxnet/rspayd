# -*- encoding : utf-8 -*-

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
end
