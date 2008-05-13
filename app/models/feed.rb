require "net/http"
require "uri"
require "hpricot"

class Feed < ActiveRecord::Base
  has_many :items
  
  def self.refresh(feed)
    feed = feed.is_a?(Feed) ? feed : Feed.find_by_id(id)
    
    parsed_items = feed.execute

    existing_items = Item.find(:all, :select =>"guid",
      :conditions => ["feed_id =? and guid in (?)", feed.id, parsed_items.collect(&:guid)])

    existing_items.collect!(&:guid) unless existing_items.empty?

    new_items = parsed_items.reject {|item| existing_items.include?(item.guid)}

    feed.items << new_items unless new_items.empty?

    feed.last_published = Time.now

    feed.save unless new_items.empty?
  end

  def execute
    doc = Hpricot(fetch_page(link))
    pages = []
    
    if !more_regexp.blank?
      links = doc.search(more_regexp)[0].search("a[@href]").collect do |link|
        fix_relative_url(link.attributes["href"])
      end.uniq
      
      1.upto([links.length, more].sort[0]) do |i|
        pages << Hpricot(fetch_page(links[i-1]))
      end
    end
    pages << doc
    
    items = pages.collect { |page| parse_page(page) }.flatten.uniq
  end
  
  def parse_page(doc)
    links = doc.search(link_regexp).collect do |link|
      fix_relative_url(link.search("a[@href]").first.attributes["href"])
    end
    
    titles = doc.search(title_regexp).collect do |title|
      clean(title.to_s)
    end
    
    contents = doc.search(content_regexp).collect do |content|
      absolutize_links(content).to_s #make all links absolute
    end
    
    items = []
    links.each_index do |i|
      items << Item.new({:link=>links[i], :title=>titles[i], :content=>contents[i], :guid=>links[i].hash})
    end
    
    items
  end
  
  private
  def fetch_page(link)
    uri = URI.parse(link)
    path_with_query = uri.query.blank? ? uri.path : (uri.path + "?" + uri.query)
    
    response, html = Net::HTTP.new(uri.host, uri.port).get2(path_with_query, HEADERS)
    return html
  end
  
  # parses through the html nodes, finds the links and fixes any that are relative
  def absolutize_links(node)
    node.search("a") do |item|
      item.attributes["href"] = fix_relative_url(item.attributes["href"])
    end
  end
  
  # pull out html tags, get rid of new lines, remove extra spaces
  def clean(string)
    return "NO TITLE FOUND" if string == nil
    string = string.gsub(/<\/?[^>]*>/, "").gsub("\n", " ").gsub("\t", " ").squeeze(" ").strip
    return string.blank? ? "NO TITLE FOUND" : string
  end
  
  # some sites use relative urls, these wont work when clicking on them from the rss feed so
  # need to make them absolute
  def fix_relative_url(url)
    begin
      return URI.join(self.link, url).to_s if URI.parse(url).host.nil? && !URI.join(self.link, url).host.nil?
    rescue
    end
    return url
  end
  
  HEADERS = {
    'Accept' => '*/*',
    'Accept-Language' => 'en-ca',
    'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322)'
  }
end
