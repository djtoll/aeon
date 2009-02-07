# Go to http://wiki.merbivore.com/pages/init-rb

use_orm  :datamapper
use_test :rspec
use_template_engine :haml

require 'sass' # SASS files weren't being compiled without this...

dependency "merb-assets"
dependency "merb-helpers"

dependency "dm-validations"

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end

Merb::Config.use { |c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = :debug,
  c[:log_stream]          = STDOUT,
  # or use file for logging:
  # c[:log_file]          = Merb.root / "log" / "merb.log",
  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_webserver_session_id',
  c[:session_secret_key]  = 'b1539e59eaa3060b35e5c5914c5b635218dc12d8',
  c[:exception_details]   = true,
  c[:reload_classes]      = true,
  c[:reload_templates]    = true,
  c[:reload_time]         = 0.5
}

