# Loads dependencies
this.depends = (dependency, onload) ->
	# Observe script loading and invoke callback when ready
	observe = (script, callback) ->
		loaded = () -> 
			this.onload = this.onreadystatechange = null
			callback && callback()

		if script.readyState
			script.onreadystatechange = () -> loaded() if this.readyState is 'loaded' or this.readyState is 'complete'
		else
			script.onload = () -> loaded()

	# Loads a script from the given url then invoke callback
	loadscript = (url, callback) ->
		script = document.createElement('script')
		observe(script, callback)
		script.src = url
		document.getElementsByTagName("head")[0].appendChild(script)
		script

	# Loads an array of dependencies. Async iteration, invoke callback after the last one.
	loadarray = (array, i, callback) ->
		if i < array.length - 1
			loadtree(array[i], () ->
				loadarray(array, i+1, callback)
			)
		else
			loadtree(array[i], callback)

	# Loads a dependency tree
	loadtree = (tree, callback) ->
		# By loadscript if it is a leaf
		if typeof tree == 'string'
			id = tree.replace(/.+\/|\.min\.js|\.js|\?.+|\W/gi, '')
			scripts[id] = loadscript(tree, callback) if !scripts[id]?
				
		# By loadarray if it is an array
		else if tree instanceof Array
			loadarray(tree, 0, callback)

		# Otherwise it must be a dependency object
		else if tree.url?
			# Load the url
			loadurl = () ->	loadtree(tree.url, () ->
				callback && callback()
			)

			# Test unless if given
			if !tree.unless? || (typeof tree.unless == 'function' && !tree.unless())
				if !tree.depends? then loadurl() else loadtree(tree.depends, loadurl)
			# If true then just invoke callback
			else callback && callback()

	scripts = {}

	# Start tree loading
	loadtree(dependency, onload if typeof onload == 'function')
	return

