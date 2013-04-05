require 'spec_helper'

describe 'for bizacoras' do
  it 'will work if using the proper address', :driver => :webkit do
    visit('http://bizacoras.net/')

    page.should have_selector 'div.box_main'

    page.all('.entry_item').count.should be 100
  end

end