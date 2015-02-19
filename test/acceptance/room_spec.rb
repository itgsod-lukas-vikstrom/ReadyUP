require_relative 'acceptance_helper'

describe('group room', :type => :feature) do

  before do
    DataMapper.auto_migrate!
    Seeder.seed
    visit '/room/417kd4cyfs'
  end

  it 'should remove a user' do
    click_link_or_button('remove_button')
    expect(page).to have_no_content 'Stefan'
  end

  it 'should check in' do
    click_link_or_button('checkin_button')
    expect(page).to have_content 'Ludwig'
  end

  it 'should check out' do
    click_link_or_button('checkout_button')
    expect(page).to have_no_content 'Ludwig'
  end

end