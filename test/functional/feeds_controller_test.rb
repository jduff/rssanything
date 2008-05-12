require File.dirname(__FILE__) + '/../test_helper'

class FeedsControllerTest < ActionController::TestCase
  # Replace this with your real tests.


  def test_show_feed
    Net::HTTP.any_instance.expects(:get2).at_least(0).returns([nil, get_content('mls')])
    
    assert_equal 2, feeds(:mls).items.length
    
    get :show, :id => feeds(:mls).id
    
    assert_equal 11, assigns(:feed).items.length
  end
end
