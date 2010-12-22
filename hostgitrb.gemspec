# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name = 'hostgitrb'
  spec.summary = "Simple Git repository hosting using SSH Public Keys"
  spec.version = File.read(File.dirname(__FILE__) + '/VERSION').strip
  spec.authors = ['Raoul Felix']
  spec.email = 'rf@rfelix.com'
  spec.description = <<-END
      HostGitRb allows you to share your Git repositories with other users
      using SSH Public keys as authentication. You only need one shell account,
      which makes this great to use in a shared hosting environment, and users
      won't be able to do anything else other than push/pull to the repositories
      you define.
    END
  spec.executables = ['hostgitrb']
  spec.add_development_dependency('rake')
  spec.add_development_dependency('mg')
  spec.files = Dir['lib/*', 'vendor/*', 'bin/*'] + ['Rakefile', 'README.textile']
  spec.homepage = 'http://rfelix.com/'
end
