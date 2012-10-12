# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'kyanite/smart_load_path'
  smart_load_path   
  require 'perception'
end


module Perception #:nodoc
 module TimeI 
 

 def inspect_see(options={})
    norm =              options[:norm]        || :iso
    precision_max = 4
    precision =         options[:precision]   ||  precision_max
    precision = 0               if precision < 0    
    precision = precision_max   if precision > precision_max    
    formatstring = TIME_FORMATS[norm][precision]
    self.strftime(formatstring)
 end
 
 


  def to_s
    self.inspect_see(:precision => 5)
  end  
  
  
  def pretty_print(q)
    q.text(self.inspect_see(:precision => 5))
  end    


  end # module TimeI 
end # module Perception




class Time #:nodoc:
  include Perception::TimeI
end









# -----------------------------------------------------------------------------------------
#  Tests
#
if $0 == __FILE__ then

  # ms = 2635200
  # puts (Time.now - ms*0).inspect_see(:norm => :de, :precision => 5)
  # see Time.now
 
  require File.join(File.dirname(__FILE__), '..', '..', 'test', 'test_date_and_time' )     
  
  
end # if




 


    
    
    
    
    
    
    
    
    
