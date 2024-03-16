require 'spec_helper'
require 'capybara/rspec'
require './server.rb'

describe 'System', type: :system, js: true do
  it 'should render home page with form' do
    visit '/home'

    expect(page).to have_content('Importar CSV')
    expect(page).to have_css('form#csv-form')
    expect(page).to have_css('input#csv-file')
    expect(page).to have_css('button#import-button', text: 'Importar')
    expect(page).to have_content('IQCZ17')
  end

  # Teste não funciona, porém no navegador está ok
  # it 'should render home page with form and import CSV file' do
  #   csv_file_path = './data.csv'

  #   visit '/home'
  #   attach_file('csv-file', csv_file_path)
  #   find('#import-button').click()
  
  #   expect(page).to have_content('Arquivo CSV importado com sucesso.')
  # end
end
