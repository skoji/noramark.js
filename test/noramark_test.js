var expect = require('chai').expect;
var noraParser = require('../lib/noramark.js');
var cheerio = require('cheerio');
var xmlHelper = require('./xml_helper.js');


describe('NoraParser', function() {
  it('converts simple paragraph', function () {
    var text = "ここから、パラグラフがはじまります。\n「二行目です。」\n三行目です。\n\n\nここから、次のパラグラフです。";
    noraParser.parse(text);
    var converted = noraParser.generators.html();
    var $ = cheerio.load(converted);
    expect($('body').length).to.eq(1);
    expect(xmlHelper.toA($('body')[0])).to.eql(
      ['body',
         ['div.pgroup',
          [ 'p', 'ここから、パラグラフがはじまります。'],
            ['p','「二行目です。」'],
            ['p','三行目です。']],
         ['div.pgroup',
            ['p','ここから、次のパラグラフです。']]]
    );

  });    
});
