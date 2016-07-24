require './lib/app'

if ENV['SINATRA_ENV'] == 'production'
  set :port, 80
  set :environment, :production
end

Tagfinder::App.run!

# https://s3-us-west-2.amazonaws.com/isostamp-development/uploads/1469058557028-4djv394s236f0j9p-c378d7276222b8a0e52c5d14266e1687/ORB33545.mzXML
# https://s3-us-west-2.amazonaws.com/isostamp-development/uploads/1468542048105-vq43mketbu5pvt00-e40e3683460a445923810c8b06293bbb/test.mzXML