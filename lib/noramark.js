module.exports = function() {
  var parser = require("./parser.js");
  function generateHtml(parsed) {
    if (!parsed)
      parsed = noramark.parsedResult;
    return parsed;
  }

  noramark = {
    parsedResult: null,
    parse: function(source) {
      noramark.parsedResult = parser.parse(source);
      return noramark.parsedResult;
    },
    generators: {
      html: generateHtml
    }
  };
  return noramark;
}();
