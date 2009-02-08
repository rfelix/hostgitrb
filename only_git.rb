#!/usr/local/bin/ruby

require 'logger'
require File.join(File.dirname(__FILE__), 'libs','trollop.rb')

#Examples of commands that are permitted and that are used by git (git clone/git fetch/git push/git pull)
#  git-upload-pack '/home/rfelixc/gitrepo/cpd/Notes'
#  git-receive-pack '/home/rfelixc/gitrepo/cpd/Notes'
#  git-upload-pack 'Notes'
GIT_R_REGEX = /^git[\-](upload)[\-]pack '([a-zA-Z\-_]+)([.]git)?'$/
GIT_RW_REGEX = /^git[\-](upload|receive)[\-]pack '([a-zA-Z\-_]+)([.]git)?'$/

opts = Trollop::options do
  opt :log, "Set log file", :default => File.join(File.dirname(__FILE__), 'debug.log')
  opt :dir, "Set directory that contains git repositories", :default => ''
  opt :readonly, "Set access to repositories under --dir to read only", :default => false
end
Trollop::die 'Directory with git repositories doesn\'t exist. Needs to be set with --dir' unless File.directory? opts[:dir]

logger = Logger.new(opts[:log])
logger.level = Logger::WARN

command = ENV['SSH_ORIGINAL_COMMAND']
logger.debug("Received command: #{command}")

right_command = GIT_RW_REGEX
right_command = GIT_R_REGEX if opts[:readonly]
logger.debug('Access to repos under dir is set to: ' + (opts[:readonly] ? 'Read' : 'Read/Write'))
                
if command =~ right_command then
  opts[:dir] = File.join(opts[:dir], '')
  command.gsub!("-pack '", "-pack '#{opts[:dir]}")
  logger.info("Executing command: #{command}")
  exec command
else
  logger.info("Received bad command")
  exec 'echo NOT ALLOWED'
end


