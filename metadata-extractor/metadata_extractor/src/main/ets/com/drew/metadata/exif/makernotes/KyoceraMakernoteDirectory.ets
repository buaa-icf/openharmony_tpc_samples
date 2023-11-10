import { KyoceraMakernoteDescriptor } from './KyoceraMakernoteDescriptor';
import Directory from '../../Directory';

export class KyoceraMakernoteDirectory extends Directory{
    public static TAG_PROPRIETARY_THUMBNAIL = 0x0001;
    public static TAG_PRINT_IMAGE_MATCHING_INFO = 0x0E00;

    private static _tagNameMap:Map<number, string> = new Map<number, string>()
    .set(KyoceraMakernoteDirectory.TAG_PROPRIETARY_THUMBNAIL, "Proprietary Thumbnail Format Data")
    .set(KyoceraMakernoteDirectory.TAG_PRINT_IMAGE_MATCHING_INFO, "Print Image Matching (PIM) Info")

    constructor(){
    super()
    this.setDescriptor(new KyoceraMakernoteDescriptor(this));
    }
    public  getName():string
    {
        return "Kyocera/Contax Makernote";
    }

    protected  getTagNameMap():Map<number,string>
    {
        return KyoceraMakernoteDirectory._tagNameMap;
    }
}