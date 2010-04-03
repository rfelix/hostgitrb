# -*- encoding: utf-8 -*-
require 'rubygems'
require 'rake'

HOSTGITRB_GEMSPEC = Gem::Specification.new do |spec|
  spec.name = 'hostgitrb'
  spec.summary = "Simple Git repository hosting using SSH keys"
  spec.version = File.read(File.dirname(__FILE__) + '/VERSION').strip
  spec.authors = ['Raoul Felix']
  spec.email = 'hostgitrb@rfelix.com'
  spec.description = <<-END
      This gem contains some simple scripts to help give people access to Git 
      repositories without giving them full access via SSH.
    END
  spec.executables = ['hostgitrb']
  spec.files = FileList['lib/*', 'vendor/*', 'bin/*'] + ['Rakefile', 'README.textile']
  spec.homepage = 'http://rfelix.com/'
end