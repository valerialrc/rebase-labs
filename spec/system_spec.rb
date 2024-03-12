require 'spec_helper'
require 'capybara/rspec'
require './server.rb'

describe 'System', type: :system, js: true do
  it 'should render home page with form' do
    visit '/home'
    expect(page).to have_content('Exames')
    expect(page).to have_css('form#test-form')
    expect(page).to have_css('label[for="token"]')
    expect(page).to have_css('input#token')
    expect(page).to have_css('button#search-button', text: 'Buscar Exames')
    expect(page).to have_content('IQCZ17')
  end

  it 'should show details after submitting form' do
    visit '/home'
    fill_in 'token', with: 'IQCZ17'
    click_button 'Buscar Exames'
    expect(page).to have_content('Resultado do exame IQCZ17')
  end
end
