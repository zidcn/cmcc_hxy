
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cmcc_hxy/version"

Gem::Specification.new do |spec|
  spec.name          = "cmcc_hxy"
  spec.version       = CmccHxy::VERSION
  spec.authors       = ["zidcn"]
  spec.email         = ["zd@zidcn.com"]

  spec.summary       = %q{CMCC hxy.}
  spec.description   = %q{CMCC hexiaoyuan API.}
  spec.homepage      = "https://github.com/zidcn/cmcc_hxy.git"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "webmock", "~> 3.8.3"
  spec.add_development_dependency "rest-client", "~> 2.0.2"
end
