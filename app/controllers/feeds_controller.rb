class FeedsController < ApplicationController
  
  def index
    @feeds = Feed.find(:all)
  end
  
  def new
    
    feed = Feed.new(:title => params[:url].gsub('[', '[@'), :link => params[:url].gsub('[', '[@'), 
            :link_regexp => params[:link].gsub('[', '[@'), :title_regexp => params[:title].gsub('[', '[@'), 
            :content_regexp => params[:content].gsub('[', '[@'))
            
    feed.save!
    
    redirect_to :action => :show, :id => feed.id
  end
  
  def show
    @feed = Feed.find_by_id(params[:id])
    
    Feed.async_send :refresh, params[:id]
    #Feed.send :refresh, params[:id]
    
    @items = Item.find(:all, :conditions => ["feed_id = ?", params[:id]], 
      :order => "created_at DESC")
    
    respond_to do |format|
      format.xml
    end
  end
  
  
end
