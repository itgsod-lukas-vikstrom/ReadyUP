require_relative 'routes_helper'

describe 'Base routes' do

  it 'should allow access to /' do
    get '/'
    last_response.should be_ok
  end

  it 'should not allow access to /grillkorv' do
    get '/grillkorv'
    last_response.should_not be_ok
  end

end