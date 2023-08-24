import helper from './options-helper';
import xml2js from './xml2js';

function validateOptions(userOptions) {
  var options = helper.copyOptions(userOptions);
  helper.ensureSpacesExists(options);
  return options;
}

var xml2json = function (xml, userOptions) {
  var options, js, json, parentKey;
  options = validateOptions(userOptions);
  js = xml2js(xml, options);
  parentKey = 'compact' in options && options.compact ? '_parent' : 'parent';
  if ('addParent' in options && options.addParent) {
    json = JSON.stringify(js, function (k, v) {
      return k === parentKey ? '_' : v;
    }, options.spaces);
  } else {
    json = JSON.stringify(js, null, options.spaces);
  }
  return json.replace(/\u2028/g, '\\u2028').replace(/\u2029/g, '\\u2029');
};

export default xml2json;
