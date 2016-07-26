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
require 'aws-sdk'

require './lib/tagfinder/key_checker'
require './lib/tagfinder/shell'
require './lib/tagfinder/shell/adapter'
require './lib/tagfinder/shell/command'
require './lib/tagfinder/command_line'
require './lib/tagfinder/execution'
require './lib/tagfinder/execution/results_uploader'
require './lib/tagfinder/execution/s3_uploader'
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

    set show_exceptions: false

    before do
      content_type 'application/json'
    end

    before '/*' do
      check_keys
      check_password
    end

    get '/tagfinder' do
      cli = Sinatra::Base.development? ? Tagfinder::MacCLI.new : Tagfinder::UbuntuCLI.new
      Tagfinder::Execution.call(
        data_url:   params.fetch('data_url'),
        params_url: params['params_url'],
        downloader: Tagfinder::Downloader,
        cli:        cli
      ).to_json
    end

    error do
      Rack::Response.new(
        [{ 'error' => env['sinatra.error'].message }.to_json],
        500,
        'Content-type' => 'application/json'
      ).finish
    end

    def check_keys
      success, message = KeyChecker.call(params)
      fail ArgumentError, message unless success
    end

    def check_password
      return if params.fetch('key') == ENV['TAGFINDER_KEY']
      fail ArgumentError, 'Incorrect password'
    end
  end
end
