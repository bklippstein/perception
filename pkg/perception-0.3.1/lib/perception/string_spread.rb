# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'kyanite/smart_load_path'
  smart_load_path   
  require 'perception'
end
require 'kyanite/array_of_enumerables'


module Perception #:nodoc
  module StringSpreadI #:nodoc
  

  def analyze_columns(options={})
  
    # vorbereiten
    stretch =       options[:stretch]       || 1    # soviel wird zu jedem Tabstop hinzuaddiert  
  
    # mehrzeilige Darstellung
    if self.include?("\n")  
      result = ArrayOfEnumerables.new
      self.split("\n").each do |zeile|
        # print zeile.inspect_pp
        # print zeile.analyze_columns(options).inspect_pp
        # print "\n"
        result << zeile.analyze_columns(options)
      end
      result.compact!
      result = result.rectangle 
      result.transpose!
      #pp result
      result2 = result.collect { |spalte| (spalte.sort[-1]) + stretch}
      #pp result2
      return result2
     
    
    
    # einzeilig   -- TODO: Fehler beheben
    else

      # weiter vorbereiten
      level_start =   options[:level_start]   || 1
      level_end =     options[:level_end]     || 1
      search =        options[:search]        || ','

      # funktioniert nicht 100%ig. Fehler bei einem mehrzeiligen Hash, dessen Values Gleichheitszeichen enthalten.
      # Hier verhindert wahrscheinlich die erste Zeile die Maskierung des Gleichheitszeichens -- sie enthält die {-Klammer.       
      result = self.mask(   :level_start => level_start,
                            :level_end   => level_end                     
                          ) {|s| s.tr(search, Perception::PPP_SEARCH)}     
      #pp result.split(Perception::PPP_SEARCH)
      
      result = result.split(Perception::PPP_SEARCH).collect {|e| e.strip.size + stretch}    
      return result     if result.size > 1
      return nil
      
    end # if Rekursion
  end # def    
  
  
  
  # Erzwingt ein bestimmtes Zeichen nur an Tabstop-Positionen
  # Mit position_add= 0 werden die Spaces vor dem gefundenen Zeichen eingefügt.
  # Standard ist position_add= search.size, damit werden die Spaces hinter den gefundenen Zeichen eingefügt.    
  # Mit PPP_ANTI_NEWLINE werden Zeilen markiert, bei denen anschließend noch das \n entfernt werden kann.
  def spread_line(tabstops=[], search=/,/, position_add=nil, start=0)
    #puts "spread_line, self=#{self.inspect_pp} tabstops=#{tabstops.join('-')}"
    position_add = search.inspect.size-2       unless position_add
    leading_spaces = self.size - self.lstrip.size
    
    
    # das auszurichtende Zeichen finden
    pos_found = self.index(search, start) 
    return self if pos_found.nil?
    anti_newline = (self[pos_found+position_add..-1].strip == '' ?  PPP_ANTI_NEWLINE  :  '')

    
    # Tabstops bestimmen: Modus feste Tabstops  
    if tabstops.size > 1                    
      pos_shift = 0    
      tabstops.each do |ts|
        if ts >= pos_found
          pos_shift = ts        + leading_spaces
          break
        end
      end # do     
    end # modus
    
    # Tabstops bestimmen: Modus "Tabstop alle n Zeichen"  bzw. Fallback, wenn feste Tabstops nicht ausreichend waren
    if (tabstops.size == 1  ||  pos_shift == 0  )
      pos_shift = ((pos_found/tabstops[0]) + 1) * tabstops[0]   + leading_spaces
    end # if modus
    
    # Tabstops einfügen
    if pos_found < pos_shift
      self.insert(pos_found+position_add, (' '*(pos_shift - pos_found - 1)) + anti_newline )
    end
    spread_line(tabstops, search, position_add, pos_shift + 1)  
  end # def   
  
  
  
  def spread(options={})
    # vorbereiten
    level_start =   options[:level_start]   || 1
    level_end =     options[:level_end]     || 1
    search =        options[:search]        || '='
    tabstops =      options[:tabstops]    
    position_add =  options[:position_add]   # Mit position_add= 0 werden die Spaces vor dem gefundenen Zeichen eingefügt.
                                             # Standard ist position_add= search.size, damit werden die Spaces hinter den gefundenen Zeichen eingefügt.    
    return self       if tabstops.empty?  

    # Spalte ausrichten
    self.mask( :level_start => level_start,
               :level_end   => level_end
           #    :with_brackets => true  
               ) { |s|     
      s_neu = s.split("\n").collect do | zeile | 
        zeile.spread_line(tabstops, search, position_add)
      end.join("\n")
      replaces = [[/\x1F\n */ ,''],[/\x1F */ ,' ']]  # PPP_ANTI_NEWLINE = 31.chr
      s_neu.mgsub(replaces)
    } # mask    
  end # def  

 

  end # module
end # module

class String #:nodoc:
  include Perception::StringSpreadI
end





# -----------------------------------------------------------------------------------------
#  ausprobieren
#
if $0 == __FILE__ then

  # require File.join(File.dirname(__FILE__), '..', '..', 'demo', 'demo_pp' )    
  # Perception::DemoSee.see_all_demos     
  
  require 'rbconfig'
  require 'facets/to_hash'


  include Config
  see CONFIG.to_a[0..-1].to_h  
  #see CONFIG.to_a[1..5].to_h  

end # if




