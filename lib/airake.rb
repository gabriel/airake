require 'rubygems'
require 'yaml'
require 'active_support'

$:.unshift File.dirname(__FILE__)

module Airake; end

require 'airake/daemonize'
require 'airake/fcsh'
require 'airake/fcshd'
require 'airake/commands/base'
require 'airake/commands/acompc'
require 'airake/commands/mxmlc'
require 'airake/commands/adl'
require 'airake/commands/adt'
require 'airake/commands/asdoc'
require 'airake/project'
require 'airake/projects/air'
require 'airake/projects/flash'
require 'airake/runner'
require 'rake'
require 'airake/tasks'

unless Object.respond_to?(:blank?)
  require 'airake/core_ext/blank' 
end