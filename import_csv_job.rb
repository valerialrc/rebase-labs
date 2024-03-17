require 'sidekiq'
require 'sidekiq/web'
require_relative 'import'

class CSVImportJob
  include Sidekiq::Job

  def perform(csv_data)
    import_csv_to_database(csv_data)
  end
end
