import abilityTest from './Ability.test';
import zipfileTest from './zipfile.test';
import unzipTest from './unzip.test';
import transformsTest from './transforms.test';
import styleReaderTest from './style-reader.test';
import resultsTest from './results.test';
import rawTextTest from './raw-text.test';
import optionsReaderTest from './options-reader.test';
import imagesTest from './images.test';
import readerTest from './xml/reader.test';
import writerTest from './xml/writer.test';
import html_writerTest from './writers/html-writer.test';
import markdown_writerTest from './writers/markdown-writer.test';
import tokeniserTest from './styles/parser/tokeniser.test';
import documentMatchersTest from './styles/document-matchers.test';
import html_pathsTest from './styles/html-paths.test';
import mammothTest from './mammoth.test';
import documentToHtmlTest from './document-to-html.test';
import commentsReaderTest from './docx/comments-reader.test';
import contentTypesReaderTest from './docx/content-types-reader.test';
import documentXmlReaderTest from './docx/document-xml-reader.test';
import docxReaderTest from './docx/docx-reader.test';
import notesReaderTest from './docx/notes-reader.test';
import numberingXmlTest from './docx/numbering-xml.test'
import writesTest from './html/writes.test'
import StylesReaderTest from './docx/styles-reader.test';
import simplifyTest from './html/simplify.test';
import urisTest from './docx/uris.test';
import relationshipsReaderTest from './docx/relationships-reader.test';
import officeXmlReaderTest from './docx/office-xml-reader.test';
import styleMapTest from './docx/style-map.test';
import bodyReaderAbilityTest from './docx/body-reader.test';
import filesTest from './docx/files.test';


export default function testsuite() {
  abilityTest();
  styleMapTest();
  documentToHtmlTest();
  imagesTest();
  optionsReaderTest();
  rawTextTest();
  resultsTest();
  styleReaderTest();
  transformsTest();
  unzipTest();
  zipfileTest();
  readerTest()
  writerTest()
  html_writerTest()
  markdown_writerTest()
  tokeniserTest()
  documentMatchersTest()
  html_pathsTest()
  commentsReaderTest();
  contentTypesReaderTest();
  documentXmlReaderTest();
  docxReaderTest();
  notesReaderTest();
  numberingXmlTest();
  writesTest();
  StylesReaderTest();
  simplifyTest();
  urisTest();
  relationshipsReaderTest();
  officeXmlReaderTest();
  bodyReaderAbilityTest();
  filesTest()
  mammothTest();
}