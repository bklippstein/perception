# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end

# Some constant definitions
#
module Perception 

  unless defined?(TIME_FORMATS)
    TIME_FORMATS = {
    #           0             1                   2                     3                       4
      :iso => [ '%Y-%m-%d',   '%Y-%m-%d  %H:%M',  '%Y-%m-%d  %H:%M:%S', '%Y-%m-%d  %H:%M:%S',   '%Y-%m-%d %A %H:%M:%S'  ],
      :de  => [ '%d.%b.%Y',   '%d.%b.%Y  %H:%M',  '%d.%b.%Y  %H:%M:%S', '%d. %B %Y  %H:%M:%S',  '%A, %d. %B %Y  %H:%M:%S'  ]   # %e is not working
                       } 
  end
  

                  
                  
  # Shows a ruler
  unless defined? RULER
    r100= "0000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999"
    r10= "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
    RULER = r100 + r100 + "\n" + r10 + r10   
  end    


  SEE_PERCEPTION_TIME_PER_WORD = 200                                            unless defined? SEE_PERCEPTION_TIME_PER_WORD
  
  # automatic indention
  SEE_TAB_WIDTH = 2                                                             unless defined? SEE_TAB_WIDTH
  SEE_LEVEL_START = 1                                                           unless defined? SEE_LEVEL_START
  SEE_INDENT_START = false                                                      unless defined? SEE_INDENT_START


  # nicht verwenden: 07..13, 27
  PPP_KOMMA =                1.chr    unless defined? PPP_KOMMA      
  PPP_SEARCH =               2.chr    unless defined? PPP_SEARCH      
  PPP_GESCHW_KLAMMER_AUF =   3.chr    unless defined? PPP_GESCHW_KLAMMER_AUF 
  PPP_GESCHW_KLAMMER_ZU =    4.chr    unless defined? PPP_GESCHW_KLAMMER_ZU  
  PPP_ECKIGE_KLAMMER_AUF =   5.chr    unless defined? PPP_ECKIGE_KLAMMER_AUF  
  PPP_ECKIGE_KLAMMER_ZU =    6.chr    unless defined? PPP_ECKIGE_KLAMMER_ZU   
  PPP_SPITZE_KLAMMER_AUF =  14.chr    unless defined? PPP_SPITZE_KLAMMER_AUF 
  PPP_SPITZE_KLAMMER_ZU =   15.chr    unless defined? PPP_SPITZE_KLAMMER_ZU    
  PPP_PFEIL =        16.chr+16.chr    unless defined? PPP_PFEIL     
  PPP_TUDDELCHEN1 =         17.chr    unless defined? PPP_TUDDELCHEN1     
  PPP_TUDDELCHEN2 =         18.chr    unless defined? PPP_TUDDELCHEN2     
  PPP_ANTI_NEWLINE =        31.chr    unless defined? PPP_ANTI_NEWLINE        
  
         
  
  
  # codieren:     P => Q, in P fehlen derzeit die spitzen Klammern, weil sonst Hash nicht funktioniert
  # decodieren:   Q => R    
  PPP_TR_ARRAY_P = %q{'"{}[]<>}                                                             unless defined? PPP_TR_ARRAY_P 
  unless defined? PPP_TR_ARRAY_Q
    PPP_TR_ARRAY_Q =  PPP_TUDDELCHEN1 + PPP_TUDDELCHEN2 +
                      PPP_GESCHW_KLAMMER_AUF + PPP_GESCHW_KLAMMER_ZU +  
                      PPP_ECKIGE_KLAMMER_AUF + PPP_ECKIGE_KLAMMER_ZU + 
                      PPP_SPITZE_KLAMMER_AUF + PPP_SPITZE_KLAMMER_ZU   
  end
  PPP_TR_ARRAY_R =  %q{'"{}[]<>}                                                             unless defined? PPP_TR_ARRAY_R   
  
  PPP_TR_ALL = PPP_TR_ARRAY_Q + PPP_KOMMA + PPP_ANTI_NEWLINE                                 unless defined? PPP_TR_ALL  
  

  
                   
end # module



# -----------------------------------------------------------------------------------------
#  Ausprobieren
#
if $0 == __FILE__  &&  Drumherum::loaded? then

  # Hier einstellen, was laufen soll
  #$run = :tests
  $run = :demo
  
  case $run     
    
    
  when :demo #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'demo', 'demo_pp' )
    Perception::DemoSee.see_all_demos   
  
    
  when :tests #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'test', '_start_all' )
    
    
  else #--------------------------------------------------------------------------------------
  
    see '$run einstellen!'
    
  
  end # case  

    
  
  
end # if