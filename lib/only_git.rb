#!/usr/bin/env ruby

require 'logger'
require File.join(File.dirname(__FILE__), '..', 'vendor', 'trollop.rb')

LOG_FILE = File.expand_path('~/.hostgitrb.log')
LOG_TOGGLE_FILE = File.expand_path('~/.hostgitrb.log.enabled')
DEBUG_TOGGLE_FILE = File.expand_path('~/.hostgitrb.debug.enabled')

#Examples of commands that are permitted and that are used by git (git clone/git fetch/git push/git pull)
#  git-upload-pack '/home/user/repo/Notes.git'
#  git-receive-pack '/home/user/repo/Notes.git'
#  git-upload-pack 'Notes.git'
GIT_R_REGEX = /^git[\-](upload)[\-]pack '([0-9a-zA-Z\-_\/]+)([.]git)?'$/
GIT_RW_REGEX = /^git[\-](upload|receive)[\-]pack '([0-9a-zA-Z\-_\/]+)([.]git)?'$/

opts = Trollop::options do
  opt :dir, "Set directory that contains git repositories", :default => ''
  opt :readonly, "Set access to repositories under --dir to read only", :default => false
end
Trollop::die 'Directory with git repositories doesn\'t exist. Needs to be set with --dir' unless File.directory? opts[:dir]

DEBUG_LEVEL = if File.exists?(DEBUG_TOGGLE_FILE)
                 Logger::DEBUG
              elsif File.exists?(LOG_TOGGLE_FILE)
                Logger::ERROR
              end

if !DEBUG_LEVEL.nil?
  logger = Logger.new(LOG_FILE, 'weekly')
  logger.level = DEBUG_LEVEL
else
  class NullObjectLogger
    def method_missing(sym, *args, &block)
      super unless [:debug, :warn, :info, :error].include? sym
    end
  end
  logger = NullObjectLogger.new
end

command = String.new(ENV['SSH_ORIGINAL_COMMAND'])
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
  logger.error("Received bad command")
  exec 'echo "Not Allowed By HostGitRb"'
end


