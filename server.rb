require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'json'

DB_CONFIG = {
  dbname: 'postgres',
  user: 'rebase',
  password: '123456',
  host: 'rebase-labs-database',
  port: 5432
}

def get_details_by_token(token)
  conn = PG.connect(DB_CONFIG)
  result = conn.exec("SELECT * FROM exams WHERE result_token ILIKE '#{token}'")
  conn.close
  result.map(&:to_h).to_json
end

def get_data_from_database
  conn = PG.connect(DB_CONFIG)
  result = conn.exec('SELECT * FROM exams')
  conn.close
  result.map(&:to_h).to_json
end

get '/tests' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  content_type :json
  get_data_from_database
end

get '/tests/:token' do
  response.headers['Access-Control-Allow-Origin'] = '*'
  content_type :json
  token = params[:token]
  get_details_by_token(token)
end

get '/home' do
  content_type 'text/html'
  File.open('index.html')
end

if __FILE__ == $0
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end