$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "nextbbs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "nextbbs-rails"
  spec.version     = Nextbbs::VERSION
  spec.authors     = ["tetsuyainfra"]
  spec.email       = ["tetsuyainfra@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Summary of Nextbbs."
  spec.description = "Description of Nextbbs."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.1"

  spec.add_development_dependency "byebug"

  spec.add_development_dependency "sqlite3"
  # spec.add_development_dependency "pgsql"

  spec.add_development_dependency "devise"
  # spec.add_development_dependency "cancancan"
end
