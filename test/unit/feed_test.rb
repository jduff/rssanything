require File.dirname(__FILE__) + '/../test_helper'

class FeedTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  
  
  def test_extract_mls
    Net::HTTP.expects(:get).returns(get_content('mls'))
    
    result = feeds(:mls).execute
    
    assert result
    
    assert_equal 10, result.length
    
    assert_equal "$175,000 Sheffield Glen/Ind Park 3705, Ottawa South, Ottawa, Eastern 8, Ontario", result[0][:title]
  
    assert /http:\/\/www\.mls\.com\// =~ result[0][:link]
  end
  
  private
  def get_content(content, type='html')
    data = File.open(File.dirname(__FILE__) + "/../test_content/#{content}.#{type}",'rb').read
  end
  
end
