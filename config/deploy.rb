require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :stages, %w(production staging)
set :default_stage, "staging"


set :application, "hostedupped"


set :scm, :git
set :repository,  "git@github.com:tnarik/upped_rails_tutorial.git"
set :scm_passphrase, ""


set :use_sudo, false

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
          database: upped_#{stage}
          host: localhost
          username: upped
          password: #{Capistrano::CLI.password_prompt("Enter database password: ")}
      EOF

      config = ERB.new(template)
      run "mkdir -p #{File.join(shared_path,'config')}"
      put config.result(binding), "#{File.join(shared_path,'config','database.yml')}" 
    end

    desc <<-DESC
      [internal] Updates the symlink for database.yml file to the just deployed release.
    DESC
    task :symlink, :except => { :no_release => true } do
      run "rm #{File.join(current_release,'config','database.yml')}"
      run "ln -nfs #{File.join(shared_path,'config','database.yml')} #{File.join(current_release,'config','database.yml')}" 
    end

  end
end
after "deploy:setup", "deploy:db:setup" unless fetch(:skip_db_setup, false)
after "deploy:finalize_update", "deploy:db:symlink"



before 'deploy:update_code', 'git:create_deploy_tag'

namespace :git do
  def using_git?
    fetch(:scm, :git).to_sym == :git
  end

  def last_tag_matching(pattern)
    matching_tags = `git tag -l '#{pattern}'`.split
    matching_tags.sort! do |a,b|
      b <=> a
    end

    last_tag = if matching_tags.length > 0
                 matching_tags[0]
               else
                 nil
               end
  end

  task :create_deploy_tag do
    if using_git?
      current_sha = `git log --pretty=format:%H HEAD -1`
      next_tag = "#{stage}-#{release_name}-#{user}"

      last_tag = last_tag_matching "#{stage}-*"
      last_tag_sha = if last_tag
                       `git log --pretty=format:%H #{last_tag} -1`
                     end
      user = `git config --get user.name`.chomp
      email = `git config --get user.email`.chomp
      local_branch = `git branch --no-color 2> /dev/null | sed -e '/^[^*]/d'`.gsub(/\* /, '').chomp
      local_sha = `git log --pretty=format:%H HEAD -1`.chomp
      origin_sha = `git log --pretty=format:%H origin/#{local_branch} -1`
      # There could be an error when no remote branch exist (which should if we want to deploy using Capistrano)

      unless local_sha == origin_sha
        abort "#{local_branch} is not up to date with origin/#{local_branch}. Please make sure your code is up to date."
      end

      if last_tag_sha == current_sha
        puts "the same version in local and origin #{local_branch}"
        new_tag = last_tag
      else
        new_tag = next_tag
        puts "[git] creating new deploy tag"
        `git tag -a #{new_tag} -m 'Deploy: #{Time.now} by #{user} <#{email}>'`
        `git push origin --tags #{local_branch}`

        #{} -m 'Deploy: #{Time.now}' origin/production && git push origin --tags`
      end
      set :branch, new_tag
    end
   end
end


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end