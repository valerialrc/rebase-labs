require './server'
require 'rspec'
require 'rack/test'

RSpec.describe 'RebaseLabsApp' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /hello' do
    it 'responds with 200 OK' do
      get '/hello'
      expect(last_response).to be_ok
    end

    it 'responds with the correct body' do
      get '/hello'
      expect(last_response.body).to eq('Hello world!')
    end
  end
end
