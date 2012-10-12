# ruby encoding: utf-8
# ü
if $:.include?(File.dirname(__FILE__))  ||  $:.include?(File.expand_path(File.dirname(__FILE__)))
  #puts 'Path schon aktuell'
else
  $:.unshift(File.dirname(__FILE__)) 
end



module Perception #:nodoc
  VERSION = '0.3.1'
end


require 'pp'
require 'set'
require 'kyanite/string/mgsub'
require 'kyanite/string/nested'
require 'kyanite/general/callerutils'
require 'kyanite/array/array'


require 'perception/const' 
require 'perception/perception_private'        
require 'perception/perception_main'   
require 'perception/ppp' 
#require 'perception/test' 
require 'perception/string_spread' 
require 'perception/numeric' 
require 'perception/date_and_time' 
require 'perception/logging' 
 
