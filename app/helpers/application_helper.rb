# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def bookmarklet_link
    script = "javascript:var HOST = '#{request.host_with_port}';"
    #throw in the lazy load script so it can be used to load everything else
    script << "var lazy = document.createElement('SCRIPT');"
    script << "lazy.src = 'http://#{request.host_with_port}/javascripts/lazyload-min.js?' + Math.random();"
    script << "lazy.type = 'text/javascript';"
    script << "var head = document.getElementsByTagName('HEAD')[0];"
    script << "head.appendChild(lazy);void(0);"
    #load the main bookmarklet script
    script << "var script = document.createElement('SCRIPT');"
    script << "script.src = 'http://#{request.host_with_port}/javascripts/bookmarklet.js?' + Math.random();"
    script << "script.type = 'text/javascript';"
    script << "var head = document.getElementsByTagName('HEAD')[0];"
    script << "head.appendChild(script);void(0);"
  end
end
