this.depends = (dependency, onload) ->
	observe = (script, callback) ->
		loaded = () -> 
			this.onload = this.onreadystatechange = null
			callback() if typeof callback == 'function'	

		if script.readyState
			script.onreadystatechange = () -> loaded() if this.readyState is 'loaded' or this.readyState is 'complete'
		else
			script.onload = () -> loaded()

	name = (url) -> url.replace(/.+\/|\.min\.js|\.js|\?.+|\W/gi, '')

	loadscript = (url, callback) ->
		script = document.createElement('script')
		script.type = 'text/javascript'
		observe(script, callback)
		script.src = url
		document.getElementsByTagName("head")[0].appendChild(script)
		script

	loadarray = (array, i, callback) ->
		if i < array.length - 1
			loadtree(array[i], () ->
				loadarray(array, i+1, callback)
			)
		else
			loadtree(array[i], callback)

	loadtree = (tree, callback) ->
		if tree instanceof Array
			loadarray(tree, 0, callback)
		else if typeof tree == 'string'
			id = name(tree)
			if !scripts[id]?
				scripts[id] = loadscript(tree, callback)
		else if tree.url?
			loadurl = () ->
				loadtree(tree.url, () ->
					callback() if typeof callback == 'function'
				)
			if !tree.unless? || (typeof tree.unless == 'function' && !tree.unless())
				if !tree.depends?
					loadurl()					
				else
					loadtree(tree.depends, loadurl)
			else
				callback() if typeof callback == 'function'

	scripts = {}
	loadtree(dependency, onload)
	return

