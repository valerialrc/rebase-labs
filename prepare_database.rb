require 'csv'
require 'pg'

def table_exists?(conn)
  result = conn.exec("SELECT EXISTS (
                      SELECT FROM information_schema.tables 
                      WHERE table_name = 'exams'
                      )")
  result.getvalue(0, 0) == 't' # 't' é o valor retornado se a tabela existir
end

db_config = {
  dbname: 'postgres',
  user: 'rebase',
  password: '123456',
  host: 'rebase-labs-database',
  port: 5432
}

conn = PG.connect(db_config)

if table_exists?(conn)
  puts "A tabela 'exams' já existe. Interrompendo o script."
  conn.close
  exit
end

conn.exec(<<-SQL)
  CREATE TABLE IF NOT EXISTS exams (
    id SERIAL PRIMARY KEY,
    patient_cpf VARCHAR(14),
    patient_name VARCHAR(100),
    patient_email VARCHAR(100),
    patient_birthdate DATE,
    patient_address VARCHAR(255),
    patient_city VARCHAR(100),
    patient_state VARCHAR(100),
    doctor_crm VARCHAR(20),
    doctor_crm_state VARCHAR(2),
    doctor_name VARCHAR(100),
    doctor_email VARCHAR(100),
    result_token VARCHAR(10),
    exam_date DATE,
    exam_type VARCHAR(100),
    exam_limits VARCHAR(20),
    exam_result VARCHAR(255)
  )
SQL

insert_values = []

rows = CSV.read("./data.csv", col_sep: ';', headers: true)

rows.each do |row|
  patient_cpf = row['cpf']
  patient_name = row['nome paciente']
  patient_email = row['email paciente']
  patient_birthdate = row['data nascimento paciente']
  patient_address = row['endereço/rua paciente']
  patient_city = row['cidade paciente']
  patient_state = row['estado patiente']
  doctor_crm = row['crm médico']
  doctor_crm_state = row['crm médico estado']
  doctor_name = row['nome médico']
  doctor_email = row['email médico']
  result_token = row['token resultado exame']
  exam_date = row['data exame']
  exam_type = row['tipo exame']
  exam_limits = row['limites tipo exame']
  exam_result = row['resultado tipo exame']

  insert_values << "(#{conn.escape_literal(patient_cpf)}, #{conn.escape_literal(patient_name)}, #{conn.escape_literal(patient_email)}, #{conn.escape_literal(patient_birthdate)}, #{conn.escape_literal(patient_address)}, #{conn.escape_literal(patient_city)}, #{conn.escape_literal(patient_state)}, #{conn.escape_literal(doctor_crm)}, #{conn.escape_literal(doctor_crm_state)}, #{conn.escape_literal(doctor_name)}, #{conn.escape_literal(doctor_email)}, #{conn.escape_literal(result_token)}, #{conn.escape_literal(exam_date)}, #{conn.escape_literal(exam_type)}, #{conn.escape_literal(exam_limits)}, #{conn.escape_literal(exam_result)})"
end

insert_query = <<-SQL
  INSERT INTO exams (patient_cpf, patient_name, patient_email, patient_birthdate, patient_address, patient_city, patient_state, doctor_crm, doctor_crm_state, doctor_name, doctor_email, result_token, exam_date, exam_type, exam_limits, exam_result)
  VALUES #{insert_values.join(', ')}
SQL

conn.exec(insert_query)

conn.close
