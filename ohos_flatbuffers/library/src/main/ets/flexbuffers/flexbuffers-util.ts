import { util } from "@kit.ArkTS";

export function fromUTF8Array(data: Uint8Array): string {
  const decoder = new util.TextDecoder();
  return decoder.decodeWithStream(data);
}

export function toUTF8Array(str: string) : Uint8Array {
  const encoder = new util.TextEncoder();
  return encoder.encodeInto(str);
}