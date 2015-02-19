require_relative 'acceptance_helper'

describe('room browser', :type => :feature) do

  before do
    DataMapper.auto_migrate!
    Seeder.seed
    visit '/browse'
  end

  it 'shows the group names' do
    expect(page).to have_content 'Dota 2, no noobs'
    expect(page).to have_content 'Double AK+ MM'
    expect(page).to have_content 'T6 Rifts (Paragon >100)'
    expect(page).to have_content 'ADK games'
    expect(page).to have_content 'Please join :('
    expect(page).to have_content 'No-scoping MW2'
  end

  it 'shows the group games' do
    expect(page).to have_content 'Dota 2'
    expect(page).to have_content 'CS:GO'
    expect(page).to have_content 'Diablo 3'
    expect(page).to have_content 'Achtung Die Kurwe'
    expect(page).to have_content 'Diablo 2'
    expect(page).to have_content 'Call of Duty'
  end

  it 'should filter empty & full groups', :driver => :selenium do
    expect(page).to have_content 'No-scoping MW2'
    expect(page).to have_content 'ADK games'
    page.check('no_empty_groups')
    expect(page).to have_no_content 'No-scoping MW2'
    page.check('no_full_groups')
    expect(page).to have_no_content 'ADK games'
  end

  it 'should not show private rooms' do
    expect(page).to have_no_content 'Heroes of Newerth'
  end

end
