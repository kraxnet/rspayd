# -*- encoding : utf-8 -*-
require File.expand_path('../lib/rspayd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jiri Kubicek"]
  gem.email         = ["jiri.kubicek@kraxnet.cz"]
  gem.description   = %q{Gem for generating spayd content}
  gem.summary       = %q{SPAYD (Short Payment Descriptor) is a format used by CBA (Ceska bankovni asociace) for QR Payment (QR Platba). This gem generates payment info in SPAYD format.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rspayd"
  gem.require_paths = ["lib"]
  gem.version       = Rspayd::VERSION
end
