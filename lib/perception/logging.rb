# ruby encoding: utf-8
# ü
if $0 == __FILE__ 
  require 'drumherum'
  smart_init
  require 'perception'
end


module Perception 

  class SeeSession
  
  # @group Logging
  

    # Looks for a good place to save the log file,
    # creates log directory & log file if necessary and
    # instantiates Logger Object.
    # 
    # Where is my logfile? Try
    #  see seee.logger
    #  =>
    #  <Logger:0x2a57d20
    #    @default_formatter = #<Logger::Formatter:0x2a57cc0  @datetime_format=nil>,
    #    @formatter =         nil,
    #    @level =             0,
    #    @logdev =            #<Logger::LogDevice:0x2a57c60  @dev=#<File:C:/Ruby-Projekte/perception/log/see.log>,  @filename='C:/Ruby-Projekte/perception/log/see.log',  @mutex=#<<>>,  @shift_age=0,  @shift_size=1048576>,
    #    @progname =          nil>
    #
    # More: {Object#log log}, {Object#rawlog rawlog}    
    # @return [Logger]
    #
    def logger( logdir=nil, filename='see.log' )
      return @logger  if @logger
      require 'logger'    unless defined?(Logger)
      
      # Logfile festlegen
      unless logdir      
      
        if Drumherum.host_os == :windows
          smart_init   if Drumherum.directory_main.empty?
          logdir = File.expand_path(File.join(Drumherum.directory_main, 'log'))
          # puts "logdir= #{logdir}   size=#{logdir.split('/').size}"
        end # if windows     
        if ( Drumherum.host_os != :windows  ||  logdir.nil?  ||  logdir.empty?  ||  logdir == 'test/log'  ||  logdir.split('/').size <= 2 )
          require 'tmpdir'
          logdir = Dir::tmpdir + '/log'
        end          

      end # unless

      mycaller = CallerUtils.mycaller(:skip => ['perception', 'ruby\gems', 'ruby/gems', 'test/unit'])    
      logfile =  File.join(logdir, filename)
      #puts "mycaller=#{mycaller.inspect_pp}"
      #puts "logdir=#{logdir.inspect_pp}"
      #puts "logfile=#{logfile.inspect_pp}"
           
      # Erzeugen, wenn nötig
      begin
        # Dir erzeugen
        unless File.exist?(logdir)
          FileUtils.makedirs(logdir)
          puts "\n\nSeeSession#logger: Directory #{logdir} created\n\n"
        end
        # File erzeugen
        unless File.exist?(logfile)
          File.open(logfile,(File::WRONLY | File::APPEND | File::CREAT)) 
          if  (mycaller.nil? || mycaller.empty?)
            log_status
          else
            log_status("Logfile created by #{mycaller}") 
          end
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
    
    
    # Prints a separator, the actual time and an optional message in the log file.
    # Usage:
    #  seee.log_status "My Message"
    #  => (in log file)
    #
    #   ------------------------------------------------------------------------------------------------------------------------
    #   2012-10-17 Wednesday 10:47:05
    #   My Message  
    #
    # @return [void]
    # @param [String] message message to print
    # 
    def log_status(message='')
      status =  "\n\n\n# " + ('-'*120) + "\n"
      status += "# " + Time.now.inspect_see + "\n"
      status += "# " + message + "\n"
      logger << status
    end
    

  end # class


end # module


class Object

  # Same as method see, but outputs in logfile only.
  #
  # If you want to use both logfile and console , use
  #   seee.out << :log
  #
  # More: {Object#rawlog rawlog}, {Perception::SeeSession#logger seee.logger}  
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
  
  
  # raw output into logfile without formating.
  #
  # More: {Object#log log}, {Perception::SeeSession#logger seee.logger}  
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

 










  