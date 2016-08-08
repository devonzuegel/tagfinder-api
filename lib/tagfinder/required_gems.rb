DOT_ENV_PATH = Pathname.new('').join('.env').expand_path

def env_undefined?
  !File.file?(DOT_ENV_PATH)
end

fail Exception, 'Please define your environment in .env' if env_undefined?

require 'dotenv'
Dotenv.load(DOT_ENV_PATH)

require 'sinatra/base'
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
require 'retries'

require './lib/tagfinder/key_checker'
require './lib/tagfinder/shell'
require './lib/tagfinder/shell/adapter'
require './lib/tagfinder/shell/command'
require './lib/tagfinder/command_line'
require './lib/tagfinder/execution'
require './lib/tagfinder/execution/retrier'
require './lib/tagfinder/execution/results_uploader'
require './lib/tagfinder/execution/s3_uploader'
require './lib/tagfinder/downloader'
require './lib/tagfinder/downloader/connection'
require './lib/tagfinder/downloader/request'
require './lib/tagfinder/downloader/file_creator'