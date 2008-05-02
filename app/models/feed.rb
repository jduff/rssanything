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
    #grab the contents of the page to scrape
    html = Net::HTTP.get(URI.parse(self.link))
    
    #scrape the data we want from the page
    result = page_scraper_for(self.title_regexp, self.link_regexp, self.content_regexp).scrape(html)
    
    items = []
    result.link_array.each_index do |i|
      link = fix_relative_url(result.link_array[i])
      content = absolutize_links(result.content_array[i]).to_s #make all links absolute
      title = clean(result.title_array[i]) #remove html, newlines and extra spaces
      items << {:link => link, :title => title, :content => content}
    end
    
    items

  end
  
  private
  # returns the scraper for the patterns passed in
  def page_scraper_for(title_matcher, link_matcher, content_matcher)
    Scraper.define do
      selector :select_link, "a"
      
      array :title_array
      process title_matcher, :title_array => :text
      
      array :link_array
      process link_matcher, 
        :link_array => Scraper.define {process "a[href]",:link =>"@href";result :link}
      
      process content_matcher do |element|
        @content_array ||= []
        @content_array << element
      end
      attr_accessor :content_array
    end
  end
  
  # parses through the html nodes, finds the links and fixes any that are relative
  def absolutize_links(node)
    sibling = node
    while(sibling = sibling.next_sibling)
      absolutize_links(sibling) if sibling.tag? && sibling.name!="a"
    end
    
    node.children.each do |node| 
      node.attributes["href"] = fix_relative_url(node.attributes["href"]) if node.tag? && node.name=="a"
      absolutize_links(node) if node.tag? && node.name!="a"
    end
  end
  
  # pull out html tags, get rid of new lines, remove extra spaces
  def clean(string)
    string.gsub(/<\/?[^>]*>/, "").gsub("\n", " ").squeeze(" ").strip
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
end
