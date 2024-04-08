/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any purpose
 * with or without fee is hereby granted, provided that the above copyright notice
 * and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
 * FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
 * CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
// import { deepStrictEqual } from "assert";
// import { decodeAsync, encode, decodeArrayStream } from "@ohos/msgpack";
// import { ReadableStream as PonyReadableStream } from "web-streams-polyfill/ponyfill";
// const isReadableStreamConstructorAvailable: boolean = (() => {
//   try {
//     // Edge <= 18 has ReadableStream but its constructor is not available
//     new ReadableStream({
//       start() {},
//     });
//     return true;
//   } catch {
//     return false;
//   }
// })();
//
// const MyReadableStream = isReadableStreamConstructorAvailable ? ReadableStream : PonyReadableStream;
//
// // Downgrade stream not to implement AsyncIterable<T>
// function downgradeReadableStream(stream: ReadableStream | PonyReadableStream) {
//   (stream as any)[Symbol.asyncIterator] = undefined;
// }
//
// describe("whatwg streams", () => {
//   it("decodeArrayStream", async () => {
//     const data = [1, 2, 3];
//     const encoded = encode(data);
//     const stream = new MyReadableStream({
//       start(controller) {
//         for (const byte of encoded) {
//           controller.enqueue([byte]);
//         }
//         controller.close();
//       },
//     });
//     downgradeReadableStream(stream);
//
//     const items: Array<unknown> = [];
//     for await (const item of decodeArrayStream(stream)) {
//       items.push(item);
//     }
//     deepStrictEqual(items, data);
//   });
//
//   it("decodeAsync", async () => {
//     const data = [1, 2, 3];
//     const encoded = encode(data);
//     const stream = new MyReadableStream({
//       start(controller) {
//         for (const byte of encoded) {
//           controller.enqueue([byte]);
//         }
//         controller.close();
//       },
//     });
//     downgradeReadableStream(stream);
//
//     deepStrictEqual(await decodeAsync(stream), data);
//   });
// });
