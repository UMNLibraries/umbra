server "lib-umbra-dev-01.oit.umn.edu", user: "swadm", roles: %w{app db web}
set :deploy_to, "/swadm/var/www/app"
set :use_sudo, false
set :bundle_flags, '--deployment'
set :keep_releases, 4
