module Capistrano
  module RpushPlugin
    module Common

      def rpush_switch_user role, &block
        user = rpush_user role
        if user == role.user
          block.call
        else
          as user do
            block.call
          end
        end
      end

      def rpush_user role
        properties = role.properties
        properties.fetch(:rpush_user) ||  # local property for rpush only
        fetch(:rpush_user) ||
        properties.fetch(:run_as) ||      # global property across multiple capistrano gems
        role.user
      end
    end
  end
end
