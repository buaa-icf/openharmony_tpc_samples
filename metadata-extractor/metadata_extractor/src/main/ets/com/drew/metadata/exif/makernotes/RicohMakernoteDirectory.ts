import { RicohMakernoteDescriptor } from './RicohMakernoteDescriptor';
import Directory from '../../Directory';

export class RicohMakernoteDirectory extends Directory {
  public static TAG_MAKERNOTE_DATA_TYPE: number = 0x0001
  public static TAG_VERSION: number= 0x0002
  public static TAG_PRINT_IMAGE_MATCHING_INFO: number = 0x0E00
  public static TAG_RICOH_CAMERA_INFO_MAKERNOTE_SUB_IFD_POINTER: number = 0x2001

  private static _tagNameMap = new Map<number, string>()
    .set(RicohMakernoteDirectory.TAG_MAKERNOTE_DATA_TYPE, "Makernote Data Type")
    .set(RicohMakernoteDirectory.TAG_VERSION, "Version")
    .set(RicohMakernoteDirectory.TAG_PRINT_IMAGE_MATCHING_INFO, "Print Image Matching (PIM) Info")
    .set(RicohMakernoteDirectory.TAG_RICOH_CAMERA_INFO_MAKERNOTE_SUB_IFD_POINTER, "Ricoh Camera Info Makernote Sub-IFD")

  constructor() {
    super()
    this.setDescriptor(new RicohMakernoteDescriptor(this));
  }

  public getName(): string{
    return "Ricoh Makernote";
  }

  protected getTagNameMap(): Map<number, string>{
    return RicohMakernoteDirectory._tagNameMap;
  }
}