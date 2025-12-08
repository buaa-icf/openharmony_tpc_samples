import { describe, expect, it } from '@ohos/hypium';
import * as mammoth from '@ohos/mammoth';
import * as documents from '@ohos/mammoth/src/main/ets/documents';
import Buffer from '@ohos.buffer';
import { SrcData } from '../../../main/ets/utils/Type';
import { DocumentsImage, ImageConverterResult } from './Type';
import { BusinessError } from '@kit.BasicServicesKit';

let Image: ESObject = documents.Image;

export default function imagesTest() {
  describe('imagesTest', () => {
    it('mammoth.images.inline() should be an alias of mammoth.images.imgElement()', 0, (done: Function) => {
      let images: ESObject = mammoth.images;
      expect(images.inline === mammoth.images.imgElement).assertTrue();
      done();
    });

    it('mammoth.images.dataUri() encodes images in base64', 1, (done: Function) => {
      let imageBuffer: Buffer.Buffer = Buffer.from("abc");
      let image: DocumentsImage = new Image({
        readImage: (encoding: string): Promise<string> => {
          return Promise.resolve(imageBuffer.toString(encoding));
        },
        contentType: "image/jpeg"
      });


      let ImageConverter: ESObject = mammoth.images;

      ImageConverter.dataUri(image)
        .then((result: ImageConverterResult[]) => {
          expect(result[0].tag.attributes.src).assertEqual("data:image/jpeg;base64,YWJj");
          done();
        })
        .catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it('mammoth.images.imgElement() when element does not have alt text then alt attribute is not set', 2, (done: Function) => {
      let imageBuffer: Buffer.Buffer = Buffer.from("abc");
      let image: DocumentsImage = new Image({
        readImage: (encoding: string) => {
          return Promise.resolve(imageBuffer.toString(encoding));
        },
        contentType: "image/jpeg"
      });

      let ImageConverter: ESObject = mammoth.images;

      let result: Promise<ImageConverterResult[]> = ImageConverter.imgElement((image: ESObject) => {
        let data: SrcData = { src: "<src>" }
        return data;
      })(image);

      result.then((result: ImageConverterResult[]) => {
        expect(result[0].tag.attributes.src).assertEqual("<src>");
        done();
      })
        .catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
    })

    it('mammoth.images.imgElement() when element has alt text then alt attribute is set', 3, (done: Function) => {
      let imageBuffer: Buffer.Buffer = Buffer.from("abc");
      let image: DocumentsImage = new Image({
        readImage: (encoding: string) => {
          return Promise.resolve(imageBuffer.toString(encoding));
        },
        contentType: "image/jpeg",
        altText: "<alt>"
      });

      let ImageConverter: ESObject = mammoth.images;
      let result: Promise<ImageConverterResult[]> = ImageConverter.imgElement((image: ESObject) => {
        let data: SrcData = { src: "<src>" }
        return data;
      })(image);

      result.then((result: ImageConverterResult[]) => {
        expect(result[0].tag.attributes.src).assertEqual("<src>");
        expect(result[0].tag.attributes.alt).assertEqual("<alt>");
        done();
      })
        .catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
    })

    it('mammoth.images.imgElement() image alt text can be overridden by alt attribute returned from function', 4,
      (done: Function) => {
        let imageBuffer: Buffer.Buffer = Buffer.from("abc");
        let image: DocumentsImage = new Image({
          readImage: (encoding: string) => {
            return Promise.resolve(imageBuffer.toString(encoding));
          },
          contentType: "image/jpeg",
          altText: "<alt>"
        });

        let ImageConverter: ESObject = mammoth.images;
        let result: Promise<ImageConverterResult[]> = ImageConverter.imgElement(() => {
          let data: SrcData = { alt: "<alt override>", src: "<src>" };
          return data;
        })(image);

        result.then((result: ImageConverterResult[]) => {
          expect(result[0].tag.attributes.src).assertEqual("<src>");
          expect(result[0].tag.attributes.alt).assertEqual("<alt override>");
          done();
        })
          .catch((error: BusinessError) => {
            expect().assertFail();
            done();
          })
      })
  });
}
