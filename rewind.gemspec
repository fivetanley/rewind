$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rewind/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rewind"
  s.version     = Rewind::VERSION
  s.authors     = ["Stanley Stuart"]
  s.email       = ["stanley+github@stan.li"]
  s.homepage    = ""
  s.summary     = "Record your rails requests and reuse them in your JavaScript tests."
  s.description = "Record your rails requests and reuse them in your JavaScript tests."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.1"

  s.add_development_dependency "sqlite3"
end
