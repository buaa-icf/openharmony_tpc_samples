"use strict";

export { Element } from 'ltx/src/main/ltx/lib/Element'
import { createElement } from 'ltx/src/main/ltx/lib/createElement'
export { Parser }  from './src/main/xml/lib/Parser'
export { escapeXML, unescapeXML, escapeXMLText, unescapeXMLText } from 'ltx/src/main/ltx/lib/escape'
export { XMLError } from './src/main/xml/lib/XMLError'


export default function xml(...args) {
    return createElement(...args);
}

export  {
    xml,
//     Element,
    createElement,
    // Parser,
//     escapeXML,
//     unescapeXML,
//     escapeXMLText,
//     unescapeXMLText,
//     XMLError
}

