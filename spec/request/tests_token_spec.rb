require './server'
require 'rspec'
require 'rack/test'

RSpec.describe 'RebaseLabsApp' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /tests/:token' do
    it 'responds with 200 OK' do
      get '/tests/IQCZ17'
      expect(last_response).to be_ok
    end
    

    it 'responds with JSON content type' do
      get '/tests/IQCZ17'
      expect(last_response.content_type).to eq('application/json')
    end

    it 'responds with data from database' do
      allow_any_instance_of(Object).to receive(:get_details_by_token).and_return([{ id: 1, name: 'Teste 1' }, { id: 2, name: 'Teste 2' }].to_json)

      get '/tests/IQCZ17'
      expect(last_response.body).to eq([{ id: 1, name: 'Teste 1' }, { id: 2, name: 'Teste 2' }].to_json)
    end
  end
end
