import Buffer from '@ohos.buffer';
import { Hyperlink } from './docx/body-reader.test';
export interface Children {
  children?: Array<ESObject>;
  name?: string;
  type?: string;
}

export interface Element{
  type?: "element"|string;
  name?: string,
  value?: string;
  attributes?: Record<string, string>|string;
  children?: Element[];
}

export interface ZipFile {
  exists: (name: string) => boolean;
  read: (name: string, encoding: string) => Promise<ESObject>
  write: (name: string, encoding: string) => ESObject;
  toArrayBuffer: () => ESObject;
}

export type Message = Warning | Error;

interface Warning {
  type: "warning";
  message: string;
}

interface Error {
  type: "error";
  message: string;
  error: ESObject;
}

export interface ResultType {
  value: string|DocumentsImage|DocumentsImage[]|Hyperlink|Hyperlink[];
  messages: Array<Message>;
}
export interface Result {
  value: string;
  messages: Array<Message>;
}
interface Attributes{
  tag?: string,
  src?: string,
  alt?: string
}

interface Tag{
  attributes:Attributes
}
export interface ImageConverterResult{
  tag: Tag
}
export interface DocumentsImage{
  altText: string;
  type: string;
  contentType: string;
  read: (encoding?: string)=> Promise<string>;
  readAsArrayBuffer:()=> Promise<ArrayBuffer>;
  readAsBase64String:()=> Promise<string>;
  readAsBuffer:()=> Promise<Buffer.Buffer>;
}

export interface Converter {
  convertToHtml: (input: ESObject, options?: ESObject) => Promise<Result>;
  extractRawText: (input: ESObject) => Promise<Result>;
  embedStyleMap: (input: ESObject, styleMap: string) => ESObject
  images: ESObject;
  convertToMarkdown: (input: ESObject, options?: ESObject) => Promise<Result>;
  convert: (input: ESObject, options?: ESObject) => Promise<Result>;
  transforms: ESObject;
  readEmbeddedStyleMap: (input: ESObject) => Promise<Result>;
}

export interface CheckBoxType{
  type: string
  checked: boolean
}

export interface CommentReference{
  commentId: string;
  type: string
}

export interface CommentType{
  commentId: string;
  body: ESObject;
  authorName?: string | null;
  authorInitials?: string | null;
  type?: string;
}

export interface CommentResult {
  value: Array<CommentType>;
  messages: Array<Message>;
}
export interface BodyReader{
  readXmlElement:Function;
  readXmlElements:Function;
}
export interface DocumentXmlReaderType{
  convertXmlToDocument: Function
}