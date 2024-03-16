require 'rack/test'
require './server.rb'

describe 'RebaseLabsApp' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should return status 200 and content type text/html for /home' do
    get '/home'
    expect(last_response).to be_ok
    expect(last_response.content_type).to start_with('text/html')
  end
end
