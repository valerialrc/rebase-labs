require './server.rb'
require 'rack/test'
require 'csv'

RSpec.describe "CSV Upload", type: :feature do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:each) do
    ENV['RACK_ENV'] = 'test' # Define o ambiente como "test" antes de cada teste
  end

  it "allows uploading a CSV file" do
    post '/import', csv_file: Rack::Test::UploadedFile.new('./data.csv', 'text/csv')
    
    expect(last_response).to be_ok
    expect(last_response.body).to include('Arquivo CSV importado com sucesso.')
  end

  it "allows uploading a CSV file but returns error" do
    allow_any_instance_of(Object).to receive(:import_csv_to_database).and_return(false)

    post '/import', file: Rack::Test::UploadedFile.new('data.csv', 'text/csv')

    expect(last_response).to_not be_ok
    expect(last_response.body).to include('Erro ao importar o arquivo CSV')
  end
end
