var RSSAnything = {
	scripts: new Array(	'http://' + HOST + '/javascripts/prototype.js',
  										'http://' + HOST + '/javascripts/effects.js',
											'http://' + HOST + '/javascripts/window.js' ),
												
	styles:  new Array( 'http://' + HOST + '/stylesheets/default.css', 
											'http://' + HOST + '/stylesheets/mac_os_x.css',
											'http://' + HOST + '/stylesheets/bookmarklet.css'),

	loadStyleSheets: function() {
		for(i = 0; i < RSSAnything.styles.length; i++) {
	    RSSAnything.loadStyleSheet(RSSAnything.styles[i]);
	  }
	},

	loadStyleSheet: function(src) {
		var style = document.createElement("LINK");
	  style.setAttribute("rel", "stylesheet");
	  style.setAttribute("type", "text/css");
	  style.setAttribute("href", src + "?" + Math.random());
	  document.getElementsByTagName("HEAD")[0].appendChild(style);
	},

	getSourceElement: function(event) {
		if(!document.addEventListener) var eventSource = window.event.srcElement;
		else var eventSource = event.target;
		return eventSource;
	},
	
	highlightArea: function(event) {
		var currentNode = RSSAnything.getSourceElement(event);
		if(currentNode.hasClassName('RSSAnything') || currentNode.tagName == "BODY" || currentNode.tagName == "HTML")
			return;
		
		$$('.RSSAnything_matched_element').each(function(element) {
			element.removeClassName('RSSAnything_matched_element');
		});
		
		if(RSSAnything.highlightedNode != null)
			RSSAnything.highlightedNode.removeClassName('RSSAnything_highlighted_element');

		RSSAnything.highlightedNode = currentNode;
		
		var pattern = RSSAnything.buildPattern(RSSAnything.highlightedNode);
		
		RSSAnything.captures[RSSAnything.current].value = pattern;
		
		RSSAnything.highlightedNode.addClassName('RSSAnything_highlighted_element');
		
		$$(pattern).each(function(element) {
			if(RSSAnything.highlightedNode != element) {
				element.addClassName('RSSAnything_matched_element');
			}
		});
	},
	
	highlightedNode: null,
	
	buildPattern: function(element) {
		var pattern = element.tagName.toLowerCase();
		
		$w(element.className).each(function(item) {
			pattern = pattern + "." + item;
		});
		
		var attributes = element.attributes;
		for(var i =0; i < attributes.length; i++) {
			if(attributes[i].name != 'class' && attributes[i].name != 'href'&& attributes[i].name != 'id' && attributes[i].name != 'src'&& attributes[i].name != 'alt')
			{
				pattern = pattern + '[@' + attributes[i].name + "='" + attributes[i].value + "']"
			}
		}
		return pattern;
	},
	
	selectCurrentElement: function(event) {
		if(RSSAnything.current >= RSSAnything.captures.length-1) {
			parent.document.onmouseover = null;
			$$('.RSSAnything_matched_element').each(function(element) {
				element.removeClassName('RSSAnything_matched_element');
			});

			if(RSSAnything.highlightedNode != null)
				RSSAnything.highlightedNode.removeClassName('RSSAnything_highlighted_element');
			return
		}
		RSSAnything.current = RSSAnything.current + 1;
	},
	
	current: 0,
	captures: new Array(),
	
	testPatterns: function() {
		for(var i = 0; i < RSSAnything.captures.length; i++)
		{
			$$(RSSAnything.captures[i].value).each(function(element) {
				element.addClassName('RSSAnything_matched_element');
			});
		}
	},
	
	addWindow: function() {
		var mainDiv = new Element('div', { 'class': 'RSSAnything_main RSSAnything'}).update("RSSAnything");
		var form = new Element('form', {'class' : 'RSSAnything', 'action' :  'http://' + HOST + '/feeds/new'});
		
		form.appendChild(new Element('input', {'name' : 'url', 'type' : 'hidden', 'value' : parent.document.location.href}))
		
		//Regex for the title
		RSSAnything.captures[0] = new Element('input', {'name': 'title', 'class' : 'RSSAnything'});
		
		var wrapper = new Element('div', {'class' : 'RSSAnything'});
		wrapper.update("Title: ").appendChild(RSSAnything.captures[0]);
		form.appendChild(wrapper);
		
		//Regex for the content
		RSSAnything.captures[1] = new Element('input', {'name': 'content', 'class' : 'RSSAnything'});
		
		var wrapper = new Element('div', {'class' : 'RSSAnything'});
		wrapper.update("Content: ").appendChild(RSSAnything.captures[1]);
		form.appendChild(wrapper);
		
		//Regex for the link
		RSSAnything.captures[2] = new Element('input', {'name': 'link', 'class' : 'RSSAnything'});

		var wrapper = new Element('div', {'class' : 'RSSAnything'});
		wrapper.update("Link: ").appendChild(RSSAnything.captures[2]);
		form.appendChild(wrapper);
		
		//Regex for the more link
		RSSAnything.captures[3] = new Element('input', {'name': 'more', 'class' : 'RSSAnything'});
		
		var wrapper = new Element('div', {'class' : 'RSSAnything'});
		wrapper.update("More Link: ").appendChild(RSSAnything.captures[3]);
		form.appendChild(wrapper);
		
		//submit button
		var wrapper = new Element('div', {'class' : 'RSSAnything', 'text' : 'save'});
		wrapper.appendChild(new Element('input', {'type': 'submit', 'class' : 'RSSAnything'}));
		form.appendChild(wrapper);

		//test button
		var wrapper = new Element('div', {'class' : 'RSSAnything', 'text' : 'test'});
		wrapper.appendChild(new Element('input', {'type': 'button', 'class' : 'RSSAnything', 'onclick' : 'RSSAnything.testPatterns()'}));
		form.appendChild(wrapper);
		
		mainDiv.appendChild(form);
		parent.document.body.insertBefore(mainDiv, parent.document.body.firstChild);
		
	},

	loadComplete: function() {
		RSSAnything.addWindow();
		
		parent.document.onmouseover = parent.RSSAnything.highlightArea;
		parent.document.onmousedown = parent.RSSAnything.selectCurrentElement;
		//parent.document.onmouseup = parent.RSSAnything.getSelectedText;
		// win = new Window({className: "mac_os_x", title: "Sample", width:200, height:150, destroyOnClose: true, recenterAuto:false});
		// win.getContent().update("");
		// win.showCenter();
	},
	
	init: function () {
		RSSAnything.loadStyleSheets();
		LazyLoad.loadOnce(RSSAnything.scripts, RSSAnything.loadComplete);
	}
}

RSSAnything.init();

