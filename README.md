# Rebase Labs

Projeto desenvolvido durante o Rebase Labs, ofertado para a turma 11 do TreinaDev.

A finalidade do sistema é compor uma interface de consulta à resultados de exames médicos. O banco de dados do sistema é previamente populado através de um arquivo CSV. O usuário final pode também importar outros arquivos CSVs com resultados de exames, contanto que o arquivo obedeça à configuração padrão (checar o arquivo ['data.csv'](https://github.com/valerialrc/rebase-labs/blob/main/data.csv) na raiz deste projeto). É possível pesquisar exames através do seu Token e também acessá-los diretamente clicando em um Token da lista na home.

## Tecnologias
- Ruby
- Sinatra
- Puma
- Rack
- Rackup
- Postgres
- Rspec
- Capybara
- Selenium Webdriver
- Sidekiq
- Redix
- Docker Compose

## Requisito
Para iniciar a instalação do sistema, é necessário instalar o [Docker Compose](https://docs.docker.com/compose/).

## Criar containers
```bash
docker-compose up -d
```

## Testar
Execute o container do servidor:
```bash
docker-compose exec rebase-labs-server bash
```

Digite o comando:
```bash
rspec
```

## Verificar enfileiramento de Jobs
```bash
docker-compose exec rebase-labs-server sidekiq -r ./import_csv_job.rb 
```

## Endpoints
```bash
GET /tests
```

```bash
GET /tests/:token
```

```bash
GET /home
```

```bash
POST /import
```
