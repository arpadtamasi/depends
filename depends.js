// Generated by CoffeeScript 1.3.3

this.depends = function(dependency, onload) {
  var loadarray, loadscript, loadtree, observe, scripts;
  observe = function(script, callback) {
    var loaded;
    loaded = function() {
      this.onload = this.onreadystatechange = null;
      return callback && callback();
    };
    if (script.readyState) {
      return script.onreadystatechange = function() {
        if (this.readyState === 'loaded' || this.readyState === 'complete') {
          return loaded();
        }
      };
    } else {
      return script.onload = function() {
        return loaded();
      };
    }
  };
  loadscript = function(url, callback) {
    var script;
    script = document.createElement('script');
    observe(script, callback);
    script.src = url;
    document.getElementsByTagName("head")[0].appendChild(script);
    return script;
  };
  loadarray = function(array, i, callback) {
    if (i < array.length - 1) {
      return loadtree(array[i], function() {
        return loadarray(array, i + 1, callback);
      });
    } else {
      return loadtree(array[i], callback);
    }
  };
  loadtree = function(tree, callback) {
    var id, loadurl;
    if (typeof tree === 'string') {
      id = tree.replace(/.+\/|\.min\.js|\.js|\?.+|\W/gi, '');
      if (!(scripts[id] != null)) {
        return scripts[id] = loadscript(tree, callback);
      }
    } else if (tree instanceof Array) {
      return loadarray(tree, 0, callback);
    } else if (tree.url != null) {
      loadurl = function() {
        return loadtree(tree.url, function() {
          return callback && callback();
        });
      };
      if (!(tree.unless != null) || (typeof tree.unless === 'function' && !tree.unless())) {
        if (!(tree.depends != null)) {
          return loadurl();
        } else {
          return loadtree(tree.depends, loadurl);
        }
      } else {
        return callback && callback();
      }
    }
  };
  scripts = {};
  loadtree(dependency, typeof onload === 'function' ? onload : void 0);
};
