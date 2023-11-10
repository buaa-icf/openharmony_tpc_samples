export enum RenderingIntent {
  /** Graphic, Saturation */
  LCS_GM_BUSINESS = 1,

  /** Proof, Relative Colorimetric */
  LCS_GM_GRAPHICS = 2,

  /** Picture, Perceptual */
  LCS_GM_IMAGES = 4,

  /** Match, Absolute Colorimetric */
  LCS_GM_ABS_COLORIMETRIC = 8
}

export namespace RenderingIntent {
  export function typeOf(value: number) {
    switch (value) {
      case RenderingIntent.LCS_GM_BUSINESS:
        return RenderingIntent.LCS_GM_BUSINESS
      case RenderingIntent.LCS_GM_GRAPHICS:
        return RenderingIntent.LCS_GM_GRAPHICS
      case RenderingIntent.LCS_GM_IMAGES:
        return RenderingIntent.LCS_GM_IMAGES
      case RenderingIntent.LCS_GM_ABS_COLORIMETRIC:
        return RenderingIntent.LCS_GM_ABS_COLORIMETRIC
      default:
        return null
    }
  }

  export function toString(renderingIntent: RenderingIntent) {
    switch (renderingIntent) {
      case RenderingIntent.LCS_GM_BUSINESS:
        return "Graphic, Saturation";
      case RenderingIntent.LCS_GM_GRAPHICS:
        return "Proof, Relative Colorimetric";
      case RenderingIntent.LCS_GM_IMAGES:
        return "Picture, Perceptual";
      case RenderingIntent.LCS_GM_ABS_COLORIMETRIC:
        return "Match, Absolute Colorimetric";
      default:
        throw new Error("Unimplemented rendering intent " + renderingIntent);
    }
  }
}