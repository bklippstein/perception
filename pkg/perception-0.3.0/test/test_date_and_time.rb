# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'kyanite/smart_load_path'
  smart_load_path   
end
require 'perception'
require 'kyanite/unit_test'


class TestPerceptionDateAndTime < UnitTest

  def setup
    seee.init  
    seee.out = []
  end

  
  def test_010_time_inspect
    test = Time.at(1296702800) 
    assert_equal '2011-02-03 Thursday 04:13:20',    test.inspect_pp
    assert_equal '2011-02-03 Thursday 04:13:20',    test.inspect_see
    assert_equal '2011-02-03  04:13',               test.inspect_see(:precision => 1)
    assert_equal '03.Feb.2011',                     test.inspect_see(:norm => :de, :precision => 0)
  end
  
  
  def test_020_time_see
    test = Time.at(1296702800) 
    assert_equal "\n2011-02-03 Thursday 04:13:20",    see_print(test)
    setup
    assert_equal "\n2011-02-03 Thursday 04:13:20",    see_puts(test)
    setup 
    assert_equal "\n2011-02-03 Thursday 04:13:20",    see_pp(test)  
    setup
    assert_equal "\n2011-02-03 Thursday 04:13:20",    see(test)  
    setup     
  end

 
  
  
end # class

















