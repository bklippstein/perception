# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end


module Perception #:nodoc

  class SeeSession
  
    def logger( logdir=nil, filename='see.log' )
      return @logger  if @logger
      require 'logger' unless defined?(Logger)
      
      # Logfile festlegen
      unless logdir
        mycaller = CallerUtils.mycaller(:skip => ['perception', 'ruby\gems', 'ruby/gems', 'rubygems', 'test/unit']) 
        logdir =   CallerUtils.mycaller_maindir(mycaller) + '/log'           if mycaller
      end
      if ( logdir.nil?  ||  logdir == 'test/log' )
        require 'tmpdir'
        logdir = Dir::tmpdir + '/log'
      end
      logfile =  File.join(logdir, filename)
      puts "\nmycaller=#{mycaller.inspect_pp}"
      puts "\nlogdir=#{logdir.inspect_pp}"
      puts "\nlogfile=#{logfile.inspect_pp}"
      
            
      # Erzeugen, wenn nötig
      begin
        # Dir erzeugen
        unless File.exist?(logdir)
          Dir.mkdir(logdir)
          puts "\n\nSeeSession#logger: Directory #{logdir} created\n\n"
        end
        # File erzeugen
        unless File.exist?(logfile)
          File.open(logfile,(File::WRONLY | File::APPEND | File::CREAT)) 
          log_status("Logfile created by #{mycaller}")
        end
        #Logger erzeugen
        @logger =        Logger.new( logfile )
        log_level =      :debug
        @logger.level =  Logger.const_get(log_level.to_s.upcase)
        @logger <<       "\n"          # dem letzten Eintrag fehlt vielleicht das newline 
      #rescue

      end
      
      return @logger
    end # def        
    
    
    
    def log_status(message='')
      status =  "\n\n\n# " + ('-'*120) + "\n"
      status += "# " + Time.now.inspect_see + "\n"
      status += "# " + message + "\n"
      logger << status
    end
    

  end # class


end # module


class Object

  # Same as method see, but outputs in logfile only
  def log(input=:kein_input, *rest)
    out_bak = seee.out.dup
    seee.out=[:log]
    if rest.empty?
      see input
    else
      seee.process_print( ( [input] + rest), :method => :multi )
    end
    seee.out=out_bak
    nil
  end    
  
  
  # raw output into logfile
  def rawlog(input='')
    seee.logger << (input)       
    nil
  end       
  

end



# -----------------------------------------------------------------------------------------
#  Ausprobieren
#
if $0 == __FILE__  &&  Drumherum::loaded? then

  # Hier einstellen, was laufen soll
  $run = :try
  #$run = :tests
  #$run = :demo
  
  case $run     
    
  when :try #-------------------------------------------------------------------------------    
    
    see $LOAD_PATH
    see
    see "Hallo"
    see 'Jups.', :g, :h
    see seee.logger
    log 'Jups.'
    log 'Jups.', :g, :h
    
  when :demo #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'demo', 'demo_pp' )
    Perception::DemoSee.see_all_demos   
  
    
  when :tests #------------------------------------------------------------------------------     
  
    require File.join(Drumherum::directory_main, 'test', '_start_all' )
    
    
  else #--------------------------------------------------------------------------------------
  
    see '$run einstellen!'
    
  
  end # case  

    
  
  
end # if

 










  