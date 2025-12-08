import * as ast from './ast';

import simplify from "./simplify";

function write(writer, nodes) {
    nodes.forEach(function(node) {
        writeNode(writer, node);
    });
}

function writeNode(writer, node) {
    toStrings[node.type](writer, node);
}

var toStrings = {
    element: generateElementString,
    text: generateTextString,
    forceWrite: function() { }
};

function generateElementString(writer, node) {
    if (ast.isVoidElement(node)) {
        writer.selfClosing(node.tag.tagName, node.tag.attributes);
    } else {
        writer.open(node.tag.tagName, node.tag.attributes);
        write(writer, node.children);
        writer.close(node.tag.tagName);
    }
}

function generateTextString(writer, node) {
    writer.text(node.value);
}

const freshElement = ast.freshElement;
const nonFreshElement = ast.nonFreshElement;
const elementWithTag = ast.elementWithTag;
const text = ast.text;
const forceWrite = ast.forceWrite;

export {
    freshElement,
    nonFreshElement,
    elementWithTag,
    text,
    forceWrite,
    simplify,
    write
};

