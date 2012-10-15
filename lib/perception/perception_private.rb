# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end




module Perception #:nodoc

  
  # Eine SeeSession-Instanz entspricht einer Session mit der Konsole.
  class SeeSession
    @@instance = nil
    attr_accessor :time_last, :delayed_newlines, :level, :indent, :out
    
    # ------------------------------------------------------------------------------
    #  Verwalten
    #    
    
    # Liefert die eine notwendige Instanz 
    def self.instance
        return @@instance   if @@instance
        @@instance = SeeSession.new
        @@instance
    end
    
    
    def initialize
      init
    end
    
    
    def init
      # früher
      @string_last        = ''                # enthält den letzten ausgegebenen String (damit man ihn löschen und wiederherstellen kann)
      @time_last          = nil               # enthält den Zeitpunkt des letzten Prints
      @method_last        = nil               # enthält die Methode, mit der der letzte String geprinted wurde      
      @call_stack_last    = 0                 # Wie lang war der Stack beim letzten #see?

      # jetzt
      @speed              = nil               # nil = unverzögert, 1= lesbar, 2 = lesbar / doppelt so schnell, 0.5 = lesbar / halb so schnell 
      @cursor_now         = 0                 # enthält die aktuelle Position des Cursors 
      @method_now         = nil               # mit welcher Methode wird der aktuelle Print ausgeführt?     
      @call_stack_now     = 0                 # Wie lang ist der Stack beim aktuellen #see? 
      @indent             = SEE_INDENT_START  # sollen die Prints automatisch eingerückt werden?
      @level              = SEE_LEVEL_START   # aktueller Einrückungslevel    
      
      # nächstes
      @delayed_newlines   = 1                 # Mit wie vielen Newline-Zeichen soll der nächste Print beginnen? (Newlines werden verzögert, damit man noch löschen kann)
      @delayed_clear      = false             # Soll der nächste Print den vorhergehenden überschreiben? 
      
      @logger             = nil               # wird erst bei Bedarf erzeugt
      @out                = Set.new           # Wohin geht der Output? , :log
      @out << :console    
    end
    

    
    
    
    
    # ------------------------------------------------------------------------------
    #  Ausgeben
    #      
    
    def wait!(string_akt)
      return unless @time_last 
      verstrichene_zeit = Time.now - @time_last   
      alter_string = @string_last.strip.chomp.scan(/\w+/)
      neuer_string = string_akt.strip.chomp.scan(/\w+/)
      differenz_information = Math.sqrt((alter_string - neuer_string).size + 0.3 )
      time_for_perception = (differenz_information * SEE_PERCEPTION_TIME_PER_WORD * @speed ) / 1000
      if verstrichene_zeit  < time_for_perception
        sleep (time_for_perception - verstrichene_zeit)
      end
      nil
    end # wait
    
    
    def adjust_level
      @call_stack_now   = caller.size 
      call_stack_diff = @call_stack_now - @call_stack_last
      # puts "call_stack_diff=#{ call_stack_diff }"
      # puts    
      if @indent 
        if    call_stack_diff > 0  &&  @call_stack_last != 0
          @level += 1 
        elsif call_stack_diff < 0  &&  @level > 1
          @level -= 1      
        end
      end  
      nil
    end
    
    
    def clear_indent!
      @call_stack_last  = 0      # wie direkt nach der Initialisierung 
      @call_stack_now   = 0       
      @level            = SEE_LEVEL_START 
      nil
    end
    


    
    
    # Gibt das see aus
    def process_print( input, options={} )
    
      # vorbereiten
      @method_now       = options[:method]  || :puts    
      self.clear!                    if @delayed_clear       
      self.adjust_level
      newlines = self.process_newline           if @delayed_newlines > 0
      
      # ausgeben
      case @method_now
      
        when :puts
          result = input.inspect_or_to_s    
          self.wait!(result)          if @speed
          printout(result)            
          @delayed_newlines += 1      # das newline wird erst später eingefügt  
          
        when :pp
          result = input.inspect_see
          self.wait!(result)          if @speed
          printout(result)    
          @delayed_newlines += 1      # und das newline später eingefügt         
      
        when :print  
          result = input.inspect_or_to_s   
          self.wait!(result)          if @speed
          printout(result)   
          
        when :multi
          result = ''
          result = PPP::pp(input, result, 200)  # normal prettyprint
          result = PPP.beautify_multi(result)  
          self.wait!(result)          if @speed
          printout(result)    
          @delayed_newlines += 1      # und das newline später eingefügt              

      end # case
        
      # verwalten
      @string_last      = result.dup  
      @time_last        = Time.now       
      @method_last      = @method_now
      @call_stack_last  = @call_stack_now
      return (newlines ||'') + result
    end # def
    
    
    # Führt die aufgeschobenen Newlines aus. Ohne Berücksichtigung der Zeit.
    def process_newline    
      result = "\n" * @delayed_newlines     
      self.clear!                    if @delayed_clear 
      printout(result)
      @delayed_newlines = 0    
      return result
    end    
    
    
    def printout(string, backward=nil)
      if @out.include?(:console)
        spacer = (' '*SEE_TAB_WIDTH * @level)
        outputstring = string.gsub(/\n/,    ("\n" + spacer)   )      
        Kernel.print(spacer)          if @cursor_now == 0      
        Kernel.print(outputstring) 
      end
      if @out.include?(:log)
        # spacer = seee.bench.inspect_see + (' '*SEE_TAB_WIDTH * @level) + '       '
        spacer = ''      
        outputstring = string.gsub(/\n/,    ("\n" + spacer)   )      
        logger << (spacer)          if @cursor_now == 0      
        logger << (outputstring)   
      end
      
      # TODO: \n berücksichtigen
      unless backward
        @cursor_now += outputstring.size 
      else
        @cursor_now -= backward  
      end
    end
    



  end # class







end # module


class Object
  
  # Liefert entweder inspect oder to_s, je nach Klassenzugehörigkeit
  # Explizite Typabfrage ohne duck typing!
  def inspect_or_to_s
    return 'empty'            if self == ''
    return self.to_s          if self.class == String
    return self.inspect_see   if self.class == Time
    return self.inspect_see   if self.kind_of?(Numeric)
    return self.inspect_see   if self.kind_of?(Set)
    return self.inspect
  end

end # class






 
 
# -----------------------------------------------------------------------------------------
#  ausprobieren
#
if $0 == __FILE__  &&  Drumherum::loaded? then
    require File.join(Drumherum::directory_main, 'demo', 'demo_pp' )
    Perception::DemoSee.see_all_demos     
end # if


  