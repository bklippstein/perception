# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'kyanite/smart_load_path'
  smart_load_path   
end
require 'perception'
require 'kyanite/unit_test'


class TestPerceptionNumeric < UnitTest
  
  def setup
    seee.init  
    seee.out = []
  end
  
  
  def test_010_significant
    test =   [12567.89, 1256.789, 123.56789, 100.01, 100.0, 99.9, 12.0, 12, 12.56789, 1.256789, 1.5, 0, 0.1256789, 0.01256789, 0.001256789, 0.0001256789 ]
    expect = [12600,    1260,     124,       100,    100,   99.9, 12,   12, 12.6,     1.26,     1.5, 0, 0.126,     0.0126,     0.00126,     0.000126]
    result = test.collect { |t| t.significant }
    assert_equal expect, result
  end
  
  
  def test_020_float_inspect
    test =   [7213541, 553337, 12567.89, 1256.789, 123.56789, 100.01, 100.0, 99.9, 12.0, 12, 12.56789, 1.256789, 1.5, 0, 0.1256789, 0.01256789, 0.001256789, 0.0001256789, ]
    expect =  ['7 210 000     ',
               '  553 000     ',
               '   12 600     ',
               '     1260     ',
               '      124     ',
               '      100     ',
               '      100     ',
               '       99,9   ',
               '       12     ',
               '       12     ',
               '       12,6   ',
               '        1,26  ',
               '        1,5   ',
               '        0     ',
               '        0,126 ',
               '        0,0126',
               '       0,00126',
               '      0,000126']    
    result= test.collect { |t| t.to_f.inspect_see }   
    assert_equal expect, result
    
    result= test.collect { |t| see(t.to_f).gsub("\n",'') }      
    assert_equal expect, result
  end
    
    
  def test_030_integer_inspect    
    assert_equal '        0',                     0.inspect_see             
    assert_equal '    -1000',                    -1000.inspect_see             
    assert_equal '-87 200 000',                  -87213541.inspect_see      
    assert_equal   '988 000 000 000 000 128',     987654321987654321.inspect_see   # Das ist falsch. Rubys Umwandlung to_i funktioniert hier nicht.
    assert_equal '9 990 000 000 000 000 000',    9987654321987654321.inspect_see   # Das ist wieder richtig.
  end  
  
  
  def test_040_see
    test   = 0
    result = '        0' 
    assert_equal "\n" + result,              see(test);        setup
    assert_equal "\n" + result,              see_pp(test);     setup
    assert_equal "\n" + result,              see_puts(test);   setup
    assert_equal "\n" + result,              see_print(test);  setup      
    assert_equal "\n" + result,              see_print(test);  setup      
    
    test   = 9987654321987654321
    result = '9 990 000 000 000 000 000'    
    assert_equal "\n" + result,              see(test);        setup
    assert_equal "\n" + result,              see_pp(test);     setup
    assert_equal "\n" + result,              see_puts(test);   setup
    assert_equal "\n" + result,              see_print(test);  setup       
    assert_equal "\n" + result,              see_print(test);  setup       

    test   = -0.000314162353463463136537846595
    result = '     -0,000314'
    assert_equal "\n" + result,              see(test);        setup
    assert_equal "\n" + result,              see_pp(test);     setup
    assert_equal "\n" + result,              see_puts(test);   setup
    assert_equal "\n" + result,              see_print(test);  setup       
    assert_equal "\n" + result,              see_print(test);  setup       
  end
 
  
  
end # class

















