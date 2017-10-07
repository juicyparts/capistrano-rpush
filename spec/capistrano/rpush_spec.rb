require 'spec_helper'
require 'capistrano/plugin'

module Capistrano
  describe Rpush do
    include Rake::DSL
    include Capistrano::DSL

    before do
      # Define an example task to allow testing hooks
      task 'deploy:check'
      task 'deploy:finished'
    end

    after do
      # Clean up any tasks or variables we created during the tests
      Rake::Task.clear
      Capistrano::Configuration.reset!
    end

    context 'rpush rake tasks' do
      it 'defines :check' do
        install_plugin subject
        expect(Rake::Task['rpush:check']).not_to be_nil
      end

      it 'defines :restart' do
        install_plugin subject
        expect(Rake::Task['rpush:restart']).not_to be_nil
      end

      it 'defines :start' do
        install_plugin subject
        expect(Rake::Task['rpush:start']).not_to be_nil
      end

      it 'defines :status' do
        install_plugin subject
        expect(Rake::Task['rpush:status']).not_to be_nil
      end

      it 'defines :stop' do
        install_plugin subject
        expect(Rake::Task['rpush:stop']).not_to be_nil
      end
    end

    it 'registers hooks when constructed' do
      skip 'TODO'
      install_plugin subject
      expect(Rake::Task['deploy:check'].prerequisites).to include('hello')
    end

    it 'skips registering hooks if load_hooks: false' do
      skip 'TODO'
      install_plugin subject, load_hooks: false
      expect(Rake::Task['deploy:check'].prerequisites).to be_empty
    end
  end
end
