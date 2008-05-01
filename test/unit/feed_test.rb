require File.dirname(__FILE__) + '/../test_helper'

class FeedTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  
  
  def test_extract_mls
    Net::HTTP.expects(:get).returns(get_content('mls'))
    
    result = feeds(:mls).execute
    
    assert result
    pp result
  
  end
  
  private
  def get_content(content, type='html')
    data = File.open(File.dirname(__FILE__) + "/../test_content/#{content}.#{type}",'rb').read
  end
  
end
