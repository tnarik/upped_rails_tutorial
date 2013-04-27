require 'bundler/capistrano'

set :application, "hostedupped"

set :scm, :git
set :repository,  "git@github.com:tnarik/upped_rails_tutorial.git"
set :scm_passphrase, ""

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "nonmachinepeople.net"                          # Your HTTP server, Apache/etc
role :app, "nonmachinepeople.net"                          # This may be the same as your `Web` server
role :db,  "nonmachinepeople.net", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/tnarik/ror/#{application}"
set :use_sudo, false

set :user, "tnarik"  # The server's user for deploys
set :ssh_options, { :forward_agent => true }
set :git_shallow_clone, 1


## RVM and capistrano
set :rvm_require_role, :app
set :rvm_ruby_string, :local               # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"        # more info: rvm help autolibs

before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, OR:
#before 'deploy:setup', 'rvm:create_gemset' # only create gemset
require "rvm/capistrano"

namespace :deploy do
  desc "Restart server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_release,'tmp','restart.txt')}"
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end
before "deploy:finalize_update", "rvm:trust_rvmrc"

namespace :deploy do
  namespace :db do

    desc <<-DESC
      Creates the database.yml configuration file in the release path.
 
      When this recipe is loaded, db:setup is automatically configured \
      to be invoked after deploy:setup. You can skip this task setting \
      the variable :skip_db_setup to true. This is especially useful \ 
      if you are using this recipe in combination with \
      capistrano-ext/multistaging to avoid multiple db:setup calls \ 
      when running deploy:setup for all stages one by one.
    DESC
    task :setup, :except => { :no_release => true } do
      template = <<-EOF
        production:
          adapter: postgresql
          encoding: unicode
          database: upped
          host: localhost
          username: upped
          password: #{Capistrano::CLI.password_prompt("Enter database password: ")}
      EOF

      config = ERB.new(template)

      run "mkdir -p #{shared_path}/config"
      put config.result(binding), "#{shared_path}/config/database.yml"
    end

    desc <<-DESC
      [internal] Updates the symlink for database.yml file to the just deployed release.
    DESC
    task :symlink, :except => { :no_release => true } do
      run "rm #{release_path}/config/database.yml"
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end

  end
end
after "deploy:setup", "deploy:db:setup" unless fetch(:skip_db_setup, false)
after "deploy:finalize_update", "deploy:db:symlink"




# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end