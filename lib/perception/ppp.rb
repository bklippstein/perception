# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end


# patches pretty print
# @private
class PPP < PP


  
  

  
  # ------------------------------------------------------------------------------
  # @group Beautify: reworking the pretty print results
  #       
  
  
  # reworking the pretty print results
  # @return [String]
  #
  def self.beautify(string)
    begin
      result = string# .gsub!("`","'")
      result = beautify_focus_level1(result)
      case classify_structure(string)
        when :object      then  result = beautify_object(result)        
        when :hash        then  result = beautify_hash(result)             
        when :array_1dim  then  result = beautify_array_1dim(result)      
        when :array_2dim  then  result = beautify_array_2dim(result)    
      end  
      return result
    # rescue
      # return string
    end
  end # def
  
  
  # Classifies the structure of an object for output  
  # @return [Symbol]  
  #
  def self.classify_structure(object)
  
    # Hash
    return :hash  if object =~ /^\{.*=>.*\}/m     
    
    # Object
    return :object  if object =~ /^#<.*>$/m       
  
    # Eindimensionales Array
    # oder Objekt, das sich wie ein Array ausdruckt -- vor der eckigen Klammer ist ein Identifier erlaubt, z.B. WP[ 1, 2, 3]  
    return :array_1dim  if object =~ /^[A-Z_0-9a-z]{0,30}\[[^\[].*[^\]]\]$/m 
    
    # Zweidimensionales Array
    # Anfang prüfen: Zwei eckige Klammern auf, danach keine eckige Klammer auf
    # oder alternativ ein Text zwischen den beiden Klammern auf
    return :array_2dim  if object =~ /^\[[A-Z_0-9a-z]{0,30}\[[^\[]/m
    #return self unless object =~ /[^\]]\]\]$/   # Ende prüfen: Zwei eckige Klammern zu, davor keine eckige Klammer zu  
       
  end  
  
  
  
  # Level 2+ : only one line left
  # Level 3+ : clip complex objects
  # @return [String]  
  #
  def self.beautify_focus_level1(string) 
    #return string
    replaces = [[/\n/, ''], [/ {2,}/,' ']]
    result = string
    result = string.mask( :level_start => 2 ) { |s| s.mgsub(replaces)}
    result = result.mask( :level_start => 3 ) { |s| (s =~ /@.*=.*/ ? '' : s) } 
    return result
  end  
  
  
  
  # Beautify for Objects
  # @return [String]  
  #
  def self.beautify_object(string) 
    result = string
    result.gsub!(/= *\n */m, '=' )  # unnötigen Zeilenumbruch vermeiden
    result = result.mask( :level_start  => 1, 
                          :level_end    => 1,
                          :pattern      => /</  ) { |s| s.gsub(/=/, ' = ')} 
    replaces = [ [/ @/, '  @'], [/= #/,'=#'] ]  # Unterobjekte formatieren
    result = result.mask( :level_start  => 2, 
                          :level_end    => 2 ) { |s| s.mgsub(replaces)}    
    result = result.mask( :level_start  => 4 ) { |s| ''}    

    tabstops = result.analyze_columns(  :level_start  => 0,     
                                        :level_end    => 0,
                                        :search       => '=' )  || [25]
    tabstops2 = []
    tabstops2 << tabstops[0] 
    tabstops2 << tabstops[0] + 5

    result = result.spread( :level_start  => 1,     
                            :level_end    => 1,
                            :search       => /=[^>=]/,
                            :position_add => 1,            # alle '=' links                              
                            :tabstops     => tabstops2 )   
                        
    result
  end
  
  
  
  # Beautify for Hashes
  # @return [String]  
  #
  def self.beautify_hash(string) 
    result = string
    result.gsub!(/=> *\n */m, '=>' )  # unnötigen Zeilenumbruch vermeiden
    
    # mehrzeilige Darstellung
    if result.include?("\n")
      result = string.mask( :level_start => 1, 
                            :level_end   => 1,
                            :pattern     => /\{/ ) { |s| s.gsub(/=>/, ' =>')}
      
      # Pfeil retten    
      result = result.mask( :level_start => 2,
                            :pattern     => /\{/ ) { |s| s.gsub('=>', Perception::PPP_PFEIL)}     

      # Unterobjekte formatieren 
      replaces = [ [/, /,',  '] ]     
      result = result.mask( :level_start => 2,
                            :level_end   => 2 ) { |s| s.mgsub(replaces)}                               
      
      # Tiefere Level retten
      result = result.mask( :level_start    => 1,  
                            :with_brackets  => true,
                            :pattern        => /\{/ 
                          ) { |s| s.tr(Perception::PPP_TR_ARRAY_P[0..5], Perception::PPP_TR_ARRAY_Q)}   

      tabstops = result.analyze_columns(  :level_start  => 0,     
                                          :level_end    => 0,
                                          :search       => '='   )  || [25]
      tabstops2 = []
      tabstops2 << tabstops[0] + 1
      tabstops2 << tabstops[0] + 5
      
      # ausrichten
      result = result.spread( :level_start  => 1,     
                              :level_end    => 1,
                              :search       => /=>/,
                              :position_add => 0,      # alle '=>' übereinander  
                              :tabstops     => tabstops2 )   
      result.gsub!('=>','=>  ')

      # Tiefere Level zurück
      result = result.mask( :level_start    => 1, 
                            :with_brackets  => true,                             
                            :pattern        => /\{/  
                          ) { |s| s.tr(Perception::PPP_TR_ARRAY_Q, Perception::PPP_TR_ARRAY_R)}  

      # Pfeil zurück
      result = result.mask( :level_start => 2,
                            :pattern     => /\{/ )  { |s| s.gsub(Perception::PPP_PFEIL, '=>')}       
      
          

    # einzeilige Darstellung
    else
      result = string.mask( :level_start => 1, 
                            :level_end   => 1,
                            :pattern     => /\{/ ) { |s| s.gsub(/, /, ',  ')}
      
    end

    result
  end      
  
  
  # Beautify for one-dimensional arrays
  # or any object that prints like an array.
  # In front of the brackets there are identifier allowed, eg WP [1, 2, 3]    
  # @return [String]  
  #  
  def self.beautify_array_1dim(string) 
    return string
    # tabstops = result[1..-2].analyze_columns( :level_start  => 0,     
                                              # :level_end    => 0,
                                              # :search       => ',',
                                              # :stretch      => 0  )   
    # tabstops = [25]   if tabstops.empty?
    # maxtab = tabstops.sort[-1]    


    # result = result.spread( :level_start  => 1,     
                            # :level_end    => 1,
                            # :tabstops     => (1..10).collect {|i| i * (maxtab+1)},
                            # :search       => ',',
                            # :position_add => 1 )
  end      
  
  
  # Beautify for two-dimensional arrays -  
  # very dirty.
  # @return [String]  
  #    
  def self.beautify_array_2dim(string) 
    result = string

    # Komma retten
    result = result.mask( :level_start => 3,
                          :pattern     => /['"({<\[]/
                        ) { |s| s.tr(',', Perception::PPP_KOMMA)} 
    
    # Tiefere Level retten
    result = result.mask( :level_start    => 2,  
                          :with_brackets  => true,                           
                          :pattern        => /\[/ 
                        ) { |s| s.tr(Perception::PPP_TR_ARRAY_P, Perception::PPP_TR_ARRAY_Q)}
    
    # zeilenweise 
    replaces = [[/,[^\n]/, ", \n "]]
    result = result.mask( :level_start => 1, 
                          :level_end   => 1, 
                          :pattern     => /\[/ 
                        ) { |s| s.mgsub(replaces)}       

    # Tabstops 
    tabstops = result[1..-2].analyze_columns( :level_start  => 1,     
                                              :level_end    => 1,
                                              :search       => ',',
                                              :stretch      => 1  )   || [25]    
    tabstops2 = []   
    tabstops.each do |t|
      tabstops2 << t + (tabstops2[-1]||0)      
    end

    # ausrichten
    result = result.spread(  :level_start => 2,     
                             :level_end   => 2,
                             :tabstops    => tabstops2,
                             :search      => /,/   )      

    # Tiefere Level zurück
    result = result.mask( :level_start    => 2, 
                          :with_brackets  => true,                           
                          :pattern        => /\[/  
                        ) { |s| s.tr(Perception::PPP_TR_ARRAY_Q, Perception::PPP_TR_ARRAY_R)}    

    #Komma zurück
    result = result.mask( :level_start => 3,
                          :pattern     => /['"({<\[]/
                        ) { |s| s.gsub(Perception::PPP_KOMMA, ',')} 
    
    return result    

  end        
  
  


  # Beautify for complex objects.
  #
  # Mehrere Ausgaben in einer Zeile.
  # Die einzelnen Ausgaben liegen als Array vor.
  # Das Ergebnis soll aber nicht wie ein Array ausssehen.
  # @return [String]  
  #      
  def self.beautify_multi(string)
    result = string
    result = beautify_focus_level1(result)    
    result = result.mask(     :level_start    => 1,
                              :level_end      => 1,
                              :pattern     => /\[/                               
                        ) {|s| s.tr(',', Perception::PPP_KOMMA)}      
    result = result.spread_line( [25], Perception::PPP_KOMMA, 0 )
    
    # Äußeres Array entfernen
    result = result.tr(Perception::PPP_TR_ALL,'')
    result = result.mask(     :with_brackets  => true,
                              :level_start    => 0,
                              :level_end      => 0,
                              :pattern     => /\[/                                 
                        ) {|s| s.tr('[]','')}          
    return result
  end # def  
  
  
      
  # ------------------------------------------------------------------------------
  # @group Pretty Print Patches
  #    
  

  def self.pp(obj, out=$>, width=79 )
    q = PPP.new(out, width, "\n")
    q.guard_inspect_key {q.pp(obj)}
    q.flush
    #$pp = q
    out
  end  
  
  

  # ensures that lists with more than three elements are displayed line by line
  def seplist(list, sep=nil, iter_method=:each) # :yield: element
    sep = lambda { comma_newline }   if (sep.kind_of?(Integer)  &&  list.size > sep )
    sep = lambda { comma_breakable } if (sep.nil? || sep.kind_of?(Integer))
    first = true
    list.__send__(iter_method) {|*v|
      if first
        first = false
      else
        sep.call
      end
      yield(*v)
    }
  end
    
    
  def comma_newline
    text ","
    breakable('',9999)   
  end    

  
  
  # hashes with more than three keys are displayed line by line  
  def pp_hash(obj)
    group(1, '{', '}') {
      seplist(obj, 3, :each_pair) {|k, v|
        group {
          pp k
          text '=>'
          group(1) {
            breakable ''
            pp v
          }
        }
      }
    }
  end    
  
  

end # class

# @private
class String 

  # @return [String]
  def pretty_print(q)
    q.text "'#{self}'"
  end
  
end

# @private
class Set 

  # @return [String]
  def pretty_print(q)
    q.group(1, '{', '}') {
      q.seplist(self) {|v|
        q.pp v
      }
    }
  end

  
  def pretty_print_cycle(q)
    q.text(empty? ? '{}' : '{...}')
  end
  
end

# @private
class Dictionary 

 # @return [String]
  def inspect
    ary = []
    each {|k,v| ary << k.inspect + "=>" + v.inspect}
    '{' + ary.join(", ") + '}'
  end
end


class Dictionary 

  # @return [String]
  def pretty_print(q)
    q.pp_hash self
  end

  def pretty_print_cycle(q)
    q.text(empty? ? '{}' : '{...}')
  end
end








# -----------------------------------------------------------------------------------------
#  Ausprobieren
#
if $0 == __FILE__  &&  Drumherum::loaded? then

  # Hier einstellen, was laufen soll
  $run = :tests
  #$run = :demo
  
  case $run     
        
  when :demo #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'demo', 'demo_pp' )
    Perception::DemoSee.see_all_demos   
  
    
  when :tests #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'test', 'test_ppp' )
    
    
  else #--------------------------------------------------------------------------------------
  
    see '$run einstellen!'
    
  
  end # case  

    
  
  
end # if