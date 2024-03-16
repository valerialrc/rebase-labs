def db_config
  if ENV['RACK_ENV'] == 'test'
    {
      dbname: 'postgres',
      user: 'rebase',
      password: '123456',
      host: 'rebase-labs-database-test',
      port: 5432
    }
  else
    {
      dbname: 'postgres',
      user: 'rebase',
      password: '123456',
      host: 'rebase-labs-database',
      port: 5432
    }
  end
end