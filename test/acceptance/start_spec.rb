require_relative 'acceptance_helper'

describe('Start page', :type => :feature) do

  before do
    visit '/'
  end

  it 'responds with successful status' do
    page.status_code.should == 200
  end

  it 'shows the welcome message', :driver => :selenium do
    page.should have_content 'Hello Sinatra Skeleton!'
  end

end