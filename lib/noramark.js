module.exports = function() {
  var parser = require("./parser.js");

  function preprocessNode(node) {
    switch(node.type) {
    case 'Paragraph':
      node.name = 'p';
      break;
    case 'ParagraphGroup':
      node.name = 'div';
      node.classes = [ 'pgroup' ];
      break;
    case 'Page':
      node.name = 'body';
      break;
    case 'Document':
      node.transparent = true;
      break;
    }
  }
  function attrString(name, attrs) {
    if (!attrs || attrs.length === 0) return '';
    return " " + name + "=\"" + attrs.join(' ') + "\" ";
  }
  function generateTag(node) {
    preprocessNode(node);
    if (node.type == 'text')
      return node.content;
    var r = '';
    if (!node.transparent)
      r += "<" + node.name + attrString('class', node.classes) + ">";
    r = node.raw_content.reduce(function(prev, current) {
        return prev + generateTag(current);
      }, r);
    if (!node.transparent)
      r += "</" + node.name + ">\n";
    return r;
  }
  function generateHtml(parsed) {
    if (!parsed)
      parsed = noramark.parsedResult;
    return '<html>' + generateTag(parsed) + '</html>';
  }

  noramark = {
    parsedResult: null,
    parse: function parse(source) {
      noramark.parsedResult = parser.parse(source);
      return noramark.parsedResult;
    },
    generators: {
      html: generateHtml
    }
  };
  return noramark;
}();
