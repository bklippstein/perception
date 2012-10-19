# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end


module Perception 


 module TimeI 
 
 
  # ------------------------------------------------------------------------------
  # @group Using inspect_see for to_s and pretty_print
  #     
 
 # @return [String]
 def inspect_see(options={})
    norm =              options[:norm]        || :iso
    precision_max = 4
    precision =         options[:precision]   ||  precision_max
    precision = 0               if precision < 0    
    precision = precision_max   if precision > precision_max    
    formatstring = TIME_FORMATS[norm][precision]
    self.strftime(formatstring)
 end
 
 

 # @return [String]
  def to_s
    self.inspect_see(:precision => 5)
  end  
  
  
 # @return [String]  
  def pretty_print(q)
    q.text(self.inspect_see(:precision => 5))
  end    


  end # module TimeI 
end # module Perception




class Time 
  include Perception::TimeI
end









# -----------------------------------------------------------------------------------------
#  Ausprobieren
#
if $0 == __FILE__  &&  Drumherum::loaded? then

  # Hier einstellen, was laufen soll
  $run = :try
  #$run = :tests
  #$run = :demo
  
  case $run     
    
  when :try #-------------------------------------------------------------------------------      
    
    ms = 2635200
    puts (Time.now - ms*0).inspect_see(:norm => :de, :precision => 5)
    see Time.now 
    
  when :demo #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'demo', 'demo_pp' )
    Perception::DemoSee.see_all_demos   
  
    
  when :tests #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'test', 'test_date_and_time' )
    
    
  else #--------------------------------------------------------------------------------------
  
    see '$run einstellen!'
    
  
  end # case  

    
  
  
end # if




 


    
    
    
    
    
    
    
    
    
