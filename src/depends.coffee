# Loads dependencies
depends = (dependency, onload) ->
	# Loads an array of dependencies. Async iteration, invoke callback after the last one.
	loadarray = (array, i, callback) -> if i >= array.length - 1 then loadtree(array[i], callback) else loadtree(array[i], -> loadarray(array, i+1, callback))
			
	# Loads a dependency tree
	loadtree = (tree, callback) ->
		# Loads the url if it is a leaf
		if typeof tree == 'string'
			id = tree.replace(/.+\/|\.min\.js|\.js|\?.+|\W/gi, '')
			if !scripts[id]?
				scripts[id] = script = document.createElement('script')
				script.onload = script.onreadystatechange = () -> if !@readyState? || /^complete$|^loaded$/.test @readyState
					@onload = @onreadystatechange = null
					callback && callback()
				script.src = tree
				document.getElementsByTagName("head")[0].appendChild(script)

		# By loadarray if it is an array
		else if tree instanceof Array
			loadarray(tree, 0, callback)

		# Otherwise it must be a dependency object
		else if tree.url?
			# Loads the url as a leaf
			loadurl = () ->	loadtree(tree.url, () -> callback && callback())
			# Test unless if given
			if !tree.unless? || (typeof tree.unless == 'function' && !tree.unless())
				if !tree.depends? then loadurl() else loadtree(tree.depends, loadurl)
			# If true then just invoke callback
			else callback && callback()

	scripts = {}

	# Start tree loading
	loadtree(dependency, onload if typeof onload == 'function')
	return

