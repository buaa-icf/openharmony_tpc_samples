/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import JSZip, { JSZipFileOptions } from "jszip";

type Done = () => void

export default function fileTest() {
  describe('fileTest', () => {
    it('add_file_wrong_string_as_base64', 0, (done: Done) => {
      let zip = new JSZip();
      zip.file("text.txt", "a random string", {
        base64: true
      });
      zip.generateAsync({
        type: "binarystring"
      }).then(() => {
        expect(false).assertTrue();
        done();
      }).catch((e: Error) => {
        console.log(`出现异常${e.message}`);
        expect(e.message).assertEqual("Invalid base64 input, bad content length.");
        done();
      });
    })
    it('add_file_data_url_instead_of_base64', 0, (done: Done) => {
      const zip = new JSZip();
      zip.file("text.txt", "data:image/png;base64,YmFzZTY0", {
        base64: true
      });
      zip.generateAsync({
        type: "binarystring"
      }).then(() => {
        expect(false).assertTrue();
        done();
      }).catch((e: Error) => {
        expect(e.message).assertEqual("Invalid base64 input, it looks like a data url.");
        done();
      });
    })
    it('Zip_folder_should_not_throw_an_exception', 0, () => {
      const zip = new JSZip();
      try {
        zip.folder("");
        expect(true).assertTrue();
      } catch (err) {
        expect(false).assertTrue();
      }
    })
    it('file_creates_a_folder_with_dir_true', 0, () => {
      const zip = new JSZip();
      const options: JSZipFileOptions = {
        dir: true
      }
      zip.file("folder", null, options);
      expect(!!zip.files["folder/"].dir).assertTrue();
    })
    it('file_creates_a_folder_with_the_right_unix_permissions', 0, () => {
      const zip = new JSZip();
      const options: JSZipFileOptions = {
        unixPermissions: 16704
      }
      zip.file("folder", null, options);
      expect(!!zip.files["folder/"].dir).assertTrue();
    })
    it('file_creates_a_folder_with_the_right_dos_permissions', 0, () => {
      const zip = new JSZip();
      const options: JSZipFileOptions = {
        dosPermissions: 16
      }
      zip.file("folder", null, options);
      expect(zip.files["folder/"].dir).assertTrue();
    })
    it('A_folder_stays_a_folder_when_created_with_file', 0, (done: Done) => {
      const referenceDate = new Date("July 17, 2009 14:36:56");
      const referenceComment = "my comment";
      const zip = new JSZip();
      const options: JSZipFileOptions = {
        dir: true,
        date: referenceDate,
        comment: referenceComment,
        unixPermissions: 16704
      }
      zip.file("folder", null, options);

      expect(!!zip.files["folder/"].dir).assertTrue();
      expect(zip.files["folder/"].date.getTime()).assertEqual(referenceDate.getTime());
      expect(zip.files["folder/"].comment).assertEqual(referenceComment);
      expect(zip.files["folder/"]?.unixPermissions?.toString(8)).assertEqual("40500");

      zip.generateAsync({
        type: "string", platform: "UNIX"
      })
        .then(JSZip.loadAsync)
        .then((reloaded) => {
          expect(reloaded.files["folder/"].dir).assertTrue();

          expect(reloaded.files["folder/"].dir).assertTrue();
          expect(reloaded.files["folder/"].date.getTime()).assertEqual(referenceDate.getTime());
          expect(reloaded.files["folder/"].comment).assertEqual(referenceComment);
          expect(reloaded.files["folder/"]?.unixPermissions?.toString(8)).assertEqual("40500");
          done();
        }).catch(() => {
        expect(false).assertTrue()
        done();
      });
    })
    it('file_adds_a_slash_for_directories', 0, () => {
      const zip = new JSZip();
      const options: JSZipFileOptions = {
        dir: true
      }
      zip.file("folder_without_slash", null, options);
      zip.file("folder_with_slash/", null, options);
      expect(!!zip.files["folder_without_slash/"]).assertTrue();
      expect(!!zip.files["folder_with_slash/"]).assertTrue();
    })
    it('folder_does_not_overwrite_existing_entries', 0, () => {
      const referenceComment = "my comment";
      const zip = new JSZip();
      const options: JSZipFileOptions = {
        dir: true,
        comment: referenceComment,
        unixPermissions: 16704
      }
      zip.file("folder", null, options);

      // calling folder() doesn't override it
      zip.folder("folder");

      expect(zip.files["folder/"].comment).assertEqual(referenceComment);
      expect(zip.files["folder/"]?.unixPermissions?.toString(8)).assertEqual("40500");
    })
    it('createFolders_works_on_a_file', 0, () => {
      const zip = new JSZip();
      zip.file("false/0/1/2/file", "content", {
        createFolders: false, unixPermissions: "644"
      });
      zip.file("true/0/1/2/file", "content", {
        createFolders: true, unixPermissions: "644"
      });

      expect(!zip.files["false/"]).assertTrue();
      expect(!!zip.files["true/"]).assertTrue();
      expect(zip.files["true/"].unixPermissions).assertEqual(null);
    })
    it('createFolders_works_on_a_folder', 0, () => {
      const zip = new JSZip();
      const options1: JSZipFileOptions = {
        createFolders: false, unixPermissions: "777", dir: true
      }
      const options2: JSZipFileOptions = {
        createFolders: true, unixPermissions: "777", dir: true
      }

      zip.file("false/0/1/2/folder", null, options1);
      zip.file("true/0/1/2/folder", null, options2);

      expect(!zip.files["false/"]).assertTrue();
      expect(!!zip.files["true/"]).assertTrue();
      expect(zip.files["true/"].unixPermissions).assertEqual(null);
    })


    it('folder_follows_the_default_createFolders_settings', 0, () => {
      const zip = new JSZip();
      zip.folder("true/0/1/2/folder");
      expect(!!zip.files["true/"]).assertTrue()
    })
    it('A_folder_stays_a_folder', 0, (done: Done) => {
      const zip = new JSZip();
      zip.folder("folder/");
      expect(!!zip.files["folder/"].dir).assertTrue();
      zip.generateAsync({
        type: "binarystring"
      })
        .then(JSZip.loadAsync)
        .then((reloaded) => {
          expect(!!reloaded.files["folder/"].dir).assertTrue();
          done();
        }).catch(() => {
        expect(false).assertTrue();
      });
    })
    it('Folders_are_created_by_default', 0, () => {
      const zip = new JSZip();
      zip.file("test/Readme", "Hello World!\n");
      expect(!!zip.files["test/"]).assertTrue();
      expect(!!zip.files["test/Readme"]).assertTrue();
    })
    it('Folders_can_be_avoided_with_createFolders', 0, () => {
      const zip = new JSZip();
      zip.file("test/Readme", "Hello World!\n", {
        createFolders: false
      });
      expect(!!zip.files["test/Readme"]).assertTrue();
      expect(!zip.files["test/"]).assertTrue();
    })
    it('Finding_a_file', 0, (done: Done) => {
      const zip = new JSZip();
      zip.file("Readme", "Hello World!\n");
      zip.file("Readme.French", "Bonjour tout le monde!\n");
      zip.file("Readme.Pirate", "Ahoy m'hearty!\n");

      zip.file("Readme.French")?.async("string")?.then((content) => {
        expect(content).assertEqual("Bonjour tout le monde!\n");
        done();
      }).catch(() => {
        expect(false).assertTrue()
      });
      expect(zip.file("Readme.Deutsch")).assertEqual(null);
      expect(zip.file(new RegExp("Readme\..")).length).assertEqual(2);
      expect(zip.file(new RegExp("pirate", "i")).length).assertEqual(1);
    })
    it('Finding_a_file_text_search_with_a_relative_folder', 0, (done:Done) => {
      const zip = new JSZip();
      zip.folder("files/default")?.file("Readme", "Hello World!\n");
      zip.folder("files/translation")?.file("Readme.French", "Bonjour tout le monde!\n");
      zip.folder("files")?.folder("translation")?.file("Readme.Pirate", "Ahoy m'hearty!\n");

      zip.file("files/translation/Readme.French")?.async("string").then((content) => {
        expect(content).assertEqual("Bonjour tout le monde!\n");
        done();
      }).catch(() => {
        expect(false).assertTrue();
      });
    })
    it('Finding_files_regex_with_a_relative_folder', 0, () => {
      const zip = new JSZip();
      zip.folder("files/default")?.file("Readme", "Hello World!\n");
      zip.folder("files/translation")?.file("Readme.French", "Bonjour tout le monde!\n");
      zip.folder("files")?.folder("translation")?.file("Readme.Pirate", "Ahoy m'hearty!\n");

      expect(zip.file(new RegExp("Readme")).length).assertEqual(3);
      expect(zip.folder("files/translation")?.file(new RegExp("Readme")).length).assertEqual(2);
      expect(zip.folder("files")?.folder("translation")?.file(new RegExp("Readme")).length).assertEqual(2);
      expect(zip.folder("files/translation")?.file(new RegExp("pirate","i")).length).assertEqual(1);
      expect(zip.folder("files/translation")?.file(new RegExp("^readme","i")).length).assertEqual(2);
      expect(zip.folder("files/default")?.file(new RegExp("pirate","i")).length).assertEqual(0);

    })
    it('Finding_folders', 0, () => {
      const zip = new JSZip();
      zip.folder("root/")?.folder("sub1/");
      zip.folder("root/sub2/subsub1");

      expect(zip.folder(new RegExp("sub2\/$")).length).assertEqual(1);
      expect(zip.folder(new RegExp("sub1")).length).assertEqual(2);
      expect(zip.folder(new RegExp("root")).length).assertEqual(4);


    })
    it('Finding_folders_with_relative_path', 0, () => {
      const zip = new JSZip();
      zip.folder("root/")?.folder("sub1/");
      zip.folder("root/sub2/subsub1");
      const root = zip.folder("root/sub2");

      expect(root?.folder(new RegExp("sub2\/$")).length).assertEqual(0);
      expect(root?.folder(new RegExp("sub1")).length).assertEqual(1);
      expect(root?.folder(new RegExp("^subsub1")).length).assertEqual(1);
      expect(root?.folder(new RegExp("root")).length).assertEqual(0);

    })

    it('generate_uses_updated_ZipObject_date_attribute', 0, (done: Done) => {
      const date = new Date("July 17, 2009 14:36:57");
      const zip = new JSZip();
      zip.file("Hello.txt", "Hello World\n", {
        comment: "my comment"
      }); // date = now
      zip.files["Hello.txt"].date = date;
      zip.generateAsync({
        type: "binarystring"
      })
        .then(JSZip.loadAsync)
        .then( () => {
          expect(true).assertTrue();
          done();
        }).catch(() => {
        expect(false).assertTrue();
      });

    })

  })
}