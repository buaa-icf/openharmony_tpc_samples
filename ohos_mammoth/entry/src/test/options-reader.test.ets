import { describe, it, expect } from '@ohos/hypium';
import * as optionsReader from "@ohos/mammoth/src/main/ets/options-reader";
import underscore from "underscore";

const _: ESObject = underscore;
let standardOptions: ESObject = optionsReader._standardOptions;
let readOptions: ESObject = optionsReader.readOptions;



export default function optionsReaderTest() {
  describe('optionsReaderTest', () => {
    it('standard options are used if options is undefined', 0, (done: Function) => {
      let options: ESObject = readOptions(undefined);
      expect(standardOptions).assertDeepEquals(_.omit(options, "customStyleMap", "readStyleMap"));
      expect(options.customStyleMap).assertDeepEquals([]);
      done();
    });

    it('standard options are used if options is empty', 1, (done: Function) => {
      let options: ESObject = readOptions({});
      expect(standardOptions).assertDeepEquals(_.omit(options, "customStyleMap", "readStyleMap"));
      expect(options.customStyleMap).assertDeepEquals([]);
      done();
    });

    it('custom style map as string is prepended to standard style map', 2, (done: Function) => {
      let options: ESObject = readOptions({
        styleMap: "p.SectionTitle => h2"
      });
      let styleMap: Array<string> = options.readStyleMap();
      expect("p.SectionTitle => h2").assertDeepEquals(styleMap[0]);
      expect(optionsReader._defaultStyleMap).assertDeepEquals(styleMap.slice(1));
      done();
    });

    it('custom style map as array is prepended to standard style map', 3, (done: Function) => {
      let options: ESObject = readOptions({
        styleMap: ["p.SectionTitle => h2"]
      });
      let styleMap: Array<string> = options.readStyleMap();
      expect("p.SectionTitle => h2").assertDeepEquals(styleMap[0]);
      expect(optionsReader._defaultStyleMap).assertDeepEquals(styleMap.slice(1));
      done();
    });

    it('lines starting with # in custom style map are ignored', 4, (done: Function) => {
      let options: ESObject = readOptions({
        styleMap: "# p.SectionTitle => h3\np.SectionTitle => h2"
      });
      let styleMap: Array<string> = options.readStyleMap();
      expect("p.SectionTitle => h2").assertDeepEquals(styleMap[0]);
      expect(optionsReader._defaultStyleMap).assertDeepEquals(styleMap.slice(1));
      done();
    });

    it('blank lines in custom style map are ignored', 5, (done: Function) => {
      let options: ESObject = readOptions({
        styleMap: "\n\n"
      });
      expect(optionsReader._defaultStyleMap).assertDeepEquals(options.readStyleMap());
      done();
    });

    it('default style mappings are ignored if includeDefaultStyleMap is false', 6, (done: Function) => {
      let options: ESObject = readOptions({
        styleMap: "p.SectionTitle => h2",
        includeDefaultStyleMap: false
      });
      expect(["p.SectionTitle => h2"]).assertDeepEquals(options.readStyleMap());
      done();
    });
  });
}
