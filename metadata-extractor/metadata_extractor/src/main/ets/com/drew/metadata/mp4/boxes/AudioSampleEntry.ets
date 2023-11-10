import SampleEntry from './SampleEntry'
import Box from './Box'
import SequentialReader from '../../../lang/SequentialReader'
import Mp4SoundDirectory from '../media/Mp4SoundDirectory'
import Mp4Dictionary from '../Mp4Dictionary'

export default class AudioSampleEntry extends SampleEntry {
  channelcount: number;
  samplesize: number;
  samplerate: number;
  public constructor(reader: SequentialReader, box: Box) {
    super(reader, box);

    reader.skip(8); // Reserved
    this.channelcount = reader.getUInt16();
    this.samplesize = reader.getInt16();
    reader.skip(2); // Pre-defined
    reader.skip(2); // Reserved
    this.samplerate = reader.getUInt32();
    // ChannelLayout()
    // DownMix and/or DRC boxes
    // More boxes as needed
  }

  public addMetadata(directory: Mp4SoundDirectory): void
  {
    Mp4Dictionary.setLookup(Mp4SoundDirectory.TAG_AUDIO_FORMAT, this.format, directory);
    directory.setInt(Mp4SoundDirectory.TAG_NUMBER_OF_CHANNELS, this.channelcount);
    directory.setInt(Mp4SoundDirectory.TAG_AUDIO_SAMPLE_SIZE, this.samplesize);
  }
}