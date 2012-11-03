# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end

require 'kyanite/array'
require 'kyanite/enumerable/structure'   # Methode contentclass

# Get auto-intended output on your console without any configuration,
# temporary prints, printing two items in one line without destroying the structure. 
# Optionally slows down printing to readable speed, depending on the complexity of the output.



  

# = Perception: Human perceptible printouts
#
# Welcome to Perception. It's a intuitive toolkit for simple everyday debugging. 
# Perception offers a powerfull replacement for print, puts and pp 
# and is an alternative to {https://github.com/michaeldv/awesome_print Awesome Print}.
#
# You get auto-intended and structured output on your console without any configuration.
#
# Perception also offers temporary printouts (overwritten by the next print),
# printing two informations in one line without destroying the structure and
# optionally slows down printing to readable speed, depending on the complexity of the output.
#
module Perception 
  
  # An instance of SeeSession corresponds to a session with the console.
  class SeeSession  
  
    # @group Automatic Indenting
    
    # Turns automatic indention ON. 
    # @return void
    def indent!
      @indent           = true
      @level            = SEE_LEVEL_START
      @call_stack_last  = 0
      @call_stack_now   = 0 
      nil      
    end
    
    
    # Turns automatic indention OFF.  
    # @return void
    def left!
      @indent           = false
      @level            = SEE_LEVEL_START
      @call_stack_last  = 0
      @call_stack_now   = 0 
      nil
    end    
    
    # @group Slowing down

    # Slows down output to readable speed. 
    # The speed depends on the length and the complexity of the printing.
    # You can adjust the speed with the parameter:
    # * slow! 1    -->  same as slow!
    # * slow! 2    -->  slow, but double speed
    # * slow! 0.5  -->  even slower 
    # * slow! nil  -->  full speed (same as fast!)
    # @return void
    # @param [Float] speed 
    def slow!(speed=1)
      @speed = speed  
      nil
    end  

    
    # Adjusts printing speed to full speed.
    # This is used after slow!
    # @return void    
    def fast!
      @speed = nil 
      nil
    end      

    # @group Simple Benchmarking    
    
    # @return [Float] the time in seconds since the last printout with see.
    def bench
      return 0 unless @time_last
      return (Time.now - @time_last)   
    end    
    
    
    # @group Progress Indicator   
    
    # Undos the last print. 
    # Note: Indention will get lost.
    # @return void      
    def clear!     
      return if @cursor_now <= SEE_TAB_WIDTH * @level    
      return if @string_last.empty?
      return unless @out.include?(:console)
      self.wait!('')                   if @speed
      printout(  ("\b" * @string_last.size) + (" " * @string_last.size) + ("\b" * @string_last.size),     @string_last.size  )
      @string_last      = ''  
      @method_last      = nil      
      @time_last        = Time.now         
      @delayed_newlines = 0   
      @delayed_clear    = false  
      nil
    end  
    
    
    # Marks the last print as temporary.
    # The following print will overwrite it. 
    # Note: Indention will get lost.  
    # @return void  
    def temp! 
      @delayed_clear = true   
      nil
    end        
  
    
    # @group Two layers of information in one line       

    # Shows two informations in one line. See the demo.
    #
    # Via seee.flash! können zwei Informationen abwechselnd in der gleichen Zeile angezeigt werden.
    # Das ist nützlich, wenn man bestimmte Werte anzeigen will ohne das Gesamtlayout zu zerstören.
    # 
    # Ohne Angabe eines Zweittextes wird der Ersttext einfach zum Blinken gebracht. Nachträglich, also wenn er schon ausgegeben ist.
    # Das ist sehr nützlich, wenn man bestimme Werte verfolgen will.  
    #
    # @return void      
    def flash!(alternativtext=' ', how_many=6)
      string_bak = @string_last.dup
      method_bak = @method_last    
      method_bak = :puts         if method_bak == :pp
      speed_bak = @speed
      if speed_bak
        seee.slow!(speed_bak * 0.8)
      else
        seee.slow!
      end
      how_many.times do 
        seee.clear!
        seee.temp!
        process_print( alternativtext,  {:method => :print          } )
        seee.clear!
        process_print( string_bak, {:method => method_bak } )         
      end
      @speed = speed_bak 
      return alternativtext
    end # def
    

  end # class
end # module





class Object

