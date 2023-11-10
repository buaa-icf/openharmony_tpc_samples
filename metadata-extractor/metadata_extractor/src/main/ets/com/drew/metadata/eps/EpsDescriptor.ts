import { EpsDirectory } from './EpsDirectory';
import TagDescriptor from '../TagDescriptor';

export class EpsDescriptor extends TagDescriptor<EpsDirectory> {
  constructor(directory: EpsDirectory) {
    super(directory)
  }

  getDescription(tagType: number) {
    switch (tagType) {
      case EpsDirectory.TAG_IMAGE_WIDTH:
      case EpsDirectory.TAG_IMAGE_HEIGHT:
        return this.getPixelDescription(tagType);
      case EpsDirectory.TAG_TIFF_PREVIEW_SIZE:
      case EpsDirectory.TAG_TIFF_PREVIEW_OFFSET:
        return this.getByteSizeDescription(tagType);
      case EpsDirectory.TAG_COLOR_TYPE:
        return this.getColorTypeDescription();
      default:
        return this._directory.getString(tagType);
    }
  }

  public getPixelDescription(tagType: number): string{
    return this._directory.getString(tagType) + " pixels";
  }

  public getByteSizeDescription(tagType: number): string{
    return this._directory.getString(tagType) + " bytes";
  }

  getColorTypeDescription(): string{
    return this.getIndexedDescription(EpsDirectory.TAG_COLOR_TYPE, 1,
      "Grayscale", "Lab", "RGB", "CMYK");
  }
}