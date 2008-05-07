xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do

   xml.title @feed.title
   xml.link  @feed.link
   xml.description @feed.description

   @items.each do |item|
     xml.item do
       xml.title item.title
       xml.link item.link
       xml.description item.content
       xml.guid item.guid
     end
   end

 end
end