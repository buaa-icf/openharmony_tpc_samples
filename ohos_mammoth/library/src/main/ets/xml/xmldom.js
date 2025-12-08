import * as xmldom from "@xmldom/xmldom";
import * as dom from "@xmldom/xmldom/lib/dom";

function parseFromString(string, type) {
    var error = null;

    var domParser = new xmldom.DOMParser({
        onError: function(level, message) {
            error = {level: level, message: message};
        }
    });
    var document = domParser.parseFromString(string, type);
    if (error === null) {
        return document;
    } else {
        throw new Error(error.level + ": " + error.message);
    }
}

const Node = dom.Node;

export {
    parseFromString,
    Node
};
