# ruby encoding: utf-8
# ü

require 'drumherum'
smart_init
require 'version' 
require 'rdoc/task'
require 'drumherum/rake'

Drumherum.github_username = 'bklippstein'
require 'perception'


#  ----------------------------------------------------------------------------------------------
#  Hoe
#  
# http://nubyonrails.com/articles/tutorial-publishing-rubygems-with-hoe
#
$hoe = Hoe.spec Drumherum.project_name do 

  # self.rubyforge_name = 'yourgemx' # if different than 'yourgem'
   
  developer('Bjoern Klippstein', 'klippstein@klippstein.com')
  summary               = 'Beautiful and readable printouts for console and logs.' 
  extra_deps            << ['drumherum',  '>= 0.1.10']
  extra_deps            << ['kyanite',    '>= 0.5.17']
  extra_deps            << ['highline',   '>= 1.6.15']
  remote_rdoc_dir = '' # Release to root only one project  
  urls                  = [["http://#{Drumherum.github_username}.github.com/#{Drumherum.project_name}/"]]
                              
end



#  ----------------------------------------------------------------------------------------------
#  Documentation
#  
# http://rubeh.tumblr.com/post/27622544/rake-rdoctask-with-all-of-the-options-stubbed-out
# http://www.java2s.com/Code/Ruby/Language-Basics/RDocoptionsareusedlikethisrdocoptionsnames.htm
#   

remove_task 'docs' 

desc "generate RDoc documentation"
Rake::RDocTask.new(:docs) do |rd| 

    rd.title    = "#{Drumherum.project_class.to_s} #{Drumherum.project_version}"

    rd.rdoc_dir = 'doc'   
    rd.rdoc_files.include('lib/**/*.rb')
    # rd.rdoc_files.include('test/**/test_*.rb')
    rd.rdoc_files.include('README.txt', 'License.txt', 'History.txt' )

    rd.options += [
        '--tab-width', '4',
        '--main', 'README.txt',
        '--show-hash',        # A name of the form #name in a comment is a possible hyperlink to an instance method name. When displayed, the # is removed unless this option is specified.
        '--line-numbers',
        '--all',
        '--charset=utf8'      
      ]      
      
end







#  ----------------------------------------------------------------------------------------------
#  Local Tasks
#  

remove_task 'ridocs'
remove_task 'rdoc' 
remove_task 'audit' 
remove_task 'dcov' 
remove_task 'debug_email' 
remove_task 'debug_gem' 
remove_task 'deploy' 
remove_task 'deps:email' 
remove_task 'install_gem'
remove_task 'multi' 
remove_task 'newb' 
#Dir['tasks/**/*.rake'].each { |t| load t }  





















