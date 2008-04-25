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
		$$('.RSSAnything_matched_element').each(function(element) {
			element.removeClassName('RSSAnything_matched_element');
		});
		
		if(RSSAnything.highlightedNode != null)
			RSSAnything.highlightedNode.removeClassName('RSSAnything_highlighted_element');

		RSSAnything.highlightedNode = RSSAnything.getSourceElement(event);
		
		var pattern = RSSAnything.buildPattern(RSSAnything.highlightedNode);
		
		RSSAnything.highlightedNode.addClassName('RSSAnything_highlighted_element');
		
		console.log(pattern);
		
		$$(pattern).each(function(element) {
			if(RSSAnything.highlightedNode != element) {
				element.addClassName('RSSAnything_matched_element');
			}
		});
	},
	
	highlightedNode: null,
	
	buildPattern: function(element) {
		var pattern = element.tagName;
		
		$w(element.className).each(function(item) {
			pattern = pattern + "." + item;
		});
		
		var attributes = element.attributes;
		for(var i =0; i < attributes.length; i++) {
			if(attributes[i].name != 'class' && attributes[i].name != 'href'&& attributes[i].name != 'id')
			{
				pattern = pattern + '[' + attributes[i].name + '="' + attributes[i].value + '"]'
			}
		}
		return pattern;
	},
	
	selectCurrentElement: function(event) {
		
	},
	
	addWindow: function() {
		var mainDiv = new Element('div', { 'class': 'RSSAnything_main'}).update("RSSAnything");
		var form = new Element('form');
		var title = new Element('input', {'name': 'RSSAnything_title_matcher'});
		
		form.appendChild(title);
		mainDiv.appendChild(form);
		parent.document.body.insertBefore(mainDiv, parent.document.body.firstChild);
		
	},

	loadComplete: function() {
		//RSSAnything.addWindow();
		
		
		
		parent.document.onmouseover = parent.RSSAnything.highlightArea;
		//parent.document.onmousedown = parent.RSSAnything.selectCurrentElement;
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

