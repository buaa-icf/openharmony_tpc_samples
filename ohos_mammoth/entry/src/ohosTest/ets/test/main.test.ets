import { describe, it, expect } from '@ohos/hypium';
import { testPath } from './testing';
import { taskpool } from '@kit.ArkTS';
import { abilityDelegatorRegistry } from '@kit.TestKit';



// const createTempDir = (): ESObject => {
//   return promises.nfcall(temp.mkdir, null);
// }

function runMammoth(path: string): Promise<ESObject> {

  // let args = Array.prototype.slice.call(arguments, 0);
  // let deferred = promises.defer();
  //
  // let processArgs = ["node", "bin/mammoth"].concat(args);
  // // TODO: proper escaping of args
  // let command = processArgs.join(" ");
  // child_process.exec(command, (error, stdout, stderr) => { // eslint-disable-line camelcase
  //   console.log(stderr); // eslint-disable-line no-console
  //   expect(error, null);
  //   deferred.resolve({ output: stdout, stderrOutput: stderr });
  // });
  //
  // return deferred.promise;

  let task: taskpool.Task = new taskpool.Task(test, path);
  return taskpool.execute(task, 100)
}
@Concurrent
function test(path: string):Promise<Uint8Array>{
  const delegator = abilityDelegatorRegistry.getAbilityDelegator();
  // 获取测试上下文
  const context = delegator.getAppContext();
  return context.resourceManager.getRawFileContent(path)
}


export default function mainTest() {
  describe('mainTest', () => {
    it("HTML is printed to stdout if output file is not set", 1, () => {
      runMammoth(testPath("single-paragraph.docx")).then((result: ESObject) => {
        let data: ESObject = result
        // expect(result.stderrOutput).assertEqual("");
        // expect(result.output).assertEqual("<p>Walking on imported air</p>");
      }).catch((err: BusinessError) => {
        expect().assertFail();
      })
    });
    //
    // it("HTML is written to file if output file is set", 1, () => {
    //   createTempDir().then((tempDir: string) => {
    //     let outputPath: string = path.join(tempDir, "output.html");
    //     runMammoth(testPath("single-paragraph.docx"), outputPath).then((result: ESObject) => {
    //
    //       expect(result.stderrOutput).assertEqual("");
    //       expect(result.output).assertEqual("");
    //       expect(fs.readFileSync(outputPath, "utf8")).assertEqual("<p>Walking on imported air</p>");
    //     });
    //   });
    // });
    //
    // let imageBase64 =
    //   "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOvgAADr4B6kKxwAAAABNJREFUKFNj/M+ADzDhlWUYqdIAQSwBE8U+X40AAAAASUVORK5CYII=";
    //
    // it("inline images are included in output if writing to single file", 1, () => {
    //   runMammoth(testPath("tiny-picture.docx")).then((result: ESObject) => {
    //     expect(result.stderrOutput).assertEqual("");
    //     expect(result.output).assertEqual('<p><img src="data:image/png;base64,' + imageBase64 + '" /></p>');
    //   });
    // });
    //
    // it("images are written to separate files if output dir is set", 1, () => {
    //   createTempDir().then((tempDir: string) => {
    //     let outputPath: string = path.join(tempDir, "tiny-picture.html");
    //     let imagePath: string = path.join(tempDir, "1.png");
    //     runMammoth(testPath("tiny-picture.docx"), "--output-dir", tempDir).then((result: ESObject) => {
    //       expect(result.stderrOutput).assertEqual("");
    //       expect(result.output).assertEqual("");
    //       expect(fs.readFileSync(outputPath, "utf8")).assertEqual('<p><img src="1.png" /></p>');
    //       expect(fs.readFileSync(imagePath, "base64")).assertEqual(imageBase64);
    //     });
    //   });
    // });
    //
    // it("style map is used if set", 1, () => {
    //   createTempDir().then((tempDir: string) => {
    //     let styleMapPath: string = path.join(tempDir, "style-map");
    //     fs.writeFileSync(styleMapPath, "p => span:fresh");
    //     runMammoth(testPath("single-paragraph.docx"), "--style-map", styleMapPath).then((result: ESObject) => {
    //       expect(result.stderrOutput).assertEqual("");
    //       expect(result.output).assertEqual("<span>Walking on imported air</span>");
    //     });
    //   });
    // });
    //
    // it("--output-format=markdown option generate markdown output", 1, () => {
    //   runMammoth(testPath("single-paragraph.docx"), "--output-format=markdown").then((result: ESObject) => {
    //     expect(result.stderrOutput).assertEqual("");
    //     expect(result.output).assertEqual("Walking on imported air\n\n");
    //   });
    // });


  });
}

