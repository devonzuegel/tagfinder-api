RSpec.describe Tagfinder::App do
  include Rack::Test::Methods

  def app
    described_class
  end

  it do
    skip
    get '/tagfinder', key: 'password'
    ap last_response.body
  end
end
