import _ from 'underscore';
import * as docxReader from "./docx/docx-reader";
import * as docxStyleMap from "./docx/style-map";
import { DocumentConverter } from "./document-to-html";
import { convertElementToRawText } from "./raw-text";
import { readStyle } from "./style-reader";
import { readOptions } from "./options-reader";
import * as unzip from "./unzip";
import { Result } from "./results";
import * as images from "./images";
import * as transforms from "./transforms";
import * as underline from "./underline";
import Buffer from '@ohos.buffer';

function convertToHtml(input, options) {
    return convert(input, options);
}

function convertToMarkdown(input, options) {
    var markdownOptions = Object.create(options || {});
    markdownOptions.outputFormat = "markdown";
    return convert(input, markdownOptions);
}

function convert(input, options) {
    options = readOptions(options);

    return unzip.openZip(input)
        // .tap(function(docxFile) {
        //     return docxStyleMap.readStyleMap(docxFile).then(function(styleMap) {
        //         options.embeddedStyleMap = styleMap;
        //     });
        // })
        .then(function(docxFile) {
            docxStyleMap.readStyleMap(docxFile).then(function(styleMap) {
                options.embeddedStyleMap = styleMap;
            });
            return docxReader.read(docxFile, input, options)
                .then(function(documentResult) {
                    return documentResult.map(options.transformDocument);
                })
                .then(function(documentResult) {
                    return convertDocumentToHtml(documentResult, options);
                });
        });
}

function readEmbeddedStyleMap(input) {
    return unzip.openZip(input)
        .then(docxStyleMap.readStyleMap);
}

function convertDocumentToHtml(documentResult, options) {
    var styleMapResult = parseStyleMap(options.readStyleMap());
    var parsedOptions = _.extend({}, options, {
        styleMap: styleMapResult.value
    });
    var documentConverter = new DocumentConverter(parsedOptions);

    return documentResult.flatMapThen(function(document) {
        return styleMapResult.flatMapThen(function(styleMap) {
            return documentConverter.convertToHtml(document);
        });
    });
}

function parseStyleMap(styleMap) {
    return Result.combine((styleMap || []).map(readStyle))
        .map(function(styleMap) {
            return styleMap.filter(function(styleMapping) {
                return !!styleMapping;
            });
        });
}


function extractRawText(input) {
    return unzip.openZip(input)
        .then(docxReader.read)
        .then(function(documentResult) {
            return documentResult.map(convertElementToRawText);
        });
}

function embedStyleMap(input, styleMap) {
    return unzip.openZip(input)
        // .tap(function(docxFile) {
        //     return docxStyleMap.writeStyleMap(docxFile, styleMap);
        // })
        .then(function(docxFile) {
            docxStyleMap.writeStyleMap(docxFile, styleMap);
            return docxFile.toArrayBuffer();
        })
        .then(function(arrayBuffer) {
            return {
                toArrayBuffer: function() {
                    return arrayBuffer;
                },
                toBuffer: function() {
                    return Buffer.from(arrayBuffer);
                }
            };
        });
}

function styleMapping() {
    throw new Error('Use a raw string instead of mammoth.styleMapping e.g. "p[style-name=\'Title\'] => h1" instead of mammoth.styleMapping("p[style-name=\'Title\'] => h1")');
};

export {
    convertToHtml,
    convertToMarkdown,
    convert,
    extractRawText,
    images,
    transforms,
    underline,
    embedStyleMap,
    readEmbeddedStyleMap,
    styleMapping
}
