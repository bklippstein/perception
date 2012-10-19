# ruby encoding: utf-8
# 
# This generates Example_Output_1.
# --------------------------------
#
#
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end


module Perception #:nodoc

  class DemoSee
    @@initialized_count = 0
  
    def initialize( announce_first=true )
      seee.out << :log
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
      # wait_for_key('Press any key to start')
      
      
    end # defü
  
  
  
    # Printing basic types
    def demo_see_basic_types
      see '1dim Arrays are printed verticaly, if their size is not too big:'
      see
      seee.left!
      see a=['this','is','an','array','1']
      see b=['this','is','another','array','2']
      see d=['complex array', [1,2,3], {:key => :value, :love => :baby}, 4.0, :four]
      see []        
      see
      see 'Other Objects:'
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
 
    end # def
    
    
    def demo_see_pp_object
      see 'Nested objects reveal their structure. Lower hierary levels may be reduced for this:'
      see    
      seee.logger
      see seee
      see
      see 'The Logger has been reduced. This is it''s detail view:'
      see
      see seee.logger
      see
      see
      see 'PrettyPrint shows all at one, but it''s very hard to read:' 
      see
      pp seee
    end
    
    
    
    def demo_see_pp_array  
      see '2dim Arrays are printed like a table:'
      see      
      @array1 = []
      @array1 << ['this','is','an','array','1']
      @array1 << ['this','is','another','array','2']
      @array1 << ['and','this','is','another', :tree]
      @array1 << ['no',{:key => :value},'just','another', 'array']
      see @array1
      see    
      see          
      @text1 = 'long_longlong_long_long'
      @text2 = 'also_long, also_long, also_long_also'
      @text3 = 'hallo'
      @array2 = []
      @array2 << %W{one a b c}
      @array2 << ['two', @text1, @text2, @text3]
      @array2 << ['three', @text2, @text2, @text1]
      see @array2
    end    

    
    def demo_see_pp_hash  
      see({:this => :hash, :in => :one, :see => 'short hash in one line'})
      see
      see       
      see({:this => :hash, :size => '> 3', :see => 'longer hash in multiple lines', :another_key => 'another value'})         
      see
      see       
      @hash = { :hash => true,
                :init => true,
                :nil  => nil,
                :symbol => :symbol,
                :text => 'text',
                :array => [1,2,3],
                :integer => 1,
                :string => 'hallo',
                :nochn_hash => {:key => :value, :bla => :blubb, :array => [:a,:b,:c], :another_key => 'another value'}
               }
      see @hash  
    end   


    def demo_see_pp_dictionary
      require 'hashery' # old: 'facets/dictionary'
        
      @dictionary = Dictionary.new  
      @dictionary[:a_dictionary] =    true
      @dictionary[:b_init] =          true
      @dictionary[:c_symbol] =        :symbol
      @dictionary[:d_array] =         [1,2,3]
      @dictionary[:e_integer] =       1
      @dictionary[:f_string] =        'hallo'
        @subdictionary = Dictionary.new    
        @subdictionary[:a] =  :value
        @subdictionary[:b] =  'blubb'
        @subdictionary[:c] =  2
        @subdictionary[:d] =  [:a,:b,:c]
        @subdictionary[:e] =  { :key => :value}
        @subdictionary[:f] =  'hallo'  
      @dictionary[:g_subdictionary] = @subdictionary  
      see @dictionary       
    end
    
    
    def self.see_all_demos
      Perception::DemoSee.new('Basic Types').demo_see_basic_types      
      Perception::DemoSee.new('2dimensional Arrays').demo_see_pp_array     
      Perception::DemoSee.new('Nested Objects').demo_see_pp_object  
      Perception::DemoSee.new('Hash').demo_see_pp_hash       
      Perception::DemoSee.new('Dictionary').demo_see_pp_dictionary      

      

 
    end

  
  
  end # class
end # class


if $0 == __FILE__ then

# seee.out << :log
Perception::DemoSee.see_all_demos

   
end

  

    





  