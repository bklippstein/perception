# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end

$mode = :nothing
$mode = :profile
$mode = :tracker

    
    if $mode == :tracker
      require 'drumherum/call_tracker' 
    elsif $mode == :profile
     require 'profile'
    end   
    
    @array1 = []
    @array1 << ['this','is','an','array','1']
    @array1 << ['this','is','another','array','2']
    @array1 << ['and','this','is','another', :tree]
    @array1 << ['next',[1,2,3],'just','another', 'array']
    seee.init  
    if $mode == :tracker  ||  $mode == :profile
      seee.out = []
    end
      
    if $mode == :tracker  
      tracker = CallTracker.new
      tracker.register(Array, :each)
    end
    
    see @array1
    # see ['aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa','bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb','ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc']

    if $mode == :tracker          
      tracker.stop
    end





