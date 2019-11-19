$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'capistrano/rpush'

require "capistrano/all"
require "rspec"
require "time"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.mock_framework = :rspec
  config.order = "random"
end
