'use strict';

// var conventions = require('./conventions');
import {
    assign, 
    hasDefaultHTMLNamespace,
    isHTMLMimeType,
    isValidMimeType,
    MIME_TYPE,
    NAMESPACE,
} from "./conventions";

// var errors = require('./errors');
import {
    DOMException,
    DOMExceptionName,
    ExceptionCode,
    ParseError,
} from "./errors";

// var dom = require('./dom');
import {
    Attr,
    CDATASection,
    CharacterData,
    Comment,
    Document,
    DocumentFragment,
    DocumentType,
    DOMImplementation,
    Element,
    Entity,
    EntityReference,
    LiveNodeList,
    NamedNodeMap,
    Node,
    NodeList,
    Notation,
    ProcessingInstruction,
    Text,
    XMLSerializer,
} from "./dom";


// var domParser = require('./dom-parser');
import {
    DOMParser,
    normalizeLineEndings,
    onErrorStopParsing,
    onWarningStopParsing,
} from "./dom-parser";

export {
    assign, 
    hasDefaultHTMLNamespace,
    isHTMLMimeType,
    isValidMimeType,
    MIME_TYPE,
    NAMESPACE,
    DOMException,
    DOMExceptionName,
    ExceptionCode,
    ParseError,
    Attr,
    CDATASection,
    CharacterData,
    Comment,
    Document,
    DocumentFragment,
    DocumentType,
    DOMImplementation,
    Element,
    Entity,
    EntityReference,
    LiveNodeList,
    NamedNodeMap,
    Node,
    NodeList,
    Notation,
    ProcessingInstruction,
    Text,
    XMLSerializer,
    DOMParser,
    normalizeLineEndings,
    onErrorStopParsing,
    onWarningStopParsing,
}