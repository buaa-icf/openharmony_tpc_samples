interface Mammoth {
    convertToHtml: (input: Input, options?: Options) => Promise<Result>;
    extractRawText: (input: Input) => Promise<Result>;
    embedStyleMap: (input: Input, styleMap: string) => Promise<{
        toArrayBuffer: () => ArrayBuffer,
        toBuffer: () => Buffer,
    }>;
    images: Images;
    convertToMarkdown: (input: Input, options?: Options) => Promise<Result>;
    convert: (input: Input, options?: Options) => Promise<Result>;
    transforms: Transforms;
    underline: {element: (name: string) => (html: any) => any};
    readEmbeddedStyleMap: (input: Input) => Promise<Result>;
}

export type Input = NodeJsInput | BrowserInput;

type NodeJsInput = PathInput | BufferInput;

interface Transforms {
    paragraph: (transform: (element: any) => any) => (element: any) => any;
    run: (transform: (element: any) => any) => (element: any) => any;
    _elements: (transform: (element: any) => any) => (element: any) => any;
    _elementsOfType: (elementType: string, transform: (element: any) => any) => (element: any) => any;
    getDescendantsOfType: (element: any, type: string) => any[];
    getDescendants: (element: any) => any[];
}

interface PathInput {
    path: string;
}

interface BufferInput {
    buffer: Buffer;
}

type BrowserInput = ArrayBufferInput;

interface ArrayBufferInput {
    arrayBuffer: ArrayBuffer;
}

export interface Options {
    styleMap?: string | Array<string>;
    includeEmbeddedStyleMap?: boolean;
    includeDefaultStyleMap?: boolean;
    convertImage?: ImageConverter;
    ignoreEmptyParagraphs?: boolean;
    idPrefix?: string;
    externalFileAccess?: boolean;
    transformDocument?: (element: any) => any;
}

interface ImageConverter {
    __mammothBrand: "ImageConverter";
}

export interface Image {
    contentType: string;
    readAsArrayBuffer: () => Promise<ArrayBuffer>;
    readAsBase64String: () => Promise<string>;
    readAsBuffer: () => Promise<Buffer>;
    read: ImageRead;
}

interface ImageRead {
    (): Promise<Buffer>;
    (encoding: string): Promise<string>;
}

interface ImageAttributes {
    src: string;
}

interface Images {
    dataUri: ImageConverter;
    imgElement: (f: (image: Image) => Promise<ImageAttributes>) => ImageConverter;
}

export interface Result {
    value: string;
    messages: Array<Message>;
}

type Message = Warning | Error;

interface Warning {
    type: "warning";
    message: string;
}

interface Error {
    type: "error";
    message: string;
    error: unknown;
}

declare const mammoth: Mammoth;

export = mammoth;
