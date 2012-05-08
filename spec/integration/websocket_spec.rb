require 'spec_helper'

describe 'the bug', :js => true do
  it 'has problems with websocket protocols' do
    visit '/'
    page.find('#websocket-content').text.should == 'pass'
  end
end

