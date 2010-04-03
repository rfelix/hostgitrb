# ----- Utility Functions -----

def scope(path)
  File.join(File.dirname(__FILE__), path)
end

# ----- Packaging -----

require 'rake/gempackagetask'
load scope('hostgitrb.gemspec')

Rake::GemPackageTask.new(HOSTGITRB_GEMSPEC) do |pkg|
  if Rake.application.top_level_tasks.include?('release')
    pkg.need_tar_gz  = true
    pkg.need_tar_bz2 = true
    pkg.need_zip     = true
  end
end

desc "Install HostGitRb as a gem."
task :install => [:package] do
  sudo = RUBY_PLATFORM =~ /win32|mingw/ ? '' : 'sudo'
  gem  = RUBY_PLATFORM =~ /java/  ? 'jgem' : 'gem' 
  #sh %{#{sudo} #{gem} install --no-ri pkg/hostgitrb-#{File.read(scope('VERSION')).strip}}
  sh %{#{gem} install --no-ri pkg/hostgitrb-#{File.read(scope('VERSION')).strip}}  
end