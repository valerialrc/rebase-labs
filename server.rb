require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'json'

# Método para consultar o banco de dados e retornar os resultados em JSON
def get_data_from_database
  # Configurações do banco de dados PostgreSQL
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

  # Converter os resultados em um formato JSON
  data = result.map { |row| row.to_h }
  data.to_json
end

# Endpoint para obter dados do banco de dados e retorná-los como JSON
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