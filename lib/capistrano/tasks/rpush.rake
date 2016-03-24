namespace :load do
  set :rpush_default_hooks, -> { true }
  set :rpush_role,          :app
  set :rpush_env,           -> { fetch(:rack_env, fetch(:rails_env, fetch(:stage))) }
  set :rpush_conf,          -> { File.join(shared_path, 'config', 'rpush.rb') }
  set :rpush_log,           -> { File.join(shared_path, 'log', 'rpush.log') }
  set :rpush_pid,           -> { File.join(shared_path, 'tmp', 'pids', 'rpush.pid') }
end

namespace :deploy do
  before :starting, :check_rpush_hooks do
    invoke 'rpush:add_default_hooks' if fetch(:rpush_default_hooks)
  end
end

namespace :rpush do

  task :add_default_hooks do
    after 'deploy:check',    'rpush:check'
    after 'deploy:finished', 'rpush:restart'
  end

  task :check do
    on roles (fetch(:rpush_role)) do |role|
      #Create rpush.rb for new deployments
      unless  test "[ -f #{fetch(:rpush_conf)} ]"
        warn 'rpush.rb NOT FOUND!'
        info 'Configure rpush for your project before attempting a deployment.'
      end
    end
  end

  desc 'Restart rpush'
  task :restart do
    on roles (fetch(:rpush_role)) do |role|
      rpush_switch_user(role) do
        if test "[ -f #{fetch(:rpush_pid)} ]"
          invoke 'rpush:stop'
        end
        invoke 'rpush:start'
      end
    end
  end

  desc 'Start rpush'
  task :start do
    on roles (fetch(:rpush_role)) do |role|
      rpush_switch_user(role) do
        if test "[ -f #{fetch(:rpush_conf)} ]"
          info "using conf file #{fetch(:rpush_conf)}"
        else
          invoke 'rpush:check'
        end
        within current_path do
          with rack_env: fetch(:rpush_env) do
            execute :bundle, :exec, "rpush start -p #{fetch(:rpush_pid)} -c #{fetch(:rpush_conf)} -e #{fetch(:rpush_env)}"
          end
        end
      end
    end
  end

  desc 'Status rpush'
  task :status do
    on roles (fetch(:rpush_role)) do |role|
      rpush_switch_user(role) do
        if test "[ -f #{fetch(:rpush_conf)} ]"
          within current_path do
            with rack_env: fetch(:rpush_env) do
              execute :bundle, :exec, "rpush status -c #{fetch(:rpush_conf)} -e #{fetch(:rpush_env)}"
            end
          end
        end
      end
    end
  end

  desc 'Stop rpush'
  task :stop do
    on roles (fetch(:rpush_role)) do |role|
      rpush_switch_user(role) do
        unless  test "[ -f #{fetch(:rpush_pid)} ]"
          within current_path do
            with rack_env: fetch(:rpush_env) do
              execute :bundle, :exec, "rpush stop -p #{fetch(:rpush_pid)} -c #{fetch(:rpush_conf)} -e #{fetch(:rpush_env)}"
            end
          end
        end
      end
    end
  end

  def rpush_switch_user(role, &block)
    user = rpush_user(role)
    if user == role.user
      block.call
    else
      as user do
        block.call
      end
    end
  end

  def rpush_user(role)
    properties = role.properties
    properties.fetch(:rpush_user) ||               # local property for rpush only
    fetch(:rpush_user) ||
    properties.fetch(:run_as) || # global property across multiple capistrano gems
    role.user
  end

end

