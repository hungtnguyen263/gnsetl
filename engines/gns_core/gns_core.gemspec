$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "gns_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "gns_core"
  spec.version     = GnsCore::VERSION
  spec.authors     = ["Luan Pham"]
  spec.email       = ["luanpm88@gmail.com"]
  spec.homepage    = "http://globalnaturesoft.com"
  spec.summary     = "Core features of GNS."
  spec.description = "Core features of GNS."
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

  spec.add_dependency "rails", "~> 5.2.2"

  spec.add_development_dependency "pg"
  
  spec.add_dependency 'devise'
  spec.add_dependency 'unidecoder'
  spec.add_dependency 'roo'
  spec.add_dependency 'rubyzip'
  spec.add_dependency	'cancan'
  spec.add_dependency 'carrierwave'
  spec.add_dependency 'mini_magick'
  spec.add_dependency 'rubyXL'
  spec.add_dependency 'figaro'
  spec.add_dependency 'delayed_job_active_record'
  spec.add_dependency 'sidekiq'
  spec.add_dependency 'tiny_tds'
  spec.add_dependency 'activerecord-sqlserver-adapter'
end
