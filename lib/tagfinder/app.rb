require 'sinatra/base'
require 'sinatra/reloader'
require 'concord'
require 'securerandom'
require 'procto'
require 'json'
require 'colorize'
require 'anima'
require 'open3'
require 'forwardable'
require 'http'

require './lib/tagfinder/shell'
require './lib/tagfinder/command_line'
require './lib/tagfinder/execution'
require './lib/tagfinder/shell/adapter'
require './lib/tagfinder/shell/command'
require './lib/tagfinder/shell/command/echo'
require './lib/tagfinder/downloader'

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
      halt 403 if params.fetch('key') != ENV['TAGFINDER_KEY']
    end

    get '/tagfinder' do
      Tagfinder::Execution.call(
        params.fetch('data_file'),
        params['config_file_url']
      ).to_json
    end
  end
end
