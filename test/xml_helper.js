module.exports = (function() {
  function attrToS(name, attr) {
    if (!attr)
      return '';
    return '[' + name + '=' + attr + ']';
  }
  function cToS(cls){
      if (!cls)
        return '';
      return cls.split(' ').reduce(function(prev, current) {
        return prev + '.' + current.trim();
      }, '');
    }
    function idToS(ids){
      if (!ids)
        return '';
      return ids.split(' ').reduce(function(prev, current) {
        return prev + '#' + current.trim();
      }, '');
    }
  return {
    toA: function toA(raw_node) {
      if (raw_node.type == 'tag') {
        return [ raw_node.name +
                 cToS(raw_node.attribs['class']) +
                 idToS(raw_node.attribs.id)].concat(
                   raw_node.children.map(function(elem) {
                     return toA(elem);
                   }).filter(function(elem) {
                     return elem;
                   }));
      } else if (raw_node.type == 'text') {
        if (raw_node.data.trim()) {
          return raw_node.data;
        } else {
          return null;
        }
      }
    }
  };
})();
