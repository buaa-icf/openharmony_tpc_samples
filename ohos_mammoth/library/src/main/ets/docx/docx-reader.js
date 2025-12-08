import * as documents from '../documents';
import { Result } from '../results';
import * as zipfile from '../zipfile';
import { readXmlFromZipFile } from './office-xml-reader';
import { createBodyReader } from './body-reader';
import { DocumentXmlReader } from './document-xml-reader';
import * as relationshipsReader from './relationships-reader';
import * as contentTypesReader from './content-types-reader';
import * as numberingXml from './numbering-xml';
import * as stylesReader from './styles-reader';
import * as notesReader from './notes-reader';
import * as commentsReader from './comments-reader';
import { Files } from './files';

function read(docxFile, input, options) {
    input = input || {};
    options = options || {};

    var files = new Files({
        externalFileAccess: options.externalFileAccess,
        relativeToFile: input.path
    });

    return Promise.all([
        readContentTypesFromZipFile(docxFile),
        findPartPaths(docxFile)
    ]).then(async function(result) {
        return {
            contentTypes: result[0],
            partPaths: result[1],
            docxFile: docxFile,
            files: files,
            styles: await readStylesFromZipFile(docxFile, result[1].styles)
        };
    }).then(async function(result) {
        let numbering = await readNumberingFromZipFile(docxFile, result.partPaths.numbering, result.styles);
        return {
            ...result,
            numbering
        };
    }).then(async function(result) {
        let footnotes = await readXmlFileWithBody(result.partPaths.footnotes, result, function(bodyReader, xml) {
            if (xml) {
                return notesReader.createFootnotesReader(bodyReader)(xml);
            } else {
                return new Result([]);
            }
        });
        let endnotes = await readXmlFileWithBody(result.partPaths.endnotes, result, function(bodyReader, xml) {
            if (xml) {
                return notesReader.createEndnotesReader(bodyReader)(xml);
            } else {
                return new Result([]);
            }
        });
        let comments = await readXmlFileWithBody(result.partPaths.comments, result, function(bodyReader, xml) {
            if (xml) {
                return commentsReader.createCommentsReader(bodyReader)(xml);
            } else {
                return new Result([]);
            }
        })
        return {
            ...result,
            footnotes,
            endnotes,
            comments
        };
    }).then(async function(result) {
        let notes = await result.footnotes.flatMap(function(footnotes) {
            return result.endnotes.map(function(endnotes) {
                return new documents.Notes(footnotes.concat(endnotes));
            });
        })
        return {
            ...result,
            notes
        };
    }).then(function(result) {
        return readXmlFileWithBody(result.partPaths.mainDocument, result, function(bodyReader, xml) {
            return result.notes.flatMap(function(notes) {
                return result.comments.flatMap(function(comments) {
                    var reader = new DocumentXmlReader({
                        bodyReader: bodyReader,
                        notes: notes,
                        comments: comments
                    });
                    return reader.convertXmlToDocument(xml);
                });
            });
        });
    });
}

function findPartPaths(docxFile) {
    return readPackageRelationships(docxFile).then(function(packageRelationships) {
        var mainDocumentPath = findPartPath({
            docxFile: docxFile,
            relationships: packageRelationships,
            relationshipType: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",
            basePath: "",
            fallbackPath: "word/document.xml"
        });

        if (!docxFile.exists(mainDocumentPath)) {
            throw new Error("Could not find main document part. Are you sure this is a valid .docx file?");
        }

        return xmlFileReader({
            filename: relationshipsFilename(mainDocumentPath),
            readElement: relationshipsReader.readRelationships,
            defaultValue: relationshipsReader.defaultValue
        })(docxFile).then(function(documentRelationships) {
            function findPartRelatedToMainDocument(name) {
                return findPartPath({
                    docxFile: docxFile,
                    relationships: documentRelationships,
                    relationshipType: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/" + name,
                    basePath: zipfile.splitPath(mainDocumentPath).dirname,
                    fallbackPath: "word/" + name + ".xml"
                });
            }

            return {
                mainDocument: mainDocumentPath,
                comments: findPartRelatedToMainDocument("comments"),
                endnotes: findPartRelatedToMainDocument("endnotes"),
                footnotes: findPartRelatedToMainDocument("footnotes"),
                numbering: findPartRelatedToMainDocument("numbering"),
                styles: findPartRelatedToMainDocument("styles")
            };
        });
    });
}

function findPartPath(options) {
    var docxFile = options.docxFile;
    var relationships = options.relationships;
    var relationshipType = options.relationshipType;
    var basePath = options.basePath;
    var fallbackPath = options.fallbackPath;

    var targets = relationships.findTargetsByType(relationshipType);
    var normalisedTargets = targets.map(function(target) {
        return stripPrefix(zipfile.joinPath(basePath, target), "/");
    });
    var validTargets = normalisedTargets.filter(function(target) {
        return docxFile.exists(target);
    });
    if (validTargets.length === 0) {
        return fallbackPath;
    } else {
        return validTargets[0];
    }
}

function stripPrefix(value, prefix) {
    if (value.substring(0, prefix.length) === prefix) {
        return value.substring(prefix.length);
    } else {
        return value;
    }
}

function xmlFileReader(options) {
    return function(zipFile) {
        return readXmlFromZipFile(zipFile, options.filename)
            .then(function(element) {
                return element ? options.readElement(element) : options.defaultValue;
            });
    };
}

function readXmlFileWithBody(filename, options, func) {
    var readRelationshipsFromZipFile = xmlFileReader({
        filename: relationshipsFilename(filename),
        readElement: relationshipsReader.readRelationships,
        defaultValue: relationshipsReader.defaultValue
    });

    return readRelationshipsFromZipFile(options.docxFile).then(function(relationships) {
        var bodyReader = new createBodyReader({
            relationships: relationships,
            contentTypes: options.contentTypes,
            docxFile: options.docxFile,
            numbering: options.numbering,
            styles: options.styles,
            files: options.files
        });
        return readXmlFromZipFile(options.docxFile, filename)
            .then(function(xml) {
                return func(bodyReader, xml);
            });
    });
}

function relationshipsFilename(filename) {
    var split = zipfile.splitPath(filename);
    return zipfile.joinPath(split.dirname, "_rels", split.basename + ".rels");
}

var readContentTypesFromZipFile = xmlFileReader({
    filename: "[Content_Types].xml",
    readElement: contentTypesReader.readContentTypesFromXml,
    defaultValue: contentTypesReader.defaultContentTypes
});

function readNumberingFromZipFile(zipFile, path, styles) {
    return xmlFileReader({
        filename: path,
        readElement: function(element) {
            return numberingXml.readNumberingXml(element, {styles: styles});
        },
        defaultValue: numberingXml.defaultNumbering
    })(zipFile);
}

function readStylesFromZipFile(zipFile, path) {
    return xmlFileReader({
        filename: path,
        readElement: stylesReader.readStylesXml,
        defaultValue: stylesReader.defaultStyles
    })(zipFile);
}

var readPackageRelationships = xmlFileReader({
    filename: "_rels/.rels",
    readElement: relationshipsReader.readRelationships,
    defaultValue: relationshipsReader.defaultValue
});

export {
    read,
    findPartPaths as _findPartPaths
}
