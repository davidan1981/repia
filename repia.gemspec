$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "repia/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "repia"
  s.version     = Repia::VERSION
  s.authors     = ["David An"]
  s.email       = ["david.an@ave81.com"]
  s.homepage    = "https://github.com/davidan1981/repia"
  s.summary     = "Rails Essential Plug-in for API"
  s.description = "It is a collection of basic features required to build RESTful API in Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "uuidtools", "~> 2.1.5"
  s.add_dependency "simplecov"
  s.add_dependency "coveralls"

  s.add_development_dependency "sqlite3"
end
