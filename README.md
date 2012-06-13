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

deps = 

    jQuery:
        url: "..."
        unless: -> jQuery?

    jQueryUI:
        url: "..."
        depends: deps.jQuery

    app:
        url: "..."
        depends: [deps.jQuery, deps.jQueryUI]

dependa(deps, -> alert 'loaded'