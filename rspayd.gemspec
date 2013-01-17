# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspayd/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jir\314\214i\314\201 Kubi\314\201c\314\214ek"]
  gem.email         = ["jiri.kubicek@kraxnet.cz"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rspayd"
  gem.require_paths = ["lib"]
  gem.version       = Rspayd::VERSION
end
