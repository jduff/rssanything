class FeedsController < ApplicationController
  
  def index
    @feeds = Feed.find(:all)
  end
  
  def new
    pp params
    
    feed = Feed.new(:title => params[:url].gsub('[', '[@'), :link => params[:url].gsub('[', '[@'), 
            :link_regexp => params[:link].gsub('[', '[@'), :title_regexp => params[:title].gsub('[', '[@'), 
            :content_regexp => params[:content].gsub('[', '[@'))
            
    feed.save!
    
    redirect_to :action => :show, :id => feed.id
  end
  
  def show
    @feed = Feed.find_by_id(params[:id])
    
    parsed_items = @feed.execute

    existing_items = Item.find(:all, 
      :conditions => ["feed_id =? and guid in (?)", @feed.id, parsed_items.collect(&:guid)])


    existing_items.collect!(&:guid) unless existing_items.empty?

    new_items = parsed_items.reject {|item| existing_items.include?(item.guid)}

    @feed.items << new_items unless new_items.empty?

    @feed.last_published = Time.now

    @feed.save unless new_items.empty?
    
    @items = Item.find(:all, :conditions => ["feed_id = ?", @feed.id], 
      :order => "created_at DESC")
    
    respond_to do |format|
      format.xml
    end
  end
  
  
end
