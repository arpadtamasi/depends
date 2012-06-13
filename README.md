depends
=======

Another javascript dependency loader

A dependency can be:

	- The url of a script

	- An array of dependencies
	
	- A dependency object with the following attributes
	
		- url: the url of a script
	
		- depends: any kind of dependency (url, array or a dependency object)
	
		- unless: a function that returns false if the url has to be loaded

Example



    deps = {}

    deps.jQuery = 
        url: "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
        unless: -> jQuery?

    deps.jQueryUI = 
        url: "https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"
        depends: deps.jQuery

    deps.autoNumeric =
      url: "js/lib/autoNumeric.js"
      depends: deps.jQuery
      unless: -> window.formatNumber?

    deps.app = 
        url: "js/lib/konfigurator.js"
        depends: [deps.jQuery, deps.jQueryUI, deps.autoNumeric]

    depends(deps.app, () -> alert 'loaded')
