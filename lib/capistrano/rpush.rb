require 'capistrano/plugin'
require 'capistrano/rpush/common'

class Capistrano::Rpush < Capistrano::Plugin
  include Capistrano::RpushPlugin::Common

  def define_tasks
    eval_rakefile File.expand_path('../tasks/rpush.rake', __FILE__)
  end

  def set_defaults
    set_if_empty :rpush_default_hooks, true
    set_if_empty :rpush_role,          :app
    set_if_empty :rpush_env,           -> { fetch(:rack_env, fetch(:rails_env, fetch(:stage))) }
    set_if_empty :rpush_conf,          -> { File.join(current_path, 'config', 'initializers', 'rpush.rb') }
    set_if_empty :rpush_log,           -> { File.join(shared_path, 'log', 'rpush.log') }
    set_if_empty :rpush_pid,           -> { File.join(shared_path, 'tmp', 'pids', 'rpush.pid') }

    append :chruby_map_bins, 'rpush'
    append :rbenv_map_bins, 'rpush'
    append :rvm_map_bins, 'rpush'
    append :bundle_bins, 'rpush'
  end

  def register_hooks
    after 'deploy:check',    'rpush:check'
    after 'deploy:finished', 'rpush:restart'
  end

end
