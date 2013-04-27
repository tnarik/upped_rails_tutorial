role :web, "nonmachinepeople.net"                          # Your HTTP server, Apache/etc
role :app, "nonmachinepeople.net"                          # This may be the same as your `Web` server
role :db,  "nonmachinepeople.net", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/tnarik/ror/#{application}"

set :user, "tnarik"  # The server's user for deploys