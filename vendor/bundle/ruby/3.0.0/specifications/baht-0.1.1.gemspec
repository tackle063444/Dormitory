# -*- encoding: utf-8 -*-
# stub: baht 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "baht".freeze
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["narze".freeze]
  s.bindir = "exe".freeze
  s.date = "2019-03-22"
  s.description = "".freeze
  s.email = ["manassarn@gmail.com".freeze]
  s.homepage = "https://github.com/narze/baht".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Convert number to Thai Baht currency".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.17"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.17"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
  end
end
