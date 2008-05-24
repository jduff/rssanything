desc "refresh all the feeds"
task :refresh_feeds => [ :environment ] do | t |
  puts "starting to rebuild feeds"
  feeds = Feed.find(:all)
  feeds.each do |feed|
    puts "refreshing feed, id: #{feed.id}"
    feed.refresh
  end
  puts "done refreshing feeds"
end