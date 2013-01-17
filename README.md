# Rspayd

SPAYD (Short Payment Descriptor) is a format used by CBA (Česká bankovní asociace) for QR Payment (QR Platba). This gem generates payment info in SPAYD format.

Great for use with ruby QR code gem [rqrcode](http://whomwah.github.com/rqrcode/).

## Installation

Add this line to your application's Gemfile:

    gem 'rspayd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspayd

## Usage

    >> Rspayd::CzechPayment.generate_string(
      :accountNumber=>'810883001',
      :bankCode => '5500',
      :amount => 430.00,
      :vs=>"31030001",
      :message => "Platba za domenu"
    )
    => SPD*1.0*IBAN:CZ9555000000000810883001*AM:430.00*CC:CZK*X-VS:31030001*MSG:PLATBA ZA DOMENU

## Contributing

This gem implements only the basic SPLAY subset needed for simple payment in Czech Republic. Feel free to extend this gem based on your needs and send pull requests.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
