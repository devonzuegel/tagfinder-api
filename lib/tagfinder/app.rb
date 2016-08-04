require './lib/tagfinder/required_gems'

module Tagfinder
  class App < Sinatra::Base
    configure :development do
      require 'sinatra/reloader'
      register Sinatra::Reloader
      also_reload './lib/*'
    end

    if ENV['SINATRA_ENV'] == 'production'
      set :port, 80
      set :environment, :production
    end

    set show_exceptions: false

    before do
      content_type 'application/json'
    end

    before '/*' do
      check_keys
      check_password
      puts "\n#{Time.now} >".gray + "  Received the following parameters:".white
      ap params
    end

    get '/tagfinder' do
      cli = ENV['SINATRA_ENV'] == 'production' ? Tagfinder::UbuntuCLI.new : Tagfinder::MacCLI.new

      Retrier::ENOENT.call(
        proc do
          Tagfinder::Execution.call(
            data_url:   params.fetch('data_url'),
            params_url: params['params_url'],
            downloader: Tagfinder::Downloader,
            cli:        cli
          ).to_json
        end
      )
    end

    error do
      info = [{ 'error' => env['sinatra.error'].message }.to_json]
      Rack::Response.new(info, 500, 'Content-type' => 'application/json').finish
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
