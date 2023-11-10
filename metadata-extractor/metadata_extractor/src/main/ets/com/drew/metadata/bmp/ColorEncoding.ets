export enum ColorEncoding {
  RGB = 0
}

export namespace ColorEncoding {
  export function typeOf(value: number) {
    return value == 0 ? ColorEncoding.RGB : null
  }
}