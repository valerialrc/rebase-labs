require 'sinatra'
require 'rack/handler/puma'
require 'pg'
require 'json'
require 'csv'
require_relative 'db_config.rb'
require_relative 'import_csv_job.rb'

def get_details_by_token(token)
  conn = PG.connect(db_config)
  result = conn.exec("SELECT * FROM exams WHERE result_token ILIKE '#{token}'")
  conn.close

  return '[]' if result.ntuples.zero?

  exam = {
    "result_token": result[0]['result_token'],
    "exam_date": result[0]['exam_date'],
    "patient_cpf": result[0]['patient_cpf'],
    "patient_name": result[0]['patient_name'],
    "patient_email": result[0]['patient_email'],
    "patient_birthdate": result[0]['patient_birthdate'],
    "patient_address": result[0]['patient_address'],
    "patient_city": result[0]['patient_city'],
    "patient_state": result[0]['patient_state'],
    "doctor": {
      "doctor_crm": result[0]['doctor_crm'],
      "doctor_crm_state": result[0]['doctor_crm_state'],
      "doctor_name": result[0]['doctor_name']
    },
    "tests": result.map do |row|
      {
        "type": row['exam_type'],
        "limits": row['exam_limits'].split('-').join(' to '),
        "result": row['exam_result']
      }
    end
  }

    exam.to_json
end

def get_data_from_database
  conn = PG.connect(db_config)
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

post '/import' do
  begin
    data = params[:csv_file][:tempfile]

    csv_content = CSV.read(data, col_sep: ';', headers: true)

    data_hash = csv_content.map(&:to_h)

    CSVImportJob.perform_async(data_hash)

    "Arquivo CSV importado com sucesso."
  rescue StandardError => e
    status 500
    "Erro ao importar o arquivo CSV: #{e.message}"
  end

end

if __FILE__ == $0
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end