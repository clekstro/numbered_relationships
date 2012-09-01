$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "numbered_relationships/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "numbered_relationships"
  s.version     = NumberedRelationships::VERSION
  s.authors     = ["Curtis Ekstrom"]
  s.email       = ["ce@canvus.io"]
  s.homepage    = "https://github.com/clekstro/numbered_relationships"
  s.summary     = "Extend ActiveRecord models with amount-based filters for models and their associations"
  s.description = "Amount-based filtering for AR Models and Associations"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.7"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
