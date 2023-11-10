import Box from './Box'
import Mp4Directory from '../Mp4Directory'
import Mp4UuidBoxDirectory from '../media/Mp4UuidBoxDirectory'
import Mp4BoxTypes from '../Mp4BoxTypes'
import SequentialReader from '../../../lang/SequentialReader';
import deviceInfo from '@ohos.deviceInfo';

export default class UuidBox extends Box {
  private userData: Int8Array;
  public constructor(reader: SequentialReader, box: Box) {
    super(reader, box);

    if (this.classtype == Mp4BoxTypes.BOX_USER_DEFINED) {
      this.usertype = this.getUuid(reader.getBytes(16));
    }

    this.userData = reader.getBytes(reader.available());
  }

  public addMetadata(directory: Mp4Directory): void
  {
    directory.setString(Mp4UuidBoxDirectory.TAG_UUID, this.usertype);
    directory.setByteArray(Mp4UuidBoxDirectory.TAG_USER_DATA, this.userData);
  }

  private getUuid(bytes: Int8Array): string {

    return deviceInfo.udid + bytes.toString();
  }
}