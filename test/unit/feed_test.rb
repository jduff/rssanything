require File.dirname(__FILE__) + '/../test_helper'

class FeedTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  
  def test_extract_mls
    Net::HTTP.any_instance.expects(:get2).at_least(0).returns([nil, get_content('mls')])
    
    result = feeds(:mls).execute
    
    assert result
    
    assert_equal 10, result.length
    
    assert_equal "$175,000 Sheffield Glen/Ind Park 3705, Ottawa South, Ottawa, Eastern 8, Ontario", result[0].title
  
    result.each do |item|
      assert !item.content.blank?
      assert !item.link.blank?
      assert !item.guid.blank?
    end
  
    assert /http:\/\/www\.mls\.com\// =~ result[0].link
  end
  
  def test_extract_mls2
    Net::HTTP.any_instance.expects(:get2).at_least(0).returns([nil, get_content('mls2')])
    
    result = feeds(:mls).execute
    
    assert result
    
    assert_equal 10, result.length
    
    assert_equal "$184,000 Carlington 5301, Ottawa West, Ottawa, Eastern 8, Ontario", result[1].title
  
    result.each do |item|
      assert !item.content.blank?
      assert !item.link.blank?
      assert !item.guid.blank?
    end
  
    assert /http:\/\/www\.mls\.com\// =~ result[0].link
  end

end
