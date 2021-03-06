Gem::Specification.new do |s|
  s.name = 'data_attributes'
  s.version = File.read("#{File.dirname(__FILE__)}/VERSION").strip
  s.platform = Gem::Platform::RUBY
  s.author = 'Alexis Toulotte'
  s.email = 'al@alweb.org'
  s.homepage = 'https://github.com/alexistoulotte/data_attributes'
  s.summary = 'Provides HTML data attributes from model to view'
  s.description = 'A gem to provide HTML data attributes from model to view'
  s.license = 'MIT'

  s.files = `git ls-files | grep -vE '^(spec/|test/|\\.|Gemfile|Rakefile)'`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'activesupport', '>= 4.1.0', '< 6.0.0'

  s.add_development_dependency 'actionview', '>= 4.1.0', '< 6.0.0'
  s.add_development_dependency 'activemodel', '>= 4.1.0', '< 6.0.0'
  s.add_development_dependency 'byebug', '>= 9.0.0', '< 10.0.0'
  s.add_development_dependency 'rake', '>= 12.0.0', '< 13.0.0'
  s.add_development_dependency 'rspec', '>= 3.5.0', '< 3.7.0'
end
