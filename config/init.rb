Gem.clear_paths
Gem.path.unshift(Merb.root / "gems")

$LOAD_PATH.unshift(Merb.root / "lib")
$LOAD_PATH.unshift(Merb.root / "systems")

require 'lib/core_ext/kernel' # For Kernel#acquire
acquire 'lib/core_ext'

Merb::Config.use do |c|
  c[:session_secret_key]  = '5e3412d6017213b22a51ad293d15558ae2677c0c'
  c[:session_store] = 'cookie'
end  

# use_orm :datamapper
use_test :rspec

Merb::BootLoader.after_app_loads do; end