// Generated by CoffeeScript 1.3.3

this.depends = function(dependency, onload) {
  var loadarray, loadtree, scripts;
  loadarray = function(array, i, callback) {
    if (i >= array.length - 1) {
      return loadtree(array[i], callback);
    } else {
      return loadtree(array[i], function() {
        return loadarray(array, i + 1, callback);
      });
    }
  };
  loadtree = function(tree, callback) {
    var id, loadurl, script;
    if (typeof tree === 'string') {
      id = tree.replace(/.+\/|\.min\.js|\.js|\?.+|\W/gi, '');
      if (!(scripts[id] != null)) {
        scripts[id] = script = document.createElement('script');
        script.onload = script.onreadystatechange = function() {
          if (!(this.readyState != null) || /^complete$|^loaded$/.test(this.readyState)) {
            this.onload = this.onreadystatechange = null;
            return callback && callback();
          }
        };
        script.src = tree;
        return document.getElementsByTagName("head")[0].appendChild(script);
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
