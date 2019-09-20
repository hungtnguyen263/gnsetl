$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "gns_ux/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "gns_ux"
  spec.version     = GnsUx::VERSION
  spec.authors     = ["Luan Pham"]
  spec.email       = ["luanpm88@gmail.com"]
  spec.homepage    = "http://globalnaturesoft.com"
  spec.summary     = "UX features of GNS."
  spec.description = "UX features of GNS."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib,public}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2" 
    
  spec.add_dependency 'will_paginate'
  spec.add_dependency 'will_paginate-bootstrap'
end
