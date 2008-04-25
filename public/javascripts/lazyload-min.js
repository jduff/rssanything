/*
Copyright (c) 2007 Ryan Grove <ryan@wonko.com>. All rights reserved.
Licensed under the New BSD License:
http://www.opensource.org/licenses/bsd-license.html
Version: 1.0.3
*/
var LazyLoad=function(){var pending=null;var queue=[];return{load:function(urls,callback,obj,scope){var request={urls:urls,callback:callback,obj:obj,scope:scope};if(pending){queue.push(request);return;}
pending=request;urls=urls.constructor===Array?urls:[urls];var script;for(var i=0;i<urls.length;i+=1){script=document.createElement('script');script.src=urls[i];document.body.appendChild(script);}
if(!script){return;}
if((/msie/i).test(navigator.userAgent)&&!(/AppleWebKit\/([^ ]*)/).test(navigator.userAgent)&&!(/opera/i).test(navigator.userAgent)){script.onreadystatechange=function(){if(this.readyState==='loaded'){LazyLoad.requestComplete();}};}else{script=document.createElement('script');script.appendChild(document.createTextNode('LazyLoad.requestComplete();'));document.body.appendChild(script);}},loadOnce:function(urls,callback,obj,scope,force){var newUrls=[],scripts=document.getElementsByTagName('script');urls=urls.constructor===Array?urls:[urls];for(var i=0;i<urls.length;i+=1){var loaded=false,url=urls[i];for(var j=0;j<scripts.length;j+=1){if(url===scripts[j].src){loaded=true;break;}}
if(!loaded){newUrls.push(url);}}
if(newUrls.length>0){this.load(newUrls,callback,obj,scope);}else if(force){if(obj){if(scope){callback.call(obj);}else{callback.call(window,obj);}}else{callback.call();}}},requestComplete:function(){if(pending.callback){if(pending.obj){if(pending.scope){pending.callback.call(pending.obj);}else{pending.callback.call(window,pending.obj);}}else{pending.callback.call();}}
pending=null;if(queue.length>0){var request=queue.shift();this.load(request.urls,request.callback,request.obj,request.scope);}}};}();