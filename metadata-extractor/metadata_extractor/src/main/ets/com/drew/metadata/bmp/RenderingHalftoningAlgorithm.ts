export enum RenderingHalftoningAlgorithm {
  /** No halftoning algorithm */
  NONE = 0,

  /** Error Diffusion Halftoning */
  ERROR_DIFFUSION = 1,

  /** Processing Algorithm for Noncoded Document Acquisition */
  PANDA = 2,

  /** Super-circle Halftoning */
  SUPER_CIRCLE = 3
}

export namespace RenderingHalftoningAlgorithm {
  export function typeOf(value: number) {
    switch (value) {
      case RenderingHalftoningAlgorithm.NONE:
        return RenderingHalftoningAlgorithm.NONE;
        break
      case RenderingHalftoningAlgorithm.ERROR_DIFFUSION:
        return RenderingHalftoningAlgorithm.ERROR_DIFFUSION;
        break
      case RenderingHalftoningAlgorithm.PANDA:
        return RenderingHalftoningAlgorithm.PANDA;
        break
      case RenderingHalftoningAlgorithm.SUPER_CIRCLE:
        return RenderingHalftoningAlgorithm.SUPER_CIRCLE;
        break
      default:
        return null;
        break
    }
  }

  export function toString(renderingHalftoningAlgorithm: RenderingHalftoningAlgorithm): string {
    switch (renderingHalftoningAlgorithm) {
      case RenderingHalftoningAlgorithm.NONE:
        return "No Halftoning Algorithm";
      case RenderingHalftoningAlgorithm.ERROR_DIFFUSION:
        return "Error Diffusion Halftoning";
      case RenderingHalftoningAlgorithm.PANDA:
        return "Processing Algorithm for Noncoded Document Acquisition";
      case RenderingHalftoningAlgorithm.SUPER_CIRCLE:
        return "Super-circle Halftoning";
      default:
        throw new Error("Unimplemented rendering halftoning algorithm type " + renderingHalftoningAlgorithm);
    }
  }
}