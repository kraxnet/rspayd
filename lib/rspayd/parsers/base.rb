require 'zlib'

module Rspayd
  module Parser
    class Error < StandardError
    end

    class Base
      attr_reader :values

      def initialize(code)
        @code = code
        @values = code.split(self.class::HEADER)[1].split('*').collect{|i|
          i.split(':',2)
        }.to_h
      end

      def check_keys!
        missing_keys = self.class::MANDATORY_KEYS - values.keys
        raise Error.new("MISSING KEYS #{missing_keys}") unless missing_keys.empty?
        unknown_keys = values.keys - self.class::MANDATORY_KEYS - self.class::OPTIONAL_KEYS
        unknown_keys.reject!{|key| key.match(/\AX-/)}
        raise Error.new("UNKNOWN KEYS #{unknown_keys}") unless unknown_keys.empty?
      end

      def check_crc!
        crc = values.delete('CRC32')
        if crc
          # sort by keys alphabeticaly
          crc_base = self.class::HEADER + values.keys.sort.collect{|key|
            "#{key}:#{values[key]}"
          }.join('*')
          crc_counted = Zlib::crc32(crc_base).to_s(16).upcase
          raise Error.new("BAD CRC (expected #{crc_counted}, was #{crc})") unless crc==crc_counted
        end
      end

      def self.parse(code)
        decoder = self.new(code)
        decoder.check_keys!
        decoder.check_crc!
        decoder.convert_keys!
        decoder.values
      end
    end
  end
end
