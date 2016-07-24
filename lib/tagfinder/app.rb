require 'sinatra/base'
require 'sinatra/reloader'
require 'concord'
require 'securerandom'
require 'procto'
require 'json'
require 'colorize'
require 'anima'
require 'open3'

require './lib/tagfinder/shell'
require './lib/tagfinder/execution'

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
