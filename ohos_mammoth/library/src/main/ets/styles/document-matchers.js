
function paragraph(options) {
    return new Matcher("paragraph", options);
}

function run(options) {
    return new Matcher("run", options);
}

function table(options) {
    return new Matcher("table", options);
}

function highlight(options) {
    return new HighlightMatcher(options);
}

function Matcher(elementType, options) {
    options = options || {};
    this._elementType = elementType;
    this._styleId = options.styleId;
    this._styleName = options.styleName;
    if (options.list) {
        this._listIndex = options.list.levelIndex;
        this._listIsOrdered = options.list.isOrdered;
    }
}

Matcher.prototype.matches = function(element) {
    return element.type === this._elementType &&
        (this._styleId === undefined || element.styleId === this._styleId) &&
        (this._styleName === undefined || (element.styleName && this._styleName.operator(this._styleName.operand, element.styleName))) &&
        (this._listIndex === undefined || isList(element, this._listIndex, this._listIsOrdered)) &&
        (this._breakType === undefined || this._breakType === element.breakType);
};

function HighlightMatcher(options) {
    options = options || {};
    this._color = options.color;
}

HighlightMatcher.prototype.matches = function(element) {
    return element.type === "highlight" &&
        (this._color === undefined || element.color === this._color);
};

function BreakMatcher(options) {
    options = options || {};
    this._breakType = options.breakType;
}

BreakMatcher.prototype.matches = function(element) {
    return element.type === "break" &&
        (this._breakType === undefined || element.breakType === this._breakType);
};

function isList(element, levelIndex, isOrdered) {
    return element.numbering &&
        element.numbering.level == levelIndex &&
        element.numbering.isOrdered == isOrdered;
}

function equalTo(value) {
    return {
        operator: operatorEqualTo,
        operand: value
    };
}

function startsWith(value) {
    return {
        operator: operatorStartsWith,
        operand: value
    };
}

function operatorEqualTo(first, second) {
    return first.toUpperCase() === second.toUpperCase();
}

function operatorStartsWith(first, second) {
    return second.toUpperCase().indexOf(first.toUpperCase()) === 0;
}

const bold = new Matcher("bold");
const italic = new Matcher("italic");
const underline = new Matcher("underline");
const strikethrough = new Matcher("strikethrough");
const allCaps = new Matcher("allCaps");
const smallCaps = new Matcher("smallCaps");
const commentReference = new Matcher("commentReference");
const lineBreak = new BreakMatcher({breakType: "line"});
const pageBreak = new BreakMatcher({breakType: "page"});
const columnBreak = new BreakMatcher({breakType: "column"});

export {
    paragraph,
    run,
    table,
    bold,
    italic,
    underline,
    strikethrough,
    allCaps,
    smallCaps,
    highlight,
    commentReference,
    lineBreak,
    pageBreak,
    columnBreak,
    equalTo,
    startsWith
}
