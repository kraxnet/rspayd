module Rspayd
  module Parser
    class Payment < Base
      HEADER = 'SPD*1.0*'
      MANDATORY_KEYS = %w(ACC)
      OPTIONAL_KEYS = %w(ALT-ACC AM CC RF RN DT PT MSG CRC32 NT NTA)
      EXTENDING_KEYS = %w(X-PER X-VS X-SS X-KS X-ID X-URL)

      def convert_keys!
        values[:account]=values.delete('ACC')
        values[:alternate_account]=values.delete('ALT-ACC')
        values[:amount]=values.delete('AM')
        values[:country_code]=values.delete('CC')
        values[:payment_identification]=values.delete('RF')
        values[:receiver_name]=values.delete('RN')
        values[:due_date]=values.delete('DT')
        values[:payment_type]=values.delete('PT')
        values[:message]=values.delete('MSG')
        values[:notification]=values.delete('NT')
        values[:notification_address]=values.delete('NTA')
        values[:variable_symbol]=values.delete('X-VS')
        values[:specific_symbol]=values.delete('X-SS')
        values.reject! { |_, v| v.nil? }
      end

    end
  end
end
