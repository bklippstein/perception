# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init 
end
require 'drumherum/unit_test'
require 'perception'


class TestPerceptionPPP < UnitTest
  
  def setup
    seee.init  
    seee.out = []
  end
  
  
  def test_010_symbol
    test   = :hallo_test
    result1 = ":hallo_test"
    result2 = "\n:hallo_test"
    assert_equal result1,                test.inspect_pp  
    assert_equal result1,                test.inspect_see      
    assert_equal result2,                see(test);        setup
    assert_equal result2,                see_pp(test);     setup
    assert_equal result2,                see_puts(test);   setup
    assert_equal result2,                see_print(test);  setup    
  end
  
  
  # Bei String unterscheiden sich die Ergebnisse von inspect_see und see 
  def test_021_string
    test    = %q{Hallo "''" Welt}
    result1 = %q{'Hallo "''" Welt'}    
    result2 = %q{Hallo "''" Welt}
    result1b = %Q{\n'Hallo "''" Welt'}   
    result2b = %Q{\nHallo "''" Welt}    
    
    assert_equal result1,               test.inspect_pp  
    assert_equal result1,               test.inspect_see      
    assert_equal result1b,              see_pp(test);     setup
    
    assert_equal result2b,               see_puts(test);   setup
    assert_equal result2b,               see_print(test);  setup
    assert_equal result2b,               see(test);        setup     
  end
  
  
  def test_022_string  
    test     = %q{}
    result1  = %q{''}
    result1b = %Q{\n''}
    result2  = %q{empty}
    result2b = %Q{\nempty}
    
    assert_equal result1,               test.inspect_pp  
    assert_equal result1,               test.inspect_see      
    assert_equal result1b,              see_pp(test);     setup
    
    assert_equal result2b,               see_puts(test);   setup
    assert_equal result2b,               see_print(test);  setup
    assert_equal result2b,               see(test);        setup
  end  
  
  
  def test_031_array
    test   = [1,2,3]
    result1  = %q{[1, 2, 3]}    
    result1b = %Q{\n[1, 2, 3]}    
    assert_equal result1,               test.inspect_pp  
    assert_equal result1b,              see_puts(test);   setup
    assert_equal result1b,              see_print(test);  setup        
    assert_equal result1,               test.inspect_see      
    assert_equal result1b,              see_pp(test);     setup
    assert_equal result1b,              see(test);        setup    
  end
  
  
  def test_032_array
    test = []
    test << ['this','is','an','array','1']
    test << ['this','is','another','array','2']
    test << ['and','this','is','another', :tree]
    test << ['no',{:key => :value},'just','another', 'array'] 
    result1 = %Q{\n[['this', 'is', 'an', 'array', '1'], ['this', 'is', 'another', 'array', '2'], ['and', 'this', 'is', 'another', :tree], ['no', {:key=>:value}, 'just', 'another', 'array']]}
    result2 = result1.gsub(%q{'},%q{"})    
    result3 = <<ENDOFSTRING
[['this',   'is',           'an',      'array',   '1'],
 ['this',   'is',           'another', 'array',   '2'],
 ['and',    'this',         'is',      'another', :tree],
 ['no',     {:key=>:value}, 'just',    'another', 'array']]
ENDOFSTRING
    result3 = result3.chomp.strip.gsub("\n"," \n")
    
    assert_equal result1.gsub("\n",""), test.inspect_pp  
    assert_equal result2,               see_puts(test);   setup
    assert_equal result2,               see_print(test);  setup    
    assert_equal result3,               test.inspect_see#.gsub("\n",'')      
    assert_equal "\n" + result3,        see_pp(test);     setup   
    assert_equal "\n" + result3,        see(test);        setup    
  end  
  
  
  def test_033_array
      t1 = 'long_longlong_long_long'
      t2 = 'also_long, also_long, also_long_also'
      t3 = 'hallo'
      test = []
      test << %W{one a b c}
      test << ['two', t1, t2, t3]
      test << ['three', t2, t2, t1]
    result1 = <<ENDOFSTRING
[['one', 'a', 'b', 'c'],
 ['two', 'long_longlong_long_long', 'also_long, also_long, also_long_also', 'hallo'],
 ['three', 'also_long, also_long, also_long_also', 'also_long, also_long, also_long_also', 'long_longlong_long_long']]
ENDOFSTRING
    result1 = result1.chomp.strip
    result2 = result1.gsub(%q{'},%q{"}).gsub("\n",'')
    result3 = <<ENDOFSTRING
[['one',     'a',                                    'b',                                    'c'],
 ['two',     'long_longlong_long_long',              'also_long, also_long, also_long_also', 'hallo'],
 ['three',   'also_long, also_long, also_long_also', 'also_long, also_long, also_long_also', 'long_longlong_long_long']]
ENDOFSTRING
    result3=result3.chomp
    
    assert_equal result1,               test.inspect_pp  
    assert_equal "\n" + result2,        see_puts(test);   setup
    assert_equal "\n" + result2,        see_print(test);  setup    

    assert_equal result3,               test.inspect_see#.gsub("\n",'')      
    assert_equal "\n" + result3,        see_pp(test);     setup   
    assert_equal "\n" + result3,        see(test);        setup          

  end  
  
  
  
  def test_040_object
    seee.logger
    see 'hi'
    seee.time_last = Time.at(1296702800) 
    test = seee 
    result1 = <<ENDOFSTRING
#<Perception::SeeSession:0x2860d24
 @call_stack_last =  20,
 @call_stack_now =   20,
 @cursor_now =       0,
 @delayed_clear =    false,
 @delayed_newlines = 0,
 @indent =           false,
 @level =            1,
 @logger =           #<Logger:0x2ae165c  @default_formatter=#<>,  @formatter=nil,  @level=0,  @logdev=#<<><[][]>>,  @progname=nil>,
 @method_last =      :puts,
 @method_now =       :pp,
 @out =              [],
 @speed =            nil,
 @string_last =      'hi',
 @time_last =        2011-02-03 Thursday 04:13:20>
ENDOFSTRING
    result1 =  result1.strip.chomp.gsub("\n",' ')
    
    # seee-ID austauschen
    id = "%x" % (seee.__id__ * 2)
    id.sub!(/\Af(?=[[:xdigit:]]{2}+\z)/, '')    if id.sub!(/\A\.\./, '')
    id = "0x#{id}"    
    result1 = result1.gsub('0x2860d24',id)
    
    # Logger-ID austauschen
    id = "%x" % (seee.logger.__id__ * 2)
    id.sub!(/\Af(?=[[:xdigit:]]{2}+\z)/, '')    if id.sub!(/\A\.\./, '')
    id = "0x#{id}"    
    result1 = result1.gsub('0x2ae165c',id)    
    
    #assert_equal result1,               see(test).strip.chomp.gsub("\n",' ');        setup        
  end
  
  
  
  def test_053_dictionary
      require 'hashery' # old: 'facets/dictionary'require 'facets/dictionary'
        
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
      test = @dictionary
      
    result1 = <<ENDOFSTRING
{:a_dictionary=>true,
 :b_init=>true,
 :c_symbol=>:symbol,
 :d_array=>[1, 2, 3],
 :e_integer=>1,
 :f_string=>'hallo',
 :g_subdictionary=>
  {:a=>:value,
   :b=>'blubb',
   :c=>2,
   :d=>[:a, :b, :c],
   :e=>{:key=>:value},
   :f=>'hallo'}}
ENDOFSTRING
    result1 = result1.chomp
    result2 = '{:a_dictionary=>true, :b_init=>true, :c_symbol=>:symbol, :d_array=>[1, 2, 3], :e_integer=>1, :f_string=>"hallo", :g_subdictionary=>{:a=>:value, :b=>"blubb", :c=>2, :d=>[:a, :b, :c], :e=>{:key=>:value}, :f=>"hallo"}}'
    result3 = <<ENDOFSTRING
{:a_dictionary     =>  true,
 :b_init           =>  true,
 :c_symbol         =>  :symbol,
 :d_array          =>  [1,  2,  3],
 :e_integer        =>  1,
 :f_string         =>  'hallo',
 :g_subdictionary  =>  {:a=>:value,  :b=>'blubb',  :c=>2,  :d=>[:a, :b, :c],  :e=>{:key=>:value},  :f=>'hallo'}}
ENDOFSTRING
    result3 = result3.chomp
    
    
    assert_equal result1,               test.inspect_pp  
    assert_equal "\n" + result2,        see_puts(test);   setup
    assert_equal "\n" + result2,        see_print(test);  setup    
    
    assert_equal result3,               test.inspect_see      
    assert_equal "\n" + result3,        see_pp(test);     setup
    assert_equal "\n" + result3,        see(test);        setup   
  end
 
 
  def test_061_set
    test   = SortedSet.new([1,2,3])
    result1 = "{1, 2, 3}"
    assert_equal result1,               test.inspect_pp  
    assert_equal result1,               test.inspect_see        
    assert_equal "\n" + result1,        see_puts(test);   setup
    assert_equal "\n" + result1,        see_print(test);  setup    
    assert_equal "\n" + result1,        see_pp(test);     setup
    assert_equal "\n" + result1,        see(test);        setup    
  end
  
  
  def test_071_multi
    result = see 'hallo', '1'  
    assert_equal %Q{\n'hallo'                 '1'},  result        
    setup
    
    result = see 'halloewtewgsdgvsdgdfgbdfxbgdgbdfgdfxgdsf', '1'  
    assert_equal %Q{\n'halloewtewgsdgvsdgdfgbdfxbgdgbdfgdfxgdsf'       '1'},  result        
    setup    
    
    result = see :a, '1'
    assert_equal %Q{\n:a                      '1'},  result   
    setup  

    result = see [:a,:b], '1'
    assert_equal %Q{\n[:a, :b]                '1'},  result   
    setup  

    result = see [1,2], [:a,:b]
    assert_equal %Q{\n[1, 2]                  [:a, :b]},  result 
    setup
    
    result = see :a,:b,:c
    assert_equal %Q{\n:a                      :b                      :c},  result 
    setup

    result = see 1,2,3
    assert_equal %Q{\n1                       2                       3},  result 
    setup    
  end
 
  
end # class

















