/*
Copyright (c) 2022 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import ByteArrayReader from '../../lang/ByteArrayReader';
import StringUtil from '../../lang/StringUtil';
import Rational from '../../lang/Rational';
import Directory from '../Directory'
import TagDescriptor from '../TagDescriptor'
import ExifDirectoryBase from './ExifDirectoryBase'
import PhotographicConversions from '../../imaging/PhotographicConversions'
import StringValue from '../StringValue'
import LogUtil from '../../tools/LogUtils'

const TAG: string = "ExifDescriptorBase";


abstract class ExifDescriptorBase <T extends Directory> extends TagDescriptor<T> {
  /**
   * Dictates whether rational values will be represented in decimal format in instances
   * where decimal notation is elegant (such as 1/2 -> 0.5, but not 1/3).
   */
  private readonly _allowDecimalRepresentationOfRationals: boolean = true;

  // Note for the potential addition of brightness presentation in eV:
  // Brightness of taken subject. To calculate Exposure(Ev) from BrightnessValue(Bv),
  // you must add SensitivityValue(Sv).
  // Ev=BV+Sv   Sv=log2(ISOSpeedRating/3.125)
  // ISO100:Sv=5, ISO200:Sv=6, ISO400:Sv=7, ISO125:Sv=5.32.

  constructor(directory: T) {
    super(directory);
  }

  public getDescription(tagType: number): string
  {
    LogUtil.debug(TAG, `getDescription enter, tagType: ${tagType}`);
    switch (tagType) {
      case ExifDirectoryBase.TAG_DATETIME:
        return this.getDate();
      case ExifDirectoryBase.TAG_INTEROP_INDEX:
        return this.getInteropIndexDescription();
      case ExifDirectoryBase.TAG_INTEROP_VERSION:
        return this.getInteropVersionDescription();
      case ExifDirectoryBase.TAG_NEW_SUBFILE_TYPE:
        return this.getNewSubfileTypeDescription();
      case ExifDirectoryBase.TAG_SUBFILE_TYPE:
        return this.getSubfileTypeDescription();
      case ExifDirectoryBase.TAG_IMAGE_WIDTH:
        return this.getImageWidthDescription();
      case ExifDirectoryBase.TAG_IMAGE_HEIGHT:
        return this.getImageHeightDescription();
      case ExifDirectoryBase.TAG_BITS_PER_SAMPLE:
        return this.getBitsPerSampleDescription();
      case ExifDirectoryBase.TAG_COMPRESSION:
        return this.getCompressionDescription();
      case ExifDirectoryBase.TAG_PHOTOMETRIC_INTERPRETATION:
        return this.getPhotometricInterpretationDescription();
      case ExifDirectoryBase.TAG_THRESHOLDING:
        return this.getThresholdingDescription();
      case ExifDirectoryBase.TAG_FILL_ORDER:
        return this.getFillOrderDescription();
      case ExifDirectoryBase.TAG_ORIENTATION:
        return this.getOrientationDescription();
      case ExifDirectoryBase.TAG_SAMPLES_PER_PIXEL:
        return this.getSamplesPerPixelDescription();
      case ExifDirectoryBase.TAG_ROWS_PER_STRIP:
        return this.getRowsPerStripDescription();
      case ExifDirectoryBase.TAG_STRIP_BYTE_COUNTS:
        return this.getStripByteCountsDescription();
      case ExifDirectoryBase.TAG_X_RESOLUTION:
        return this.getXResolutionDescription();
      case ExifDirectoryBase.TAG_Y_RESOLUTION:
        return this.getYResolutionDescription();
      case ExifDirectoryBase.TAG_PLANAR_CONFIGURATION:
        return this.getPlanarConfigurationDescription();
      case ExifDirectoryBase.TAG_RESOLUTION_UNIT:
        return this.getResolutionDescription();
      case ExifDirectoryBase.TAG_JPEG_PROC:
        return this.getJpegProcDescription();
      case ExifDirectoryBase.TAG_YCBCR_SUBSAMPLING:
        return this.getYCbCrSubsamplingDescription();
      case ExifDirectoryBase.TAG_YCBCR_POSITIONING:
        return this.getYCbCrPositioningDescription();
      case ExifDirectoryBase.TAG_REFERENCE_BLACK_WHITE:
        return this.getReferenceBlackWhiteDescription();
      case ExifDirectoryBase.TAG_CFA_PATTERN_2:
        return this.getCfaPattern2Description();
      case ExifDirectoryBase.TAG_EXPOSURE_TIME:
        return this.getExposureTimeDescription();
      case ExifDirectoryBase.TAG_FNUMBER:
        return this.getFNumberDescription();
      case ExifDirectoryBase.TAG_EXPOSURE_PROGRAM:
        return this.getExposureProgramDescription();
      case ExifDirectoryBase.TAG_ISO_EQUIVALENT:
        return this.getIsoEquivalentDescription();
      case ExifDirectoryBase.TAG_SENSITIVITY_TYPE:
        return this.getSensitivityTypeRangeDescription();
      case ExifDirectoryBase.TAG_EXIF_VERSION:
        return this.getExifVersionDescription();
      case ExifDirectoryBase.TAG_COMPONENTS_CONFIGURATION:
        return this.getComponentConfigurationDescription();
      case ExifDirectoryBase.TAG_COMPRESSED_AVERAGE_BITS_PER_PIXEL:
        return this.getCompressedAverageBitsPerPixelDescription();
      case ExifDirectoryBase.TAG_SHUTTER_SPEED:
        return this.getShutterSpeedDescription();
      case ExifDirectoryBase.TAG_APERTURE:
        return this.getApertureValueDescription();
      case ExifDirectoryBase.TAG_BRIGHTNESS_VALUE:
        return this.getBrightnessValueDescription();
      case ExifDirectoryBase.TAG_EXPOSURE_BIAS:
        return this.getExposureBiasDescription();
      case ExifDirectoryBase.TAG_MAX_APERTURE:
        return this.getMaxApertureValueDescription();
      case ExifDirectoryBase.TAG_SUBJECT_DISTANCE:
        return this.getSubjectDistanceDescription();
      case ExifDirectoryBase.TAG_METERING_MODE:
        return this.getMeteringModeDescription();
      case ExifDirectoryBase.TAG_WHITE_BALANCE:
        return ExifDescriptorBase.getWhiteBalanceDescription();
      case ExifDirectoryBase.TAG_FLASH:
        return this.getFlashDescription();
      case ExifDirectoryBase.TAG_FOCAL_LENGTH:
        return this.getFocalLengthDescription();
      case ExifDirectoryBase.TAG_USER_COMMENT:
        return this.getUserCommentDescription();
      case ExifDirectoryBase.TAG_TEMPERATURE:
        return this.getTemperatureDescription();
      case ExifDirectoryBase.TAG_HUMIDITY:
        return this.getHumidityDescription();
      case ExifDirectoryBase.TAG_PRESSURE:
        return this.getPressureDescription();
      case ExifDirectoryBase.TAG_WATER_DEPTH:
        return this.getWaterDepthDescription();
      case ExifDirectoryBase.TAG_ACCELERATION:
        return this.getAccelerationDescription();
      case ExifDirectoryBase.TAG_CAMERA_ELEVATION_ANGLE:
        return this.getCameraElevationAngleDescription();
      case ExifDirectoryBase.TAG_WIN_TITLE:
        return this.getWindowsTitleDescription();
      case ExifDirectoryBase.TAG_WIN_COMMENT:
        return this.getWindowsCommentDescription();
      case ExifDirectoryBase.TAG_WIN_AUTHOR:
        return this.getWindowsAuthorDescription();
      case ExifDirectoryBase.TAG_WIN_KEYWORDS:
        return this.getWindowsKeywordsDescription();
      case ExifDirectoryBase.TAG_WIN_SUBJECT:
        return this.getWindowsSubjectDescription();
      case ExifDirectoryBase.TAG_FLASHPIX_VERSION:
        return this.getFlashPixVersionDescription();
      case ExifDirectoryBase.TAG_COLOR_SPACE:
        return this.getColorSpaceDescription();
      case ExifDirectoryBase.TAG_EXIF_IMAGE_WIDTH:
        return this.getExifImageWidthDescription();
      case ExifDirectoryBase.TAG_EXIF_IMAGE_HEIGHT:
        return this.getExifImageHeightDescription();
      case ExifDirectoryBase.TAG_FOCAL_PLANE_X_RESOLUTION:
        return this.getFocalPlaneXResolutionDescription();
      case ExifDirectoryBase.TAG_FOCAL_PLANE_Y_RESOLUTION:
        return this.getFocalPlaneYResolutionDescription();
      case ExifDirectoryBase.TAG_FOCAL_PLANE_RESOLUTION_UNIT:
        return this.getFocalPlaneResolutionUnitDescription();
      case ExifDirectoryBase.TAG_SENSING_METHOD:
        return this.getSensingMethodDescription();
      case ExifDirectoryBase.TAG_FILE_SOURCE:
        return this.getFileSourceDescription();
      case ExifDirectoryBase.TAG_SCENE_TYPE:
        return this.getSceneTypeDescription();
      case ExifDirectoryBase.TAG_CFA_PATTERN:
        return this.getCfaPatternDescription();
      case ExifDirectoryBase.TAG_CUSTOM_RENDERED:
        return this.getCustomRenderedDescription();
      case ExifDirectoryBase.TAG_EXPOSURE_MODE:
        return this.getExposureModeDescription();
      case ExifDirectoryBase.TAG_WHITE_BALANCE_MODE:
        return this.getWhiteBalanceModeDescription();
      case ExifDirectoryBase.TAG_DIGITAL_ZOOM_RATIO:
        return this.getDigitalZoomRatioDescription();
      case ExifDirectoryBase.TAG_35MM_FILM_EQUIV_FOCAL_LENGTH:
        return this.get35mmFilmEquivFocalLengthDescription();
      case ExifDirectoryBase.TAG_SCENE_CAPTURE_TYPE:
        return this.getSceneCaptureTypeDescription();
      case ExifDirectoryBase.TAG_GAIN_CONTROL:
        return this.getGainControlDescription();
      case ExifDirectoryBase.TAG_CONTRAST:
        return this.getContrastDescription();
      case ExifDirectoryBase.TAG_SATURATION:
        return this.getSaturationDescription();
      case ExifDirectoryBase.TAG_SHARPNESS:
        return this.getSharpnessDescription();
      case ExifDirectoryBase.TAG_SUBJECT_DISTANCE_RANGE:
        return this.getSubjectDistanceRangeDescription();
      case ExifDirectoryBase.TAG_LENS_SPECIFICATION:
        return this.getLensSpecificationDescription();
      case ExifDirectoryBase.TAG_EXTRA_SAMPLES:
        return this.getExtraSamplesDescription();
      case ExifDirectoryBase.TAG_SAMPLE_FORMAT:
        return this.getSampleFormatDescription();
      default:
        return super.getDescription(tagType);
    }
  }
  public getDate():any{
    let value = this._directory.getObject(ExifDirectoryBase.TAG_DATETIME);
    return value.toString() +"GMT"
  }

  public getInteropIndexDescription(): string
  {
    LogUtil.debug(TAG, `getInteropIndexDescription enter`);
    let value = this._directory.getString(ExifDirectoryBase.TAG_INTEROP_INDEX, 'UTF-8');

    if (value == null) {
      LogUtil.error(TAG, `getInteropIndexDescription end, value is null`);
      return null;
    }

    LogUtil.debug(TAG, `getInteropIndexDescription end, value: ${value}`);
    return ("R98" == value.trim())
      ? "Recommended Exif Interoperability Rules (ExifR98)"
      : "Unknown (" + value + ")";
  }

  public getInteropVersionDescription(): string
  {
    return this.getVersionBytesDescription(ExifDirectoryBase.TAG_INTEROP_VERSION, 2);
  }

  public getNewSubfileTypeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_NEW_SUBFILE_TYPE, 0,
      "Full-resolution image",
      "Reduced-resolution image",
      "Single page of multi-page image",
      "Single page of multi-page reduced-resolution image",
      "Transparency mask",
      "Transparency mask of reduced-resolution image",
      "Transparency mask of multi-page image",
      "Transparency mask of reduced-resolution multi-page image"
    );
  }

  public getSubfileTypeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SUBFILE_TYPE, 1,
      "Full-resolution image",
      "Reduced-resolution image",
      "Single page of multi-page image"
    );
  }

  public getImageWidthDescription(): string
  {
    let value = this._directory.getString(ExifDirectoryBase.TAG_IMAGE_WIDTH);
    return value == null ? null : value + " pixels";
  }

  public getImageHeightDescription(): string
  {
    let value = this._directory.getString(ExifDirectoryBase.TAG_IMAGE_HEIGHT);
    return value == null ? null : value + " pixels";
  }

  public getBitsPerSampleDescription(): string
  {
    let value = this._directory.getString(ExifDirectoryBase.TAG_BITS_PER_SAMPLE);
    return value == null ? null : value + " bits/component/pixel";
  }

  public getCompressionDescription(): string
  {
    LogUtil.debug(TAG, `getCompressionDescription enter`);
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_COMPRESSION);
    if (value == null) {
      LogUtil.error(TAG, `getCompressionDescription end, value is null`);
      return null;
    }
    LogUtil.debug(TAG, `getCompressionDescription end, value: ${value}`);
    switch (value) {
      case 1:
        return "Uncompressed";
      case 2:
        return "CCITT 1D";
      case 3:
        return "T4/Group 3 Fax";
      case 4:
        return "T6/Group 4 Fax";
      case 5:
        return "LZW";
      case 6:
        return "JPEG (old-style)";
      case 7:
        return "JPEG";
      case 8:
        return "Adobe Deflate";
      case 9:
        return "JBIG B&W";
      case 10:
        return "JBIG Color";
      case 99:
        return "JPEG";
      case 262:
        return "Kodak 262";
      case 32766:
        return "Next";
      case 32767:
        return "Sony ARW Compressed";
      case 32769:
        return "Packed RAW";
      case 32770:
        return "Samsung SRW Compressed";
      case 32771:
        return "CCIRLEW";
      case 32772:
        return "Samsung SRW Compressed 2";
      case 32773:
        return "PackBits";
      case 32809:
        return "Thunderscan";
      case 32867:
        return "Kodak KDC Compressed";
      case 32895:
        return "IT8CTPAD";
      case 32896:
        return "IT8LW";
      case 32897:
        return "IT8MP";
      case 32898:
        return "IT8BL";
      case 32908:
        return "PixarFilm";
      case 32909:
        return "PixarLog";
      case 32946:
        return "Deflate";
      case 32947:
        return "DCS";
      case 34661:
        return "JBIG";
      case 34676:
        return "SGILog";
      case 34677:
        return "SGILog24";
      case 34712:
        return "JPEG 2000";
      case 34713:
        return "Nikon NEF Compressed";
      case 34715:
        return "JBIG2 TIFF FX";
      case 34718:
        return "Microsoft Document Imaging (MDI) Binary Level Codec";
      case 34719:
        return "Microsoft Document Imaging (MDI) Progressive Transform Codec";
      case 34720:
        return "Microsoft Document Imaging (MDI) Vector";
      case 34892:
        return "Lossy JPEG";
      case 65000:
        return "Kodak DCR Compressed";
      case 65535:
        return "Pentax PEF Compressed";
      default:
        return "Unknown (" + value + ")";
    }
  }

  public getPhotometricInterpretationDescription(): string
  {
    // Shows the color space of the image data components
    LogUtil.debug(TAG, `getPhotometricInterpretationDescription enter`);
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_PHOTOMETRIC_INTERPRETATION);
    if (value == null) {
      LogUtil.error(TAG, `getPhotometricInterpretationDescription end, value is null`);
      return null;
    }
    LogUtil.debug(TAG, `getPhotometricInterpretationDescription end, value: ${value}`);
    switch (value) {
      case 0:
        return "WhiteIsZero";
      case 1:
        return "BlackIsZero";
      case 2:
        return "RGB";
      case 3:
        return "RGB Palette";
      case 4:
        return "Transparency Mask";
      case 5:
        return "CMYK";
      case 6:
        return "YCbCr";
      case 8:
        return "CIELab";
      case 9:
        return "ICCLab";
      case 10:
        return "ITULab";
      case 32803:
        return "Color Filter Array";
      case 32844:
        return "Pixar LogL";
      case 32845:
        return "Pixar LogLuv";
      case 32892:
        return "Linear Raw";
      default:
        return "Unknown colour space";
    }
  }

  public getThresholdingDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_THRESHOLDING, 1,
      "No dithering or halftoning",
      "Ordered dither or halftone",
      "Randomized dither"
    );
  }

  public getFillOrderDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_FILL_ORDER, 1,
      "Normal",
      "Reversed"
    );
  }

  public getOrientationDescription(): string
  {
    return super.getOrientationDescription(ExifDirectoryBase.TAG_ORIENTATION);
  }

  public getSamplesPerPixelDescription(): string
  {
    let value = this._directory.getString(ExifDirectoryBase.TAG_SAMPLES_PER_PIXEL);
    return value == null ? null : value + " samples/pixel";
  }

  public getRowsPerStripDescription(): string
  {
    let value = this._directory.getString(ExifDirectoryBase.TAG_ROWS_PER_STRIP);
    return value == null ? null : value + " rows/strip";
  }

  public getStripByteCountsDescription(): string
  {
    let value = this._directory.getString(ExifDirectoryBase.TAG_STRIP_BYTE_COUNTS);
    return value == null ? null : value + " bytes";
  }

  public getXResolutionDescription(): string
  {
    LogUtil.debug(TAG, `getXResolutionDescription enter`);
    let value: Rational = this._directory.getRational(ExifDirectoryBase.TAG_X_RESOLUTION);
    if (value == null) {
      LogUtil.error(TAG, `getXResolutionDescription end, value is null`);
      return null;
    }
    let unit = this.getResolutionDescription();
    LogUtil.debug(TAG, `getXResolutionDescription end, value: ${value}, unit: ${unit}`);
    return "%s dots per %s"
      .replace(/%s/, value.toSimpleString(this._allowDecimalRepresentationOfRationals))
      .replace(/%s/, (unit == null ? "unit" : unit.toLowerCase()))
    //
    //        String.format("%s dots per %s",
    //            value.toSimpleString(this._allowDecimalRepresentationOfRationals),
    //            unit == null ? "unit" : unit.toLowerCase());
  }

  public getYResolutionDescription(): string
  {
    LogUtil.debug(TAG, `getYResolutionDescription enter`);
    let value: Rational = this._directory.getRational(ExifDirectoryBase.TAG_Y_RESOLUTION);
    if (value == null) {
      LogUtil.error(TAG, `getYResolutionDescription end, value is null`);
      return null;
    }
    let unit = this.getResolutionDescription();
    LogUtil.debug(TAG, `getYResolutionDescription end, value: ${value}, unit: ${unit}`);
    return "%s dots per %s"
      .replace(/%s/, value.toSimpleString(this._allowDecimalRepresentationOfRationals))
      .replace(/%s/, (unit == null ? "unit" : unit.toLowerCase()))

    //        return String.format("%s dots per %s",
    //            value.toSimpleString(this._allowDecimalRepresentationOfRationals),
    //            unit == null ? "unit" : unit.toLowerCase());
  }

  public getPlanarConfigurationDescription(): string
  {
    // When image format is no compression YCbCr, this value shows byte aligns of YCbCr
    // data. If value is '1', Y/Cb/Cr value is chunky format, contiguous for each subsampling
    // pixel. If value is '2', Y/Cb/Cr value is separated and stored to Y plane/Cb plane/Cr
    // plane format.
    return this.getIndexedDescription(ExifDirectoryBase.TAG_PLANAR_CONFIGURATION,
      1,
      "Chunky (contiguous for each subsampling pixel)",
      "Separate (Y-plane/Cb-plane/Cr-plane format)"
    );
  }

  public getResolutionDescription(): string
  {
    // '1' means no-unit, '2' means inch, '3' means centimeter. Default value is '2'(inch)
    return this.getIndexedDescription(ExifDirectoryBase.TAG_RESOLUTION_UNIT, 1, "(No unit)", "Inch", "cm");
  }

  public getJpegProcDescription(): string
  {
    LogUtil.debug(TAG, `getJpegProcDescription enter`);
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_JPEG_PROC);
    if (value == null) {
      LogUtil.error(TAG, `getJpegProcDescription end, value is null`);
      return null;
    }
    LogUtil.debug(TAG, `getJpegProcDescription end, value: ${value}`);
    switch (value) {
      case 1:
        return "Baseline";
      case 14:
        return "Lossless";
      default:
        return "Unknown (" + value + ")";
    }
  }

  public getYCbCrSubsamplingDescription(): string
  {
    LogUtil.debug(TAG, `getYCbCrSubsamplingDescription enter`);
    let positions = this._directory.getIntArray(ExifDirectoryBase.TAG_YCBCR_SUBSAMPLING);
    if (positions == null || positions.length < 2) {
      LogUtil.error(TAG, `getYCbCrSubsamplingDescription end, positions is null or length < 2`);
      return null;
    }
    LogUtil.debug(TAG, `getYCbCrSubsamplingDescription end, positions: ${positions}`);
    if (positions[0] == 2 && positions[1] == 1) {
      return "YCbCr4:2:2";
    } else if (positions[0] == 2 && positions[1] == 2) {
      return "YCbCr4:2:0";
    } else {
      return "(Unknown)";
    }
  }

  public getYCbCrPositioningDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_YCBCR_POSITIONING, 1, "Center of pixel array", "Datum point");
  }

  public getReferenceBlackWhiteDescription(): string
  {
    // For some reason, sometimes this is read as a long[] and
    // getIntArray isn't able to deal with it
    LogUtil.debug(TAG, `getReferenceBlackWhiteDescription enter`);
    let ints = this._directory.getIntArray(ExifDirectoryBase.TAG_REFERENCE_BLACK_WHITE);
    if (ints == null || ints.length < 6) {
      let o = this._directory.getObject(ExifDirectoryBase.TAG_REFERENCE_BLACK_WHITE);
      //            if (o != null && (o instanceof long[]))
      //            {
      //                long[] longs = (long[])o;
      //                if (longs.length < 6)
      //                    return null;
      //
      //                ints = new int[longs.length];
      //                for (int i = 0; i < longs.length; i++)
      //                    ints[i] = (int)longs[i];
      //            }
      //            else
      //                return null;
    }

    let blackR = ints[0];
    let whiteR = ints[1];
    let blackG = ints[2];
    let whiteG = ints[3];
    let blackB = ints[4];
    let whiteB = ints[5];

    LogUtil.debug(TAG, `getReferenceBlackWhiteDescription end, black: ${blackR}, ${blackG}, ${blackB}, white: ${whiteR}, ${whiteG}, ${whiteB}`);
    return "[%d,%d,%d] [%d,%d,%d]"
      .replace(/%d/, blackR)
      .replace(/%d/, blackG)
      .replace(/%d/, blackB)
      .replace(/%d/, whiteR)
      .replace(/%d/, whiteG)
      .replace(/%d/, whiteB)
    //
    //        return String.format("[%d,%d,%d] [%d,%d,%d]", blackR, blackG, blackB, whiteR, whiteG, whiteB);
  }

  /**
   * String description of CFA Pattern
   *
   * Indicates the color filter array (CFA) geometric pattern of the image sensor when a one-chip color area sensor is used.
   * It does not apply to all sensing methods.
   *
   * ExifDirectoryBase.TAG_CFA_PATTERN_2 holds only the pixel pattern. ExifDirectoryBase.TAG_CFA_REPEAT_PATTERN_DIM is expected to exist and pass
   * some conditional tests.
   */

  public getCfaPattern2Description(): string
  {
    LogUtil.debug(TAG, `getCfaPattern2Description enter`);
    let values: Int8Array = this._directory.getByteArray(ExifDirectoryBase.TAG_CFA_PATTERN_2);
    if (values == null) {
      LogUtil.error(TAG, `getCfaPattern2Description end, values is null`);
      return null;
    }

    let repeatPattern = this._directory.getIntArray(ExifDirectoryBase.TAG_CFA_REPEAT_PATTERN_DIM);
    if (repeatPattern == null)  {
      LogUtil.error(TAG, `getCfaPattern2Description end, repeatPattern is null`);
      return "Repeat Pattern not found for CFAPattern (%s)".replace(/%s/, super.getDescription(ExifDirectoryBase.TAG_CFA_PATTERN_2))
    }
    //            return String.format("Repeat Pattern not found for CFAPattern (%s)", super.getDescription(ExifDirectoryBase.TAG_CFA_PATTERN_2));

    if (repeatPattern.length == 2 && values.length == (repeatPattern[0] * repeatPattern[1])) {
      let intpattern = new Int8Array[2 + values.length];
      intpattern[0] = repeatPattern[0];
      intpattern[1] = repeatPattern[1];

      for (let i = 0; i < values.length; i++)
      intpattern[i + 2] = values[i] & 0xFF; // convert the values[i] byte to unsigned
      LogUtil.debug(TAG, `getCfaPattern2Description end, intpattern: ${intpattern}`);
      return ExifDescriptorBase.formatCFAPattern(intpattern);
    }
    LogUtil.warn(TAG, `getCfaPattern2Description end, invalid CFA pattern or repeat pattern`);
    return "Unknown Pattern (%s)".replace(/%s/, super.getDescription(ExifDirectoryBase.TAG_CFA_PATTERN_2))
    //        return String.format("Unknown Pattern (%s)", super.getDescription(ExifDirectoryBase.TAG_CFA_PATTERN_2));
  }

  private static formatCFAPattern(pattern: Int8Array): string
  {
    LogUtil.debug(TAG, `formatCFAPattern enter`);
    if (pattern == null) {
      LogUtil.error(TAG, `formatCFAPattern end, pattern is null`);
      return null;
    }
    if (pattern.length < 2) {
      LogUtil.error(TAG, `formatCFAPattern end, pattern length < 2`);
      return "<truncated data>";
    }
    if (pattern[0] == 0 && pattern[1] == 0) {
      LogUtil.error(TAG, `formatCFAPattern end, pattern size is 0`);
      return "<zero pattern size>";
    }

    let end = 2 + pattern[0] * pattern[1];
    if (end > pattern.length) {
      LogUtil.error(TAG, `formatCFAPattern end, pattern size is invalid`);
      return "<invalid pattern size>";
    }

    let cfaColors: Array<string> = ["Red", "Green", "Blue", "Cyan", "Magenta", "Yellow", "White"];

    let ret = '';
    ret + "[";
    for (let pos = 2; pos < end; pos++) {
      if (pattern[pos] <= cfaColors.length - 1)
      ret + cfaColors[pattern[pos]];
      else
      ret + "Unknown"; // indicated pattern position is outside the array bounds

      if ((pos - 2) % pattern[1] == 0)
      ret + ",";
      else if (pos != end - 1)
      ret + "][";
    }
    ret + "]";

    LogUtil.debug(TAG, `formatCFAPattern end, ret: ${ret}`);
    return ret;
  }

  public getExposureTimeDescription(): string
  {
    let value = this._directory.getString(ExifDirectoryBase.TAG_EXPOSURE_TIME);
    return value == null ? null : value + " sec";
  }

  public getFNumberDescription(): string
  {
    LogUtil.debug(TAG, `getFNumberDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_FNUMBER);
    if (value == null) {
      LogUtil.error(TAG, `getFNumberDescription end, value is null`);
      return null;
    }
    LogUtil.debug(TAG, `getFNumberDescription end, value: ${value}`);
    return TagDescriptor.getFStopDescription(value.numberValue());
  }

  public getExposureProgramDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_EXPOSURE_PROGRAM,
      1,
      "Manual control",
      "Program normal",
      "Aperture priority",
      "Shutter priority",
      "Program creative (slow program)",
      "Program action (high-speed program)",
      "Portrait mode",
      "Landscape mode"
    );
  }

  public getIsoEquivalentDescription(): string
  {
    // Have seen an exception here from files produced by ACDSEE that stored an int[] here with two values
    let isoEquiv = this._directory.getInteger(ExifDirectoryBase.TAG_ISO_EQUIVALENT);
    // There used to be a check here that multiplied ISO values < 50 by 200.
    // Issue 36 shows a smart-phone image from a Samsung Galaxy S2 with ISO-40.
    return isoEquiv != null
      ? isoEquiv
      : null;
  }

  public getSensitivityTypeRangeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SENSITIVITY_TYPE, null,
      "Unknown",
      "Standard Output Sensitivity",
      "Recommended Exposure Index",
      "ISO Speed",
      "Standard Output Sensitivity and Recommended Exposure Index",
      "Standard Output Sensitivity and ISO Speed",
      "Recommended Exposure Index and ISO Speed",
      "Standard Output Sensitivity, Recommended Exposure Index and ISO Speed"
    );
  }

  public getExifVersionDescription(): string
  {
    return this.getVersionBytesDescription(ExifDirectoryBase.TAG_EXIF_VERSION, 2);
  }

  public getComponentConfigurationDescription(): string
  {
    LogUtil.debug(TAG, `getComponentConfigurationDescription enter`);
    let components = this._directory.getIntArray(ExifDirectoryBase.TAG_COMPONENTS_CONFIGURATION);
    if (components == null) {
      LogUtil.error(TAG, `getComponentConfigurationDescription end, components is null`);
      return null;
    }
    let componentStrings = ["", "Y", "Cb", "Cr", "R", "G", "B"];
    let componentConfig = '';
    for (let i = 0; i < Math.min(4, components.length); i++) {
      let j = components[i];
      if (j > 0 && j < componentStrings.length) {
        componentConfig + componentStrings[j];
      }
    }
    LogUtil.debug(TAG, `getComponentConfigurationDescription end, componentConfig: ${componentConfig}`);
    return componentConfig;
  }

  public getCompressedAverageBitsPerPixelDescription(): string
  {
    LogUtil.debug(TAG, `getCompressedAverageBitsPerPixelDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_COMPRESSED_AVERAGE_BITS_PER_PIXEL);
    if (value == null) {
      LogUtil.error(TAG, `getCompressedAverageBitsPerPixelDescription end, value is null`);
      return null;
    }
    let ratio = value.toSimpleString(this._allowDecimalRepresentationOfRationals);
    LogUtil.debug(TAG, `getCompressedAverageBitsPerPixelDescription end, value: ${value}, ratio: ${ratio}`);
    return value.isInteger() && value.numberValue() == 1
      ? ratio + " bit/pixel"
      : ratio + " bits/pixel";
  }

  public getShutterSpeedDescription(): string
  {
    return super.getShutterSpeedDescription(ExifDirectoryBase.TAG_SHUTTER_SPEED);
  }

  public getApertureValueDescription(): string
  {
    LogUtil.debug(TAG, `getApertureValueDescription enter`);
    let aperture = this._directory.getDoubleObject(ExifDirectoryBase.TAG_APERTURE);
    if (aperture == null) {
      LogUtil.error(TAG, `getApertureValueDescription end, aperture is null`);
      return null;
    }
    let fStop = PhotographicConversions.apertureToFStop(aperture);
    LogUtil.debug(TAG, `getApertureValueDescription end, fStop: ${fStop}`);
    return TagDescriptor.getFStopDescription(fStop);
  }

  public getBrightnessValueDescription(): string
  {
    LogUtil.debug(TAG, `getBrightnessValueDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_BRIGHTNESS_VALUE);
    if (value == null) {
      LogUtil.error(TAG, `getBrightnessValueDescription end, value is null`);
      return null;
    }
    if (value.getNumerator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getBrightnessValueDescription end, value is unknown`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getBrightnessValueDescription end, value: ${value}`);
    return value.numberValue().toFixed(3)
    //        DecimalFormat formatter = new DecimalFormat("0.0##");
    //        return formatter.format(value.doubleValue());

  }

  public getExposureBiasDescription(): string
  {
    LogUtil.debug(TAG, `getExposureBiasDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_EXPOSURE_BIAS);
    if (value == null) {
      LogUtil.error(TAG, `getExposureBiasDescription end, value is null`);
      return null;
    }
    LogUtil.debug(TAG, `getExposureBiasDescription end, value: ${value}`);
    return value.toSimpleString(true) + " EV";
  }

  public getMaxApertureValueDescription(): string
  {
    LogUtil.debug(TAG, `getMaxApertureValueDescription enter`);
    let aperture = this._directory.getDoubleObject(ExifDirectoryBase.TAG_MAX_APERTURE);
    if (aperture == null) {
      LogUtil.error(TAG, `getMaxApertureValueDescription end, aperture is null`);
      return null;
    }
    let fStop = PhotographicConversions.apertureToFStop(aperture);
    LogUtil.debug(TAG, `getMaxApertureValueDescription end, fStop: ${fStop}`);
    return TagDescriptor.getFStopDescription(fStop);
  }

  public getSubjectDistanceDescription(): string
  {
    LogUtil.debug(TAG, `getSubjectDistanceDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_SUBJECT_DISTANCE);
    if (value == null) {
      LogUtil.error(TAG, `getSubjectDistanceDescription end, value is null`);
      return null;
    }
    if (value.getNumerator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getSubjectDistanceDescription end, value is unknown`);
      return "Infinity";
    }
    if (value.getNumerator() == 0) {
      LogUtil.error(TAG, `getSubjectDistanceDescription end, value is zero`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getSubjectDistanceDescription end, value: ${value}`);
    return value.numberValue().toFixed(3) + " metres"
    //        DecimalFormat formatter = new DecimalFormat("0.0##");
    //        return formatter.format(value.doubleValue()) + " metres";
  }

  public getMeteringModeDescription(): string
  {
    // '0' means unknown, '1' average, '2' center weighted average, '3' spot
    // '4' multi-spot, '5' multi-segment, '6' partial, '255' other
    LogUtil.debug(TAG, `getMeteringModeDescription enter`);
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_METERING_MODE);
    if (value == null) {
      LogUtil.error(TAG, `getMeteringModeDescription end, value is null`);
      return null;
    }
    LogUtil.debug(TAG, `getMeteringModeDescription end, value: ${value}`);
    switch (value) {
      case 0:
        return "Unknown";
      case 1:
        return "Average";
      case 2:
        return "Center weighted average";
      case 3:
        return "Spot";
      case 4:
        return "Multi-spot";
      case 5:
        return "Multi-segment";
      case 6:
        return "Partial";
      case 255:
        return "(Other)";
      default:
        return "Unknown (" + value + ")";
    }
  }


  //    public getWhiteBalanceDescription():string
  //    {
  //        let value = this._directory.getInteger(ExifDirectoryBase.TAG_WHITE_BALANCE);
  //        if (value == null)
  //            return null;
  //        return this.getWhiteBalanceDescription(value);
  //    }

  public static getWhiteBalanceDescription(value?: number): string
  {
    LogUtil.debug(TAG, `getWhiteBalanceDescription enter`);
    if ((value == null) || (value == undefined)) {
      LogUtil.error(TAG, `getWhiteBalanceDescription end, value is null`);
      //            let value = new Directory().getInteger(ExifDirectoryBase.TAG_WHITE_BALANCE);
      //            if (value == null)
      return null;
    }
    // See http://web.archive.org/web/20131018091152/http://exif.org/Exif2-2.PDF page 35

    LogUtil.debug(TAG, `getWhiteBalanceDescription end, value: ${value}`);
    switch (value) {
      case 0:
        return "Unknown";
      case 1:
        return "Daylight";
      case 2:
        return "Florescent";
      case 3:
        return "Tungsten (Incandescent)";
      case 4:
        return "Flash";
      case 9:
        return "Fine Weather";
      case 10:
        return "Cloudy";
      case 11:
        return "Shade";
      case 12:
        return "Daylight Fluorescent"; // (D 5700 - 7100K)
      case 13:
        return "Day White Fluorescent"; // (N 4600 - 5500K)
      case 14:
        return "Cool White Fluorescent"; // (W 3800 - 4500K)
      case 15:
        return "White Fluorescent"; // (WW 3250 - 3800K)
      case 16:
        return "Warm White Fluorescent"; // (L 2600 - 3250K)
      case 17:
        return "Standard light A";
      case 18:
        return "Standard light B";
      case 19:
        return "Standard light C";
      case 20:
        return "D55";
      case 21:
        return "D65";
      case 22:
        return "D75";
      case 23:
        return "D50";
      case 24:
        return "ISO Studio Tungsten";
      case 255:
        return "Other";
      default:
        return "Unknown (" + value + ")";
    }
  }

  public getFlashDescription(): string
  {
    /*
     * This is a bit mask.
     * 0 = flash fired
     * 1 = return detected
     * 2 = return able to be detected
     * 3 = unknown
     * 4 = auto used
     * 5 = unknown
     * 6 = red eye reduction used
     */

    LogUtil.debug(TAG, `getFlashDescription enter`);
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_FLASH);

    if (value == null) {
      LogUtil.error(TAG, `getFlashDescription end, value is null`);
      return null;
    }

    let sb = '';

    if ((value & 0x1) != 0)
    sb + "Flash fired";
    else
    sb + "Flash did not fire";

    // check if we're able to detect a return, before we mention it
    if ((value & 0x4) != 0) {
      if ((value & 0x2) != 0)
      sb + ", return detected";
      else
      sb + ", return not detected";
    }

    // If 0x10 is set and the lowest byte is not zero - then flash is Auto
    if ((value & 0x10) != 0 && (value & 0x0F) != 0)
    sb + ", auto";

    if ((value & 0x40) != 0)
    sb + ", red-eye reduction";

    LogUtil.debug(TAG, `getFlashDescription end, value: ${value}, sb: ${sb}`);
    return sb;
  }

  public getFocalLengthDescription(): string
  {
    let value = this._directory.getRational(ExifDirectoryBase.TAG_FOCAL_LENGTH);
    return value == null ? null : TagDescriptor.getFocalLengthDescription(value.numberValue());
  }

  public getUserCommentDescription(): string
  {
    return this.getEncodedTextDescription(ExifDirectoryBase.TAG_USER_COMMENT);
  }

  public getTemperatureDescription(): string
  {
    LogUtil.debug(TAG, `getTemperatureDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_TEMPERATURE);
    if (value == null) {
      LogUtil.error(TAG, `getTemperatureDescription end, value is null`);
      return null;
    }
    if (value.getDenominator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getTemperatureDescription end, value is unknown`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getTemperatureDescription end, value: ${value}`);
    return value.numberValue().toFixed(1) + " °C"
    //        DecimalFormat formatter = new DecimalFormat("0.0");
    //        return formatter.format(value.doubleValue()) + " °C";
  }

  public getHumidityDescription(): string
  {
    LogUtil.debug(TAG, `getHumidityDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_HUMIDITY);
    if (value == null) {
      LogUtil.error(TAG, `getHumidityDescription end, value is null`);
      return null;
    }
    if (value.getDenominator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getHumidityDescription end, value is unknown`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getHumidityDescription end, value: ${value}`);
    return value.numberValue().toFixed(1) + " %"
    //        DecimalFormat formatter = new DecimalFormat("0.0");
    //        return formatter.format(value.doubleValue()) + " %";
  }

  public getPressureDescription(): string
  {
    LogUtil.debug(TAG, `getPressureDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_PRESSURE);
    if (value == null) {
      LogUtil.error(TAG, `getPressureDescription end, value is null`);
      return null;
    }
    if (value.getDenominator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getPressureDescription end, value is unknown`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getPressureDescription end, value: ${value}`);
    return value.numberValue().toFixed(1) + " hPa"

    //        DecimalFormat formatter = new DecimalFormat("0.0");
    //        return formatter.format(value.doubleValue()) + " hPa";
  }

  public getWaterDepthDescription(): string
  {
    LogUtil.debug(TAG, `getWaterDepthDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_WATER_DEPTH);
    if (value == null) {
      LogUtil.error(TAG, `getWaterDepthDescription end, value is null`);
      return null;
    }
    if (value.getDenominator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getWaterDepthDescription end, value is unknown`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getWaterDepthDescription end, value: ${value}`);
    return value.numberValue().toFixed(3) + " metres"
    //        DecimalFormat formatter = new DecimalFormat("0.0##");
    //        return formatter.format(value.doubleValue()) + " metres";
  }

  public getAccelerationDescription(): string
  {
    LogUtil.debug(TAG, `getAccelerationDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_ACCELERATION);
    if (value == null) {
      LogUtil.error(TAG, `getAccelerationDescription end, value is null`);
      return null;
    }
    if (value.getDenominator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getAccelerationDescription end, value is unknown`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getAccelerationDescription end, value: ${value}`);
    return value.numberValue().toFixed(3) + " mGal"
    //        DecimalFormat formatter = new DecimalFormat("0.0##");
    //        return formatter.format(value.doubleValue()) + " mGal";
  }

  public getCameraElevationAngleDescription(): string
  {
    LogUtil.debug(TAG, `getCameraElevationAngleDescription enter`);
    let value = this._directory.getRational(ExifDirectoryBase.TAG_CAMERA_ELEVATION_ANGLE);
    if (value == null) {
      LogUtil.error(TAG, `getCameraElevationAngleDescription end, value is null`);
      return null;
    }
    if (value.getDenominator() == 0xFFFFFFFF) {
      LogUtil.error(TAG, `getCameraElevationAngleDescription end, value is unknown`);
      return "Unknown";
    }
    LogUtil.debug(TAG, `getCameraElevationAngleDescription end, value: ${value}`);
    return value.numberValue().toFixed(3) + " degrees"
    //        DecimalFormat formatter = new DecimalFormat("0.##");
    //        return formatter.format(value.doubleValue()) + " degrees";
  }

  /** The Windows specific tags uses plain Unicode. */

  private getUnicodeDescription(tag: number): string
  {
    LogUtil.debug(TAG, `getUnicodeDescription enter`);
    let bytes: Int8Array = this._directory.getByteArray(tag);
    if (bytes == null) {
      LogUtil.error(TAG, `getUnicodeDescription end, bytes is null`);
      return null;
    }
    try {
      // Decode the unicode string and trim the unicode zero "\0" from the end.
      //            return new String(bytes, "UTF-16LE").trim();
      LogUtil.debug(TAG, `getUnicodeDescription end, bytes: ${bytes}`);
      return StringUtil.utf8ByteToUnicodeStr(bytes)
    } catch (e) {
      LogUtil.error(TAG, `getUnicodeDescription end, error: ${JSON.stringify(e)}`);
      return null;
    }
  }

  public getWindowsTitleDescription(): string
  {
    return this.getUnicodeDescription(ExifDirectoryBase.TAG_WIN_TITLE);
  }

  public getWindowsCommentDescription(): string
  {
    return this.getUnicodeDescription(ExifDirectoryBase.TAG_WIN_COMMENT);
  }

  public getWindowsAuthorDescription(): string
  {
    return this.getUnicodeDescription(ExifDirectoryBase.TAG_WIN_AUTHOR);
  }

  public getWindowsKeywordsDescription(): string
  {
    return this.getUnicodeDescription(ExifDirectoryBase.TAG_WIN_KEYWORDS);
  }

  public getWindowsSubjectDescription(): string
  {
    return this.getUnicodeDescription(ExifDirectoryBase.TAG_WIN_SUBJECT);
  }

  public getFlashPixVersionDescription(): string
  {
    return this.getVersionBytesDescription(ExifDirectoryBase.TAG_FLASHPIX_VERSION, 2);
  }

  public getColorSpaceDescription(): string
  {
    LogUtil.debug(TAG, `getColorSpaceDescription enter`);
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_COLOR_SPACE);
    if (value == null) {
      LogUtil.error(TAG, `getColorSpaceDescription end, value is null`);
      return null;
    }
    if (value == 1) {
      LogUtil.debug(TAG, `getColorSpaceDescription end, value: ${value}, sRGB`);
      return "sRGB";
    }
    if (value == 65535) {
      LogUtil.debug(TAG, `getColorSpaceDescription end, value: ${value}, Uncalibrated`);
      return "Undefined";
    }
    LogUtil.warn(TAG, `getColorSpaceDescription end, value: ${value}, Unknown`);
    return "Unknown (" + value + ")";
  }

  public getExifImageWidthDescription(): string
  {
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_EXIF_IMAGE_WIDTH);
    return value == null ? null : value + " pixels";
  }

  public getExifImageHeightDescription(): string
  {
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_EXIF_IMAGE_HEIGHT);
    return value == null ? null : value + " pixels";
  }

  public getFocalPlaneXResolutionDescription(): string
  {
    LogUtil.debug(TAG, `getFocalPlaneXResolutionDescription enter`);
    let rational = this._directory.getRational(ExifDirectoryBase.TAG_FOCAL_PLANE_X_RESOLUTION);
    if (rational == null) {
      LogUtil.error(TAG, `getFocalPlaneXResolutionDescription end, rational is null`);
      return null;
    }
    let unit = this.getFocalPlaneResolutionUnitDescription();
    LogUtil.debug(TAG, `getFocalPlaneXResolutionDescription end, rational: ${rational}, unit: ${unit}`);
    return rational.getReciprocal().toSimpleString(this._allowDecimalRepresentationOfRationals)
    + (unit == null ? "" : " " + unit.toLowerCase());
  }

  public getFocalPlaneYResolutionDescription(): string
  {
    LogUtil.debug(TAG, `getFocalPlaneYResolutionDescription enter`);
    let rational = this._directory.getRational(ExifDirectoryBase.TAG_FOCAL_PLANE_Y_RESOLUTION);
    if (rational == null) {
      LogUtil.error(TAG, `getFocalPlaneYResolutionDescription end, rational is null`);
      return null;
    }
    let unit = this.getFocalPlaneResolutionUnitDescription();
    LogUtil.debug(TAG, `getFocalPlaneYResolutionDescription end, rational: ${rational}, unit: ${unit}`);
    return rational.getReciprocal().toSimpleString(this._allowDecimalRepresentationOfRationals)
    + (unit == null ? "" : " " + unit.toLowerCase());
  }

  public getFocalPlaneResolutionUnitDescription(): string
  {
    // Unit of FocalPlaneXResolution/FocalPlaneYResolution.
    // '1' means no-unit, '2' inch, '3' centimeter.
    return this.getIndexedDescription(ExifDirectoryBase.TAG_FOCAL_PLANE_RESOLUTION_UNIT,
      1,
      "(No unit)",
      "Inches",
      "cm"
    );
  }

  public getSensingMethodDescription(): string
  {
    // '1' Not defined, '2' One-chip color area sensor, '3' Two-chip color area sensor
    // '4' Three-chip color area sensor, '5' Color sequential area sensor
    // '7' Trilinear sensor '8' Color sequential linear sensor,  'Other' reserved
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SENSING_METHOD,
      1,
      "(Not defined)",
      "One-chip color area sensor",
      "Two-chip color area sensor",
      "Three-chip color area sensor",
      "Color sequential area sensor",
      null,
      "Trilinear sensor",
      "Color sequential linear sensor"
    );
  }

  public getFileSourceDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_FILE_SOURCE,
      1,
      "Film Scanner",
      "Reflection Print Scanner",
      "Digital Still Camera (DSC)"
    );
  }

  public getSceneTypeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SCENE_TYPE,
      1,
      "Directly photographed image"
    );
  }

  /**
   * String description of CFA Pattern
   *
   * Converted from Exiftool version 10.33 created by Phil Harvey
   * http://www.sno.phy.queensu.ca/~phil/exiftool/
   * lib\Image\ExifTool\Exif.pm
   *
   * Indicates the color filter array (CFA) geometric pattern of the image sensor when a one-chip color area sensor is used.
   * It does not apply to all sensing methods.
   */

  public getCfaPatternDescription(): string
  {
    return ExifDescriptorBase.formatCFAPattern(this.decodeCfaPattern(ExifDirectoryBase.TAG_CFA_PATTERN));
  }

  /**
   * Decode raw CFAPattern value
   *
   * Converted from Exiftool version 10.33 created by Phil Harvey
   * http://www.sno.phy.queensu.ca/~phil/exiftool/
   * lib\Image\ExifTool\Exif.pm
   *
   * The value consists of:
   * - Two short, being the grid width and height of the repeated pattern.
   * - Next, for every pixel in that pattern, an identification code.
   */

  private decodeCfaPattern(tagType: number): Int8Array
  {
    LogUtil.debug(TAG, `decodeCfaPattern enter`);
    let ret: Int8Array;

    let values: Int8Array = this._directory.getByteArray(tagType);
    if (values == null) {
      LogUtil.error(TAG, `decodeCfaPattern end, values is null`);
      return null;
    }

    if (values.length < 4) {
      ret = new Int8Array[values.length];
      for (let i = 0; i < values.length; i++)
      ret[i] = values[i];
      LogUtil.debug(TAG, `decodeCfaPattern end, values length is less than 4, create new array: ${ret}`);
      return ret;
    }

    ret = new Int8Array[values.length - 2];

    try {
      let reader = new ByteArrayReader(values);

      // first two values should be read as 16-bits (2 bytes)
      let item0 = reader.getInt16(0);
      let item1 = reader.getInt16(2);

      let copyArray: boolean = false;
      let end = 2 + item0 * item1;
      if (end > values.length) // sanity check in case of byte order problems; calculated 'end' should be <= length of the values
      {
        // try swapping byte order (I have seen this order different than in EXIF)
        reader.setMotorolaByteOrder(!reader.isMotorolaByteOrder());
        item0 = reader.getInt16(0);
        item1 = reader.getInt16(2);

        if (values.length >= (2 + item0 * item1))
        copyArray = true;
      }
      else
      copyArray = true;

      if (copyArray) {
        ret[0] = item0;
        ret[1] = item1;

        for (let i = 4; i < values.length; i++)
        ret[i - 2] = reader.getInt8(i);
      }
    } catch (e) {
      LogUtil.error(TAG, `decodeCfaPattern end, error: ${JSON.stringify(e)}`);
      this._directory.addError("IO exception processing data: " + e.getMessage());
    }

    LogUtil.debug(TAG, `decodeCfaPattern end, ret: ${ret}`);
    return ret;
  }

  public getCustomRenderedDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_CUSTOM_RENDERED, null,
      "Normal process",
      "Custom process"
    );
  }

  public getExposureModeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_EXPOSURE_MODE, null,
      "Auto exposure",
      "Manual exposure",
      "Auto bracket"
    );
  }

  public getWhiteBalanceModeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_WHITE_BALANCE_MODE, null,
      "Auto white balance",
      "Manual white balance"
    );
  }

  public getDigitalZoomRatioDescription(): string
  {
    let value = this._directory.getRational(ExifDirectoryBase.TAG_DIGITAL_ZOOM_RATIO);
    return value == null
      ? null
      : value.getNumerator() == 0
          ? "Digital zoom not used"
          : value.numberValue().toFixed(1);
    //                : new DecimalFormat("0.#").format(value.doubleValue());
  }

  public get35mmFilmEquivFocalLengthDescription(): string
  {
    let value = this._directory.getInteger(ExifDirectoryBase.TAG_35MM_FILM_EQUIV_FOCAL_LENGTH);
    return value == null
      ? null
      : value == 0
          ? "Unknown"
          : TagDescriptor.getFocalLengthDescription(value);
  }

  public getSceneCaptureTypeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SCENE_CAPTURE_TYPE, null,
      "Standard",
      "Landscape",
      "Portrait",
      "Night scene"
    );
  }

  public getGainControlDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_GAIN_CONTROL, null,
      "None",
      "Low gain up",
      "Low gain down",
      "High gain up",
      "High gain down"
    );
  }

  public getContrastDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_CONTRAST, null,
      "None",
      "Soft",
      "Hard"
    );
  }

  public getSaturationDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SATURATION, null,
      "None",
      "Low saturation",
      "High saturation"
    );
  }

  public getSharpnessDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SHARPNESS, null,
      "None",
      "Low",
      "Hard"
    );
  }

  public getSubjectDistanceRangeDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_SUBJECT_DISTANCE_RANGE, null,
      "Unknown",
      "Macro",
      "Close view",
      "Distant view"
    );
  }

  public getLensSpecificationDescription(): string
  {
    return super.getLensSpecificationDescription(ExifDirectoryBase.TAG_LENS_SPECIFICATION);
  }

  public getExtraSamplesDescription(): string
  {
    return this.getIndexedDescription(ExifDirectoryBase.TAG_EXTRA_SAMPLES, null,
      "Unspecified",
      "Associated alpha",
      "Unassociated alpha"
    );
  }

  public getSampleFormatDescription(): string
  {
    LogUtil.debug(TAG, `getSampleFormatDescription enter`);
    let values = this._directory.getIntArray(ExifDirectoryBase.TAG_SAMPLE_FORMAT);

    if (values == null) {
      LogUtil.error(TAG, `getSampleFormatDescription end, values is null`);
      return null;
    }

    let sb = '';

    for (let value of values) {
      if (sb.length != 0)
      sb + ", ";
      switch (value) {
        case 1:
          sb + "Unsigned";
          break;
        case 2:
          sb + "Signed";
          break;
        case 3:
          sb + "Float";
          break;
        case 4:
          sb + "Undefined";
          break;
        case 5:
          sb + "Complex int";
          break;
        case 6:
          sb + "Complex float";
          break;
        default:
          sb + "Unknown (" + value + ")";
          break;
      }
    }

    LogUtil.debug(TAG, `getSampleFormatDescription end, sb: ${sb}`);
    return sb;
  }
}

export default ExifDescriptorBase

