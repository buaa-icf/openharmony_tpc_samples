import * as nodes from "./nodes";
import { readString } from "./reader";
import { writeString } from "./writer";

const Element = nodes.Element;
const element = nodes.element;
const emptyElement = nodes.emptyElement;
const text = nodes.text;

export {
    Element,
    element,
    emptyElement,
    text,
    readString,
    writeString
};
