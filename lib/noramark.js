module.exports = function() {
  var parser = require("./parser.js");
  return {
    parse: parser.parse
  };
}();
