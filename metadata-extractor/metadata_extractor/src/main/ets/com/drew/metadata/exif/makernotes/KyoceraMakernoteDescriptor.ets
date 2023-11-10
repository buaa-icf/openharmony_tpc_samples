import { KyoceraMakernoteDirectory } from './KyoceraMakernoteDirectory';
import TagDescriptor from '../../TagDescriptor';

export class KyoceraMakernoteDescriptor extends TagDescriptor<KyoceraMakernoteDirectory> {
  constructor(directory: KyoceraMakernoteDirectory) {
    super(directory)
  }

  public getDescription(tagType: number) {
    switch (tagType) {
      case KyoceraMakernoteDirectory.TAG_PROPRIETARY_THUMBNAIL:
        return this.getProprietaryThumbnailDataDescription();
      default:
        return super.getDescription(tagType);
    }
  }

  public getProprietaryThumbnailDataDescription(): string{
    return this.getByteLengthDescription(KyoceraMakernoteDirectory.TAG_PROPRIETARY_THUMBNAIL);
  }
}