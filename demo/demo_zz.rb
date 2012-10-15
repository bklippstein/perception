# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end
 
 
module Perception #:nodoc

  class DemoSee
    @@initialized_count = 0
  
    def initialize( announce_first=true )
      @@initialized_count += 1
      return  if (@@initialized_count == 1  &&  !announce_first)
      seee.fast!
      #seee.left!
      seee.indent!
      see ("\n" * 5)   if @@initialized_count > 1  
      see "Perception Demo ##{@@initialized_count}"
      see "=================="
      see
      wait_for_key('Press any key to start')
    end # def
  
  
  
    # Printing basic types
    def demo_see_basic_types
      see '1dim Arrays:'
      see a=['this','is','an','array','1']
      see b=['this','is','another','array','2']
      see c=['and','this','is','another', :tree]
      see d=['complex array', [1,2,3], {:key => :value, :love => :baby}, 4.0, :four]
      see d=['next','is','two','blank', 'lines']
      see
      see
      see '2dim Arrays'
      see [a,b,c,d]
      see
      see
      see 'Other Objects:'
      see []      
      see 'ordinary string (without "")'
      see '(next one is empty)'
      see ''
      see 1        
      see 2      
      see 3.0        
      see nil
      see true
      see false
      see :a_symbol
      see({:key => :value, :love => :baby})
      see ['complex array', [1,2,3], {:key => :value, :love => :baby}, 3.0 , '']
    end # def
    
    
    def demo_level
      seee.slow!
      see "The printout is automaticaly indented. This is the printout of a nested structure of #see's:"
      see
      see
      seee.indent!
      sub_demo_level
      see
      see      
      wait_for_key
      see 'You can force left printout with seee.left!. Reactivate indention with seee.indent!.'
      seee.left!
      see
      see
      sub_demo_level
    end
    
    
    def sub_demo_level
      see "Hello world. This is level zero. "
      (1..1).each do 
      see "This is the beginning of level one."
        1.downto(1) do 
        see "This is the beginning of level two."
          1.upto(1) do 
          see "This is the beginning of level three."
            1.times do 
            see "This is the beginning of level four." 
            see "This is the end of level four." 
            end    
          see "This is the end of level three."        
          end  
        see "This is the end of level two."        
        end 
      see "This is the end of level one."      
      end
      see "This is level zero again. Bye. "      
    end # def    
    
    
    
    
    
    
    # slow printing
    def demo_see_slowdown1
      seee.slow!
      see 'This is a string'
      see 'and here we have a longer one.'
      see 'so we need even longeer strings, but they all have to be different.'
      see '#see has forgotten the first string. So I will tell him again: This is a string. and here we have a longer one. '
      see 'In slow mode #see waits for you to read the lines. More words, longer waiting.'
      see 'short prints...' 
      see '...short waiting.' 
      see 'short prints...' 
      see '...short waiting.' 
      string = 'This string is getting longer.' 
      (1..10).each do |i|
        see string
        string += ' But it repeats.' 
      end
      see '#see only counts those words you have to read.'
      see 'You can choose the speed. This is faster:'
      
      wait_for_key
      see
      seee.slow!(0.5)
      see 'This is a string'
      see 'and here we have a longer one.'
      see 'so we need even longeer strings, but they all have to be different.'
      see '#see has forgotten the first string. So I will tell him again: This is a string. and here we have a longer one. '
      see 'In slow mode #see waits for you to read the lines. More words, longer waiting.'
      see 'short prints...' 
      see '...short waiting.' 
      see '...short waiting.' 
      string = 'This string is getting longer.' 
      (1..10).each do |i|
        see string
        string += ' But it repeats.' 
      end
      see '#see only counts those words you have to read.'
      see      
    end  
    
    
    def demo_see_slowdown2
      seee.slow!
      (1..8).each do |i|
        see "#{i} see this "
      end
     (1..8).each do |i|
        see "#{i} see that "
        sleep 0.05
      end  
      see 'The speed was always the same, but each "see that" took double the time.'
      see '#see knows the time since last print.'
      see 'You can use this for simple benchmarking:'
    end    
    
    
    # Simple benchmarking
    def demo_bench
      see "I'm counting to 10 000 000, please wait."
      10000000.downto(0) {}
      see "it took #{seee.bench} seconds." 
      see 'You always get the time since last print with seee.bench.'
    end    
    
    
    # temporary printing
    def demo_see_temp_and_clear_last
      seee.slow!
      see_print "countdown: "
      10.downto(0) do |i|
        see_temp i
      end 
      see 'finished!'
      sleep 1
      seee.clear!
      see 'You can clear the last print with seee.clear!'      
      see 'And you can print temporary informations with see_temp'      
    end
    
    
    # print two informations on one line
    def demo_see_flash1
      seee.fast!
      (1..1000).each do |i|
        see "I am line number #{i}. Waiting for line number 327."
        seee.flash! if i == 327
      end    
      see 'You can make the last printout blink with seee.flash!'
    end    
    
    
    # print two informations on one line
    def demo_alternate_see
      see ['this','is','an','array',:one]
      see ['this','is','an','array',:two]
      see ['this','is','an','array',:three]
      see ['this', [1,2,3], {:wEDSG => :DZHe5D, :DShg => :DGStdf}, 4.0, :four]
      seee.flash! '    Hoops!!     ' 
      see ['this','is','an','array',:five]
      see ['this','is','an','array',:six]
      see ['this','is','an','array',:seven]
    end    
    
    
    def demo_flash_puts    
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Important'
      seee.flash!
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '
      see 'Bla Bla '    
    end
    
    
    def demo_flash_pp     
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Important '
      seee.flash!
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '  
      see_pp 'Bla Bla '     
    end    
    
    
    def demo_flash_print      
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Important '
      seee.flash!      
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '  
      see_print 'Bla Bla '      
    end       
    

    def demo_noinput
      method = :see
      seee.slow!
      Object.send(method, 'Hallo')
      Object.send(method)
      Object.send(method, 'Welt')
      Object.send(method)
      Object.send(method, 'Double')
      Object.send(method)
      Object.send(method)
      Object.send(method, 'Space')  
      Object.send(method)
      Object.send(method)
      Object.send(method, 'Blubb')
      Object.send(method) 
      Object.send(method) 
      Object.send(method, 'Blubb!!')      
    end
    
    
    
    
    def self.see_all_demos
      Perception::DemoSee.new.demo_see_basic_types  
      Perception::DemoSee.new.demo_level 
      Perception::DemoSee.new.demo_see_slowdown1    
      Perception::DemoSee.new.demo_see_slowdown2 
      Perception::DemoSee.new.demo_bench   
      Perception::DemoSee.new.demo_see_temp_and_clear_last  
      Perception::DemoSee.new.demo_see_flash1  
      Perception::DemoSee.new.demo_alternate_see    
      
      Perception::DemoSee.new.demo_flash_puts     
      Perception::DemoSee.new.demo_flash_pp     
      Perception::DemoSee.new.demo_flash_print       
      Perception::DemoSee.new.demo_noinput     
    end

  
  
  end # class
end # class


if $0 == __FILE__ then

Perception::DemoSee.see_all_demos
   
end

  

    





  