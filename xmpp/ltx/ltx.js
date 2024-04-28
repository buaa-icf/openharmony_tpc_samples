import parse from "./src/main/ltx/lib/parse";
import Parser from "./src/main/ltx/lib/Parser";
import {
  escapeXML,
  unescapeXML,
  escapeXMLText,
  unescapeXMLText,
} from "./src/main/ltx/lib/escape";
import { Element } from "./src/main/ltx/lib/Element";
import equal, { nameEqual, attrsEqual, childrenEqual } from "./src/main/ltx/lib/equal";
import { createElement } from "./src/main/ltx/lib/createElement";
import tag from "./src/main/ltx/lib/tag";
import tagString from "./src/main/ltx/lib/tagString";
import { isNode, isElement, isText } from "./src/main/ltx/lib/is";
import clone from "./src/main/ltx/lib/clone";
import stringify from "./src/main/ltx/lib/stringify";
import JSONify from "./src/main/ltx/lib/JSONify";

export {
  Element,
  equal,
  nameEqual,
  attrsEqual,
  childrenEqual,
  isNode,
  isElement,
  isText,
  clone,
  createElement,
  escapeXML,
  unescapeXML,
  escapeXMLText,
  unescapeXMLText,
  Parser,
  parse,
  tag,
  tagString,
  stringify,
  JSONify,
};
