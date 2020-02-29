lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "visualize_activities/version"

Gem::Specification.new do |spec|
  spec.name          = "visualize_activities"
  spec.version       = VisualizeActivities::VERSION
  spec.authors       = ["tyamaguc07"]
  spec.email         = ["tyamaguc07@gmail.com"]

  spec.summary       = %q{Visualize Activities on Github}
  spec.description   = %q{Visualize Activities on Github}
  spec.homepage      = "http://exsample.com"

  spec.metadata["allowed_push_host"] = "http://exsample.com"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "thor"
  spec.add_dependency "graphql-client"
  spec.add_dependency "activesupport"
end
