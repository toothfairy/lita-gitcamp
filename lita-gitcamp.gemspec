Gem::Specification.new do |spec|
  spec.name          = "lita-gitcamp"
  spec.version       = "0.0.1"
  spec.authors       = ["Sergeev Peter"]
  spec.email         = ["sergeev.peter@gmail.com"]
  spec.description   = %q{Gitcamp handler is your magic helper which closes your basecamp todos for you.}
  spec.summary       = %q{Your all-seeing eye.}
  spec.homepage      = "https://github.com/toothfairy/lita-gitcamp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 2.6"
  spec.add_runtime_dependency "bundler", "~> 1.3"
  spec.add_runtime_dependency "octokit", "~> 2.4.0"
  spec.add_runtime_dependency "bcx"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.14"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock"
  spec.add_runtime_dependency "redis-namespace", "~> 1.3.0"
end
