"use strict";

// const Element = require("ltx/lib/Element");
import {Element} from '../ltx/lib/Element'
// const createElement = require("ltx/lib/createElement");
import { createElement } from '../ltx/lib/createElement'
// const Parser = require("./lib/Parser");
import {Parser} from './lib/Parser'
// const {
//   escapeXML,
//   unescapeXML,
//   escapeXMLText,
//   unescapeXMLText,
// } = require("ltx/lib/escape");
import {escapeXML,unescapeXML,escapeXMLText,unescapeXMLText} from '../ltx/lib/escape'
// const XMLError = require("./lib/XMLError");
import {XMLError} from './lib/XMLError'


function xml(...args) {
  return createElement(...args);
}

// export {xml,Element,Parser,escapeXML,}
// module.exports = xml;
export {
  xml,
  Element,
  createElement,
  Parser,
  escapeXML,
  unescapeXML,
  escapeXMLText,
  unescapeXMLText,
  XMLError}
// Object.assign(module.exports, {
//   Element,
//   createElement,
//   Parser,
//   escapeXML,
//   unescapeXML,
//   escapeXMLText,
//   unescapeXMLText,
//   XMLError,
// });
