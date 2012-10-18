# ruby encoding: utf-8

require 'drumherum'
smart_init
require 'version' 
require 'yard'
require 'drumherum/rake'
YARD::Rake::YardocTask.new

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
  extra_deps            << ['drumherum',  '>= 0.1.19']
  extra_deps            << ['kyanite',    '>= 0.5.17']
  extra_deps            << ['highline',   '>= 1.6.15']
  remote_rdoc_dir = '' # Release to root only one project  
  urls                  = [[Drumherum.url_docs], [Drumherum.url_source]]
                              
end




#  ----------------------------------------------------------------------------------------------
#  Hide Tasks
#  
 
 hide_tasks [ :announce, :audit, :check_extra_deps, :clobber_docs, :clobber_package, :default ]
 hide_tasks [ :dcov, :debug_email, :docs, :gem, :git_add, :git_commit, :git_push, :install_gem ]
 hide_tasks [ :newb, :package, :post_blog, :publish_docs, :release, :release_sanity, :release_to_gemcutter ]
 hide_tasks [ :repackage, :ridocs, :sleep_15, :sleep_5, :utf8, :yard, :yard_post ]
























