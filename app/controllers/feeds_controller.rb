class FeedsController < ApplicationController
  
  def index
  end
  
  def new
    pp params
    
    feed = Feed.new(:title => params[:url], :link => params[:url], :link_regexp => params[:link], 
            :title_regexp => params[:title], :content_regexp => params[:content])
            
    feed.save!
    
    redirect_to :action => :show, :id => feed.id
  end
  
  def show
    @feed = Feed.find_by_id(params[:id])
    
    @feed.execute
    
    pp @feed
  end
  
  
end
