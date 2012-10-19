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
      #seee.out << :log
      @@initialized_count += 1
      return  if (@@initialized_count == 1  &&  !announce_first)
      #seee.slow!(0.5)
      seee.left!
      #seee.indent!
      see ("\n" * 5)   if @@initialized_count > 1  
      
      if announce_first.kind_of?(String)
        see announce_first
        see '='*announce_first.size
      else
        see "Perception Demo ##{@@initialized_count}"
        see "=================="
      end
      see
      wait_for_key('Press any key to start')
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
      #wait_for_key
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
      see "You can slow down printing with seee.slow!"
      see 
      see 'This is a string'
      see 'and here we have a longer one.'
      see 'so we need even longeer strings, but they all have to be different.'
      see '#see has forgotten the first string. So I will tell him again: This is a string. and here we have a longer one. '
      see 'In slow mode #see waits for you to read the lines. More words, longer waiting.'
      see 'short prints...' 
      see '...short waiting.' 
      see 'short prints...' 
      see '...short waiting.' 
      see
      see
      string = 'This string is getting longer.' 
      (1..10).each do |i|
        see string
        string += ' But it repeats.' 
      end
      see
      see '#see only counts those words you have to read.'
      see
      see
      see 'You can choose the speed. seee.slow!(0.5) is faster: '
      
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
      see
      see '#see only counts those words you have to read.'
      see      
    end  
    
    
    
    
    # Simple benchmarking
    def demo_bench
      see 'You always get the time since last print with seee.bench.'    
      see 'You can use this for simple benchmarking:'      
      see "I'm counting to 50 000 000, please wait."
      50000000.downto(0) {}
      see "it took #{seee.bench} seconds." 

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
    def demo_alternate_see
      see ['horst.maierman','PW-AEerSDFs', 'addional', 'information', :one]
      see ['claudia.hoppe','27546522sdfgdz3s', 'addional', 'information', :two]
      see ['nadja.hirsch','Minnie', 'addional', 'information', :three]
      seee.flash! '    Bad password!     ' 
      see ['tom.flupper','Gs3Kkd2', 'addional', 'information', :five]
      see ['anna.chevrezonk','2sdtg&fH', 'addional', 'information', :six]
      see ['hardy.schwarzer','dfjhRfDdtis', 'addional', 'information', :seven]
    end    
    
    
    
    
    def self.see_all_demos
      Perception::DemoSee.new('Automatic Indenting').demo_level 
      Perception::DemoSee.new('Slowing down').demo_see_slowdown1    
      Perception::DemoSee.new('Simple Benchmarking').demo_bench   
      Perception::DemoSee.new('Progress Indicator').demo_see_temp_and_clear_last  
      Perception::DemoSee.new('Two layers of information in one line').demo_alternate_see      
    end

  
  
  end # class
end # class


if $0 == __FILE__ then

Perception::DemoSee.see_all_demos
   
end

  

    





  