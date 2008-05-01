require "net/http"
require "uri"
require "scrapi"
Tidy.path = "/usr/lib/libtidy.dylib"

# class ScrapePosts < Scraper::Base
#   #cattr_reader :title_matcher
#   
#   @@title_matcher = ""
#   
#   def initialize(title, source, options=nil)
#     @@title_matcher = title
#     super source, options
#   end
#   
#   
#   array :titles
#   
#   process @@title_matcher, :titles => :text
# 
#   
# end

class Feed < ActiveRecord::Base
  has_many :items
  
  #t.string :title, :description, :link, :link_regexp, :title_regexp, :content_regexp, :more_regexp

  
  def execute
    html = Net::HTTP.get(URI.parse(self.link))
    
    title_matcher = self.title_regexp
    content_matcher = self.content_regexp
    link_matcher = self.link_regexp
    
    links = Scraper.define do
      process "a[href]", :link => "@href"
      
      result :link
    end
    
    scraper = Scraper.define do
      selector :select_link, "a"
      
      array :title_array
      process title_matcher, :title_array => :text
      
      array :link_array
      process link_matcher, :link_array => links
      
      #array :content_array
      process content_matcher do |element|
        @content_array ||= []
        @content_array << element
      end
      attr_accessor :content_array
    end
    
    #scraper = ScrapePosts.new(self.title_regexp, html).scrape
    result = scraper.scrape(html)
    
    items = []
    result.link_array.each_index do |i|
      link = fix_relative_url(result.link_array[i])
      content = parse_links(result.content_array[i]).to_s
      title = clean(result.title_array[i])
      items << {:link => link, :title => title, :content => content}
    end
    
    items[0]

  end
  
  private
  def parse_links(node)
    sibling = node
    while(sibling = sibling.next_sibling)
      parse_links(sibling) if sibling.tag? && sibling.name!="a"
    end
    
    node.children.each do |node| 
      node.attributes["href"] = fix_relative_url(node.attributes["href"]) if node.tag? && node.name=="a"
      parse_links(node) if node.tag? && node.name!="a"
    end
  end
  
  def clean(string)
    string.gsub(/<\/?[^>]*>/, "").gsub("\n", " ").squeeze(" ").strip
  end
  
  def fix_relative_url(url)
    begin
      return URI.join(self.link, url).to_s if URI.parse(url).host.nil? && !URI.join(self.link, url).host.nil?
    rescue
    end
    return url
  end
end