# ------------------------------------------------------------------------------
#  Wrapper for SeeSession
#  
  
  # @group Main methods  
  
  # Returns the SeeSession-Object. Offers the following methods: 
  # * seee.indent!
  # * seee.left!
  # * seee.clear!
  # * seee.slow!
  # * seee.fast!
  # * seee.temp!
  # * seee.flash!
  # * seee.bench
  #
  # @return [Perception::SeeSession]
  def seee
    return Perception::SeeSession.instance
  end  
  


  
  # You get auto-intended and structured output on your console without any configuration. 
  # Usage:
  #   require 'perception'
  # and use +see+ instead of +pp+, +puts+, +print+ and +.inspect+.
  #
  # This is the printout for a nested hash as example:
  #  {:hash        =>  true,
  #   :init        =>  true,
  #   :nil         =>  nil,
  #   :symbol      =>  :symbol,
  #   :text        =>  'text',
  #   :array       =>  [1,  2,  3],
  #   :integer     =>  1,
  #   :string      =>  'hallo',
  #   :nochn_hash  =>  {:key=>:value,  :bla=>:blubb,  :array=>[:a, :b, :c],  :another_key=>'another value'}}  
  #
  # See more examples at {file:demo/Example_Output_1.rb} and {file:demo/Example_Output_2.rb} 
  # or watch the interactive demo at {file:demo/demo3.rb}.
  #
  # @return [String]
  def see(input=:kein_input, *rest)

    if input == :kein_input  
      seee.process_print( "\n", :method => :puts )
      return ''
    end        
    
    return seee.process_print( ( [input] + rest), :method => :multi )    unless rest.empty?
    return see_puts(input)              if input.class == String
    return see_pp(input)                if input.class == Hash
    return see_puts(input)              unless (input.respond_to?(:compact)  ||  input.instance_variables )   # Ordinäre Objekte macht puts
    return see_pp(input)        # Den Rest macht pp    
                            
  end # def
  
  
  # @private
  def see_each(input)
    if self.contentclass == Array
      see_puts '['
      input.each {|elt| see elt} 
      see_puts']'
    end
    input.each {|elt| see elt}     
  end
  
    # @group Several variants of see

  # Like see, but temporary print. 
  # The following print will overwrite it. 
  # Note: Indention will get lost. 
  # @return [String]
  def see_temp(input=:kein_input)
    if input == :kein_input  
      seee.delayed_newlines += 1   
      return ''
    end          
    see_print input
    seee.temp!
  end
  
  
  # Shows two informations in one line. See the demo.
  # @return [String]  
  def see_flash(input=:kein_input, alternativtext=' ', times=6)
    if input == :kein_input  
      seee.delayed_newlines += 1   
      return ''
    end        
    see_puts input
    seee.flash!(alternativtext,times)   if input != :kein_input     
  end
  
  
  # Like see, but forces behavior like the originally puts method. 
  # So you get a newline after every print.
  # Note: All newlines are delayed. This offers you to undo the print.   
  # @return [String]
  def see_puts(input=:kein_input)
    if input == :kein_input  
      seee.delayed_newlines += 1   
      return ''
    end   
    seee.process_print( input, :method => :puts )
  end    

  
  # Like see, but forces behavior like the originally print method.  
  # So you have fully control over your newlines. 
  # Note: If you use "\n", #see will indent it. See SEE_LEVEL_START.
  # @return [String]  
  def see_print(input=$_)
    return seee.process_print( input, :method => :print )
  end
  
  
  # Like see, but behavior similar to the originally pp method.   
  # @return [String]  
  def see_pp(input=:kein_input)
    if input == :kein_input  
      seee.delayed_newlines += 1   
      return ''
    end   
    return seee.process_print( input, :method => :pp )
  end    
  
  

  # @endgroup 
  
  

  # Waits for you / the user to press a key.
  # Returns the key.
  # Display it with #{wait_for_key.chr.inspect}.
  # Note: Indention will get lost.   
  def wait_for_key(message='Press any key')
    seee.clear_indent!
    #seee.level -= 1 # Zählt nicht als Level
    see_temp message
    unless defined?(HighLine)
      require 'highline/import'
      HighLine.send(:public, :get_character)
    end
    input = HighLine.new
    return input.get_character  
  end
  
 
  # Like inspect, but uses the PrettyPrint library. 
  # Returns the output of pp as String.    
  def inspect_pp( wrap = 200 )
    result = ''
    return PPP::pp(self, result, wrap) 
  end   
  
  
  # inspect_pp with beautification 
  def inspect_see( wrap = 200 )
    result = ''
    result = PPP::pp(self, result, wrap)  # normal prettyprint
    result = PPP.beautify(result)
    return result
  end       
   
  
    
  
  
  # 
  # def ljust(width)
    # try_inspect = self.inspect
  # end
  

end # class









 
# -----------------------------------------------------------------------------------------
#  ausprobieren
# 
if $0 == __FILE__  &&  Drumherum::loaded? then
    require File.join(Drumherum::directory_main, 'demo', 'demo_pp' )
    Perception::DemoSee.see_all_demos     
end # if









  