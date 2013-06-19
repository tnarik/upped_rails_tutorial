role :web, "192.168.33.10"                          # Your HTTP server, Apache/etc
role :app, "192.168.33.10"                          # This may be the same as your `Web` server
role :db,  "192.168.33.10", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/tnarik/ror/staged_#{application}"
set :rails_env, "staging"

set :user, "tnarik"  # The server's user for deploys