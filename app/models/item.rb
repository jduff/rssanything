class Item < ActiveRecord::Base
  belongs_to :feed
  
  def ==(other)
    guid == other.guid
  end
end
