# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end



module Perception 


 module NumericI 
 
    # ------------------------------------------------------------------------------
    # @group Intelligent round: slash needless digits
    #   
    
    # Intelligent round: slash needless digits. 
    # Specify only the significant digits so that the magnitude can be easily realised.
    # Needless are digits that are
    # * beyond the measurement precision or
    # * not perceived by humans (instead they disturb the reception)    
    #
    # Example:
    #    input (+/-)     result (+)     result (-)   result.class
    #  ----------------------------------------------------------
    #       12567.89          12600         -12600         Fixnum
    #       1256.789           1260          -1260         Fixnum
    #      123.56789            124           -124         Fixnum
    #         100.01            100           -100         Fixnum
    #          100.0            100           -100         Fixnum
    #           99.9           99.9          -99.9          Float
    #           12.0             12            -12         Fixnum
    #             12             12            -12         Fixnum
    #       12.56789           12.6          -12.6          Float
    #       1.256789           1.26          -1.26          Float
    #            1.5            1.5           -1.5          Float
    #              0              0              0         Fixnum
    #      0.1256789          0.126         -0.126          Float
    #     0.01256789         0.0126        -0.0126          Float
    #    0.001256789        0.00126       -0.00126          Float
    #   0.0001256789       0.000126      -0.000126          Float
    #
    # @return [Numeric]
    # @param [Integer] precision How many digits are significant?
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

    # ------------------------------------------------------------------------------
    # @group Easily human readable numbers
    #    
    
    # Formats a number for easily human readability.
    # Example: (using +.inspect_see+ without options)
    #      input    (barrier)    output   (barrier)    note
    #  -------------------------------------------------------------------------------------------------------    
    #       -7213541 ########-7 210 000    ########   Intelligent fallback strategy if space is not sufficient
    #        7213541 ########7 210 000     ########
    #        -553337 ######## -553 000     ########
    #         553337 ########  553 000     ########   Intelligent round: slash needless digits
    #      -12567.89 ########  -12 600     ########
    #       12567.89 ########   12 600     ########   Thousands separator only if necessary
    #      -1256.789 ########    -1260     ########
    #       1256.789 ########     1260     ########
    #     -123.56789 ########     -124     ########
    #      123.56789 ########      124     ########
    #         100.01 ########      100     ########
    #           12.0 ########       12     ########
    #             12 ########       12     ########
    #      -12.56789 ########      -12.6   ########
    #       12.56789 ########       12.6   ########
    #      -1.256789 ########       -1.26  ########
    #       1.256789 ########        1.26  ########
    #     -0.1256789 ########       -0.126 ########
    #      0.1256789 ########        0.126 ########
    #    -0.01256789 ########       -0.0126########
    #     0.01256789 ########        0.0126########
    #   -0.001256789 ########      -0.00126########
    #    0.001256789 ########       0.00126########
    #  -0.0001256789 ########     -0.000126########
    #   0.0001256789 ########      0.000126######## 
    #
    # Features:
    # * aligned right with the separator as reference point
    # * you can preced a currency symbol or append units, without destroying the alignment
    # * intelligent fallback strategy if the predetermined space is not sufficient
    # * thousands separator if necessary, and only if necessary
    # * only the significant digits are specified so that the magnitude can be easily realised (see {#significant})   
    #
    # If you don't need alignment and thousands separator, use {Perception::NumericI#significant significant} instead.        
    # See {http://de.wikipedia.org/wiki/Wikipedia:Schreibweise_von_Zahlen Schreibweise von Zahlen}.
    #
    # @return [String]
    # @param [Hash] options
    # @option options [Integer] :precision how many digits are significant? Default: 3
    # @option options [Integer] :space_l space before the separator as reference point 
    # @option options [Integer] :space_r space behind the separator. Default depends on class (Integer or Float).
    # @option options [Char] :separator separator
    # @option options [Char] :delimiter  thousands separator 
    # @option options [String] :pre preceding string (e.g. a currency symbol) 
    # @option options [String] :past appended string (e.g. a unit) 
    #
    #
    def inspect_see(options={})
      precision =         options[:precision]   ||  3
      pre  =              options[:pre]         ||  ''
      past  =             options[:past]        ||  ''      
      space_l =           options[:space_l]     ||  9 + pre.size  
      space_r =           options[:space_r]     ||  (self.kind_of?(Integer) ?  (0+past.size) : (5+past.size))    # Integer oder Float?
      separator =         options[:separator]   ||  '.'
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
    
    
   
    

  end # module NumericI 
end # module Perception


class Numeric 
  include Perception::NumericI
end

# @private
class NilClass 
    def size(*a);                       0;              end  
end







# -----------------------------------------------------------------------------------------
# Ausprobieren, Tests
#
if $0 == __FILE__  &&  Drumherum::loaded? then

  # Hier einstellen, was laufen soll
  $run = :try1
  $run = :try2
  #$run = :tests
  #$run = :demo
  
  case $run 
  

  when :try1 #-------------------------------------------------------------------------------   
  
    seee.out << :log
    test = [12567.89, 1256.789, 123.56789, 100.01, 100.0, 99.9, 12.0, 12, 12.56789, 1.256789, 1.5, 0, 0.1256789,0.01256789,0.001256789,0.0001256789, ]
    test.each do |t|
    
      see_print "#"
      see_print t.to_s.rjust(15)
      see_print t.significant.to_s.rjust(15)
      see_print (t * -1).significant.to_s.rjust(15)
      see_print t.significant.class.to_s.rjust(15)      
      see_print "\n"
    end
    
    
  when :try2 #-------------------------------------------------------------------------------      
    
    seee.out << :log    
    test = [7213541, 553337, 12567.89, 1256.789, 123.56789, 100.01, 100.0, 99.9, 12.0, 12, 12.56789, 1.256789, 1.5, 0, 0.1256789,0.01256789,0.001256789,0.0001256789, ]
    test.each do |t|
      t = t*-1    
      see_print "#"
      see_print t.to_s.rjust(15) +      ' ########'     + t.to_f.inspect_see + "########\n"  
      t = t*-1
      see_print "#"      
      see_print t.to_s.rjust(15) +      ' ########'     + t.to_f.inspect_see + "########\n"  
    end    
    
    
  when :demo #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'demo', 'demo_pp' )
    Perception::DemoSee.see_all_demos   
  
    
  when :tests #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'test', 'test_numeric' )  
    
    
  else #--------------------------------------------------------------------------------------
  
    see '$run einstellen!'
    
  
  end # case
end # if




 


    
    
    
    
    
    
    
    
    
