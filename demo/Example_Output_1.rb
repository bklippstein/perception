# See source code and run it for yourself: {file:demo/demo1.rb}


    Basic Types
    ===========


    1dim Arrays are printed verticaly, if their size is not too big:


    ['this', 'is', 'an', 'array', '1']
    ['this', 'is', 'another', 'array', '2']
    ['complex array', [1, 2, 3], {:key=>:value, :love=>:baby}, 4.0, :four]
    []


    Other Objects:
    ordinary string (without "")
    (next one is empty)
    empty
            1
            2
            3     
    nil
    true
    false
    :a_symbol






    2dimensional Arrays
    ===================


    2dim Arrays are printed like a table:


    [['this',   'is',           'an',      'array',   '1'], 
     ['this',   'is',           'another', 'array',   '2'], 
     ['and',    'this',         'is',      'another', :tree], 
     ['no',     {:key=>:value}, 'just',    'another', 'array']]




    [['one',     'a',                                    'b',                                    'c'],
     ['two',     'long_longlong_long_long',              'also_long, also_long, also_long_also', 'hallo'],
     ['three',   'also_long, also_long, also_long_also', 'also_long, also_long, also_long_also', 'long_longlong_long_long']]






    Nested Objects
    ==============


    Nested objects reveal their structure. Lower hierary levels may be reduced for this:


    #<Perception::SeeSession:0x2aa0cc8
     @call_stack_last =  5,
     @call_stack_now =   6,
     @cursor_now =       1148,
     @delayed_clear =    false,
     @delayed_newlines = 0,
     @indent =           false,
     @level =            1,
     @logger =           #<Logger:0x2ae80c8  @default_formatter=#<>,  @formatter=nil,  @level=0,  @logdev=#<<><<>>>,  @progname=nil>,
     @method_last =      :puts,
     @method_now =       :pp,
     @out =              {:console, :log},
     @speed =            nil,
     @string_last =      '
    ',
     @time_last =        2012-10-18 Thursday 23:27:03>


    The Logger has been reduced. This is its detail view:


    #<Logger:0x2ae80c8
     @default_formatter = #<Logger::Formatter:0x2ae8020  @datetime_format=nil>,
     @formatter =         nil,
     @level =             0,
     @logdev =            #<Logger::LogDevice:0x2af3750  @dev=#<File:C:/Ruby-Projekte/perception/log/see.log>,  @filename='C:/Ruby-Projekte/perception/log/see.log',  @mutex=#<<>>,  @shift_age=0,  @shift_size=1048576>,
     @progname =          nil>




    PrettyPrint shows all at one, but its very hard to read:


    PrettyPrint shows all at one, but its very hard to read:

    #<Perception::SeeSession:0x2aa0cc8
     @call_stack_last=5,
     @call_stack_now=5,
     @cursor_now=2196,
     @delayed_clear=false,
     @delayed_newlines=1,
     @indent=false,
     @level=1,
     @logger=
      #<Logger:0x2ae80c8
       @default_formatter=#<Logger::Formatter:0x2ae8020 @datetime_format=nil>,
       @formatter=nil,
       @level=0,
       @logdev=
        #<Logger::LogDevice:0x2af3750
         @dev=#<File:C:/Ruby-Projekte/perception/log/see.log>,
         @filename='C:/Ruby-Projekte/perception/log/see.log',
         @mutex=
          #<Logger::LogDevice::LogDeviceMutex:0x2af3738
           @mon_count=0,
           @mon_mutex=#<Mutex:0x2af36c0>,
           @mon_owner=nil>,
         @shift_age=0,
         @shift_size=1048576>,
       @progname=nil>,
     @method_last=:puts,
     @method_now=:puts,
     @out={:console, :log},
     @speed=nil,
     @string_last='',
     @time_last=2012-10-18 Thursday 23:27:03>







    Hash
    ====


    {:this=>:hash,  :in=>:one,  :see=>'short hash in one line'}




    {:this         =>  :hash,
     :size         =>  '> 3',
     :see          =>  'longer hash in multiple lines',
     :another_key  =>  'another value'}




    {:hash        =>  true,
     :init        =>  true,
     :nil         =>  nil,
     :symbol      =>  :symbol,
     :text        =>  'text',
     :array       =>  [1,  2,  3],
     :integer     =>  1,
     :string      =>  'hallo',
     :nochn_hash  =>  {:key=>:value,  :bla=>:blubb,  :array=>[:a, :b, :c],  :another_key=>'another value'}}






    Dictionary
    ==========


    {:a_dictionary     =>  true,
     :b_init           =>  true,
     :c_symbol         =>  :symbol,
     :d_array          =>  [1,  2,  3],
     :e_integer        =>  1,
     :f_string         =>  'hallo',
     :g_subdictionary  =>  {:a=>:value,  :b=>'blubb',  :c=>2,  :d=>[:a, :b, :c],  :e=>{:key=>:value},  :f=>'hallo'}}
     
     