#!/usr/local/bin/ruby

require 'logger'
require 'ftools'
require File.join(File.dirname(__FILE__), 'libs','trollop.rb')

opts = Trollop.options do
  opt :file, 'Set path to public ssh key file', :default => ''
  opt :key, 'Provide public ssh key as a string', :default => ''
  opt :dir, 'Set full path to directory with git repositories to allow access to', :default => ''
  opt :readonly, 'Set access to repositories in --dir to read only', :default => false
  opt :nobackup, 'Don\'t make backup of authorized_keys file', :default => false
  opt :authorizedkeys, 'Set authorized_keys file', :default => '~/.ssh/authorized_keys'
end
Trollop::die 'Invalid directory' unless File.directory?(opts[:dir])
Trollop::die 'No public ssh key provided' if opts[:key] == '' && !File.exists?(opts[:file])

if File.exists?(opts[:file]) then
  ssh_key = File.readlines(opts[:file])[0]
else
  ssh_key = opts[:key]
end

if File.exists?(opts[:authorizedkeys]) && !opts[:nobackup] then
  backup_file = opts[:authorizedkeys] + '.backup'
  count = 2
  while(File.exists?(backup_file)) do
    backup_file = opts[:authorizedkeys] + ".backup#{count}"
    count += 1
  end
  File.copy(opts[:authorizedkeys], backup_file)
end

only_git_cmd = File.expand_path(File.join(File.dirname(__FILE__),'only_git.rb')) + " --dir #{opts[:dir]}"
only_git_cmd << " --readonly" if opts[:readonly]

ssh_cmd = ''
ssh_cmd = "\n" if File.exists?(opts[:authorizedkeys]) && File.readlines(opts[:authorizedkeys]).last != "\n"
ssh_cmd << "command=\"#{only_git_cmd}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{ssh_key}"

File.open(opts[:authorizedkeys], 'a+') { |f| f.write(ssh_cmd) }