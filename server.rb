require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'json'

def get_data_from_database
  db_config = {
    dbname: 'postgres',
    user: 'rebase',
    password: '123456',
    host: 'rebase-labs-database',
    port: 5432
  }
  conn = PG.connect(db_config)
  result = conn.exec('SELECT * FROM exams')
  conn.close

  data = result.map { |row| row.to_h }
  data.to_json
end

get '/tests' do
  content_type :json
  get_data_from_database
end

get '/hello' do
  'Hello world!'
end

if __FILE__ == $0
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end