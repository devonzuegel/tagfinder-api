require 'sinatra/base'
require 'sinatra/reloader'
require 'concord'
require 'securerandom'
require 'procto'
require 'json'
require 'colorize'
require 'awesome_print'
require 'anima'
require 'open3'
require 'forwardable'
require 'abstract_class'
require 'http'
require 'pathname'

require './lib/tagfinder/shell'
require './lib/tagfinder/shell/adapter'
require './lib/tagfinder/shell/command'
require './lib/tagfinder/command_line'
require './lib/tagfinder/execution'
require './lib/tagfinder/downloader'
require './lib/tagfinder/downloader/connection'
require './lib/tagfinder/downloader/request'
require './lib/tagfinder/downloader/file_creator'

module Tagfinder
  class App < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
      also_reload './lib/*'
    end

    before do
      content_type 'application/json'
    end

    before '/*' do
      check_keys
      check_password
    end

    get '/tagfinder' do
      ap params
      # cli = Sinatra::Base.development? ? Tagfinder::MacCLI.new : Tagfinder::UbuntuCLI.new
      # Tagfinder::Execution.call(
      #   data_url:   params.fetch('data_url'),
      #   params_url: params['params_url'],
      #   downloader: Tagfinder::Downloader,
      #   cli:        cli
      # ).to_json
    end

    # error do
    #   status 400
    #   {
    #     result:  'error',
    #     type:    env['sinatra.error'].class,
    #     message: env['sinatra.error'].message
    #   }.to_json
    # end

    def check_keys
      default_params  = %w[splat captures].sort
      expected_params = %w[data_url params_url key].sort
      user_provided   = (params.keys - default_params).sort
      return if Set.new(params.keys).subset?(Set.new(expected_params + default_params))
      halt 400, "Provided parameters don't match expected parameters:\n" \
                "  Provided: #{user_provided}\n" \
                "  Expected: #{expected_params}\n"
    end

    def check_password
      return if params.fetch('key') == ENV['TAGFINDER_KEY']
      halt 403
    end
  end
end
