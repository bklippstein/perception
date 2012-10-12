# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'kyanite/smart_load_path'
  smart_load_path   
  require 'perception'
end



module Perception #:nodoc

 module NumericI 

    
    # Formatiert eine Zahl so, dass sie leicht menschenlesbar wird: 
    # - Quasi-rechtsbündig (mit dem Komma als Bezugspunkt, abhängig von der Klassenzugehörigkeit der Zahl)
    # - vorangestellte Währungszeichen oder angefügte Einheiten, ohne die Bündigkeit zu zerstören    
    # - intelligente Ausweichstrategie, wenn der vorgegebene Platz nicht ausreicht
    # - nur die signifikanten Stellen werden angegeben, damit die Größenordnung leicht erfasst werden kann
    # - Tausendertrennzeichen wenn nötig
    #
    # Optionen sind:
    # * :precision   Wieviel signifikante Stellen sollen ausgegeben werden? Default: 3
    # * :space_l     Wieviel Platz wird vor dem Komma eingeplant? 
    # * :space_r     wie :space, bezieht sich aber nur auf den Nachkommateil. Wird abhängig davon vorbelegt, ob self Integer oder Float ist.
    # * :separator   Kommazeichen 
    # * :delimiter   Tausendertrennzeichen
    # * :pre         wird direkt vor der Zahl ausgegeben  (z.B. €)
    # * :past        wird direkt nach der Zahl ausgegeben (z.B. %)      
    #
    # Für eine schlichte linksbündige Ausgabe reicht die Methode #significant!               
    # vgl. http://de.wikipedia.org/wiki/Wikipedia:Schreibweise_von_Zahlen
    #
    def inspect_see(options={})
      precision =         options[:precision]   ||  3
      pre  =              options[:pre]         ||  ''
      past  =             options[:past]        ||  ''      
      space_l =           options[:space_l]     ||  9 + pre.size  
      space_r =           options[:space_r]     ||  (self.kind_of?(Integer) ?  (0+past.size) : (5+past.size))    # Integer oder Float?
      separator =         options[:separator]   ||  ','
      delimiter  =        options[:delimiter]   ||  ' '

      
      # auf die signifikanten Stellen reduzieren und aufteilen
      zusammengestrichen = self.significant(precision)
      zahlenteile = zusammengestrichen.to_s.split('.')
      
      # Tausendertrennzeichen und Pre
      zahlenteile[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")    if self.abs >= 10000
      zahlenteile[0] = pre + zahlenteile[0]                                 unless pre.empty?
      
      # übereinanderstehende Formatierung 
      result = zahlenteile[0].rjust(space_l) 
      if zahlenteile[1]
        
        result += (separator + zahlenteile[1] + past).ljust( space_r )
        #result += separator + (zahlenteile[1]).ljust( space_r-1 )
      else      
        result += past + (' ' * (space_r-past.size)) 
      end
      
      # zu großen Platzbedarf korrigieren
      if result.size >= space_l+space_r+1
        if (space_l - zahlenteile[0].size) < ((space_r-1) - zahlenteile[1].size)
          return result.strip.ljust(space_l+space_r)#.gsub(/ /,'_')  # linksbündig ausgeben
        else
          return result.strip.rjust(space_l+space_r)#.gsub(/ /,'_')  # rechtsbündig ausgeben 
        end
        
      # Platz reicht aus  
      else
        return result#.gsub(/ /,'_')
      end
       
    end
    
    
    # Streicht überflüssige Stellen weg.
    # Wandelt in Integer um, wenn das ohne Informationsverlust möglich ist.
    # Überflüssig sind Stellen, die 
    # * jenseits der Messprecision liegen oder
    # * nicht von Menschen wahrgenommen werden (stattdessen stören sie die Rezeption)
    # 
    def significant( precision = 3)
    
        # sprintf mit gemischter Schreibweise
        fucking_c_lib_result = sprintf("%.#{precision}g", self)
        fucking_c_lib_result =~ /^(.*)e/
        meine_zahl = $+ || fucking_c_lib_result            
        exponent = $'
        # pp meine_zahl
        # pp exponent
        
        #  ohne Exponent
        if exponent.nil?
          result = meine_zahl.to_f
          if result.abs >= (10**(precision-1))  ||  result == result.to_i
            return result.to_i
          else
            return result
          end          
         
        # mit Exponent
        else
     
          result = meine_zahl.to_f * 10**(exponent.to_i)
          if exponent[0..0] == '+' 
            return result.to_i
          
          else
            return result

          end
        
        end # Expontent?
    end # def significant      
    

  end # module NumericI 
end # module Perception


class Numeric #:nodoc:
  include Perception::NumericI
end

class NilClass #:nodoc:
    def size(*a);                       0;              end  
end







# -----------------------------------------------------------------------------------------
# Ausprobieren, Tests
#


if $0 == __FILE__ then

  # Hier einstellen, was laufen soll
  $run = :inspect_see
  $run = :significant
  #$run = :tests
  
  case $run 
  

  when :significant #------------------------------------------------------------------------
  
    test = [12567.89, 1256.789, 123.56789, 100.01, 100.0, 99.9, 12.0, 12, 12.56789, 1.256789, 1.5, 0, 0.1256789,0.01256789,0.001256789,0.0001256789, ]
    test.each do |t|
      see_print t.to_s.rjust(15)
      see_print t.significant.to_s.rjust(15)
      see_print (t * -1).significant.to_s.rjust(15)
      see_print "\n"
    end
    
    
  when :inspect_see #------------------------------------------------------------------------    
    
    test = [7213541, 553337, 12567.89, 1256.789, 123.56789, 100.01, 100.0, 99.9, 12.0, 12, 12.56789, 1.256789, 1.5, 0, 0.1256789,0.01256789,0.001256789,0.0001256789, ]
    test.each do |t|
      t = t*-1    
      see_print t.to_s.rjust(15) +      ' ########'     + t.to_f.inspect_see + "########\n"  
      t = t*-1
      see_print t.to_s.rjust(15) +      ' ########'     + t.to_f.inspect_see + "########\n"  
    end    
    
  when :tests #------------------------------------------------------------------------------     
  
    require File.join(File.dirname(__FILE__), '..', '..', 'test', 'test_numeric' )     
    
    
  else #--------------------------------------------------------------------------------------
  
    see '$run einstellen!'
    
  
  end # case
end # if




 


    
    
    
    
    
    
    
    
    
