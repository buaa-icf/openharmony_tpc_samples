/*
Copyright (c) 2026 Huawei Device Co., Ltd.
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

/**
 * Common constants for the XMP Toolkit.
 */
export default class XMPConst {
  // ---------------------------------------------------------------------------------------------
  // Standard namespace URI constants


  // Standard namespaces

  /** The XML namespace for XML. */
  static NS_XML = "http://www.w3.org/XML/1998/namespace";
  /** The XML namespace for RDF. */
  static NS_RDF = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
  /** The XML namespace for the Dublin Core schema. */
  static NS_DC = "http://purl.org/dc/elements/1.1/";
  /** The XML namespace for the IPTC Core schema. */
  static NS_IPTCCORE = "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/";
  /** The XML namespace for the IPTC Extension schema. */
  static NS_IPTCEXT = "http://iptc.org/std/Iptc4xmpExt/2008-02-29/";
  /** The XML namespace for the DICOM medical schema. */
  static NS_DICOM = "http://ns.adobe.com/DICOM/";
  /** The XML namespace for the PLUS (Picture Licensing Universal System, http://www.useplus.org) */
  static NS_PLUS = "http://ns.useplus.org/ldf/xmp/1.0/";
  // Adobe standard namespaces

  /** The XML namespace Adobe XMP Metadata. */
  static NS_X = "adobe:ns:meta/";
  /** */
  static NS_IX = "http://ns.adobe.com/iX/1.0/";
  /** The XML namespace for the XMP "basic" schema. */
  static NS_XMP = "http://ns.adobe.com/xap/1.0/";
  /** The XML namespace for the XMP copyright schema. */
  static NS_XMP_RIGHTS = "http://ns.adobe.com/xap/1.0/rights/";
  /** The XML namespace for the XMP digital asset management schema. */
  static NS_XMP_MM = "http://ns.adobe.com/xap/1.0/mm/";
  /** The XML namespace for the job management schema. */
  static NS_XMP_BJ = "http://ns.adobe.com/xap/1.0/bj/";
  /** The XML namespace for the job management schema. */
  static NS_XMP_NOTE = "http://ns.adobe.com/xmp/note/";
  /** The XML namespace for the PDF schema. */
  static NS_PDF = "http://ns.adobe.com/pdf/1.3/";
  /** The XML namespace for the PDF schema. */
  static NS_PDFX = "http://ns.adobe.com/pdfx/1.3/";
  /** */
  static NS_PDFX_ID = "http://www.npes.org/pdfx/ns/id/";
  /** */
  static NS_PDFA_SCHEMA = "http://www.aiim.org/pdfa/ns/schema#";
  /** */
  static NS_PDFA_PROPERTY = "http://www.aiim.org/pdfa/ns/property#";
  /** */
  static NS_PDFA_TYPE = "http://www.aiim.org/pdfa/ns/type#";
  /** */
  static NS_PDFA_FIELD = "http://www.aiim.org/pdfa/ns/field#";
  /** */
  static NS_PDFA_ID = "http://www.aiim.org/pdfa/ns/id/";
  /** */
  static NS_PDFA_EXTENSION = "http://www.aiim.org/pdfa/ns/extension/";
  /** The XML namespace for the Photoshop custom schema. */
  static NS_PHOTOSHOP = "http://ns.adobe.com/photoshop/1.0/";
  /** The XML namespace for the Photoshop Album schema. */
  static NS_PSALBUM = "http://ns.adobe.com/album/1.0/";
  /** The XML namespace for Adobe's EXIF schema. */
  static NS_EXIF = "http://ns.adobe.com/exif/1.0/";
  /** NS for the CIPA XMP for Exif document v1.1 */
  static NS_EXIFX = "http://cipa.jp/exif/1.0/";
  /** */
  static NS_EXIF_AUX = "http://ns.adobe.com/exif/1.0/aux/";
  /** The XML namespace for Adobe's TIFF schema. */
  static NS_TIFF = "http://ns.adobe.com/tiff/1.0/";
  /** */
  static NS_PNG = "http://ns.adobe.com/png/1.0/";
  /** */
  static NS_JPEG = "http://ns.adobe.com/jpeg/1.0/";
  /** */
  static NS_JP2K = "http://ns.adobe.com/jp2k/1.0/";
  /** */
  static NS_CAMERARAW = "http://ns.adobe.com/camera-raw-settings/1.0/";
  /** */
  static NS_ADOBESTOCKPHOTO = "http://ns.adobe.com/StockPhoto/1.0/";
  /** */
  static NS_CREATOR_ATOM = "http://ns.adobe.com/creatorAtom/1.0/";
  /** */
  static NS_ASF = "http://ns.adobe.com/asf/1.0/";
  /** */
  static NS_WAV = "http://ns.adobe.com/xmp/wav/1.0/";
  /** BExt Schema */
  static NS_BWF = "http://ns.adobe.com/bwf/bext/1.0/";
  /** RIFF Info Schema */
  static NS_RIFFINFO = "http://ns.adobe.com/riff/info/";
  /** */
  static NS_SCRIPT = "http://ns.adobe.com/xmp/1.0/Script/";
  /** Transform XMP */
  static NS_TXMP = "http://ns.adobe.com/TransformXMP/";
  /** Adobe Flash SWF */
  static NS_SWF = "http://ns.adobe.com/swf/1.0/";
  // XMP namespaces that are Adobe private

  /** */
  static NS_DM = "http://ns.adobe.com/xmp/1.0/DynamicMedia/";
  /** */
  static NS_TRANSIENT = "http://ns.adobe.com/xmp/transient/1.0/";
  /** legacy Dublin Core NS, will be converted to NS_DC */
  static NS_DC_DEPRECATED = "http://purl.org/dc/1.1/";
  // XML namespace constants for qualifiers and structured property fields.

  /** The XML namespace for qualifiers of the xmp:Identifier property. */
  static TYPE_IDENTIFIERQUAL = "http://ns.adobe.com/xmp/Identifier/qual/1.0/";
  /** The XML namespace for fields of the Dimensions type. */
  static TYPE_DIMENSIONS = "http://ns.adobe.com/xap/1.0/sType/Dimensions#";
  /** */
  static TYPE_TEXT = "http://ns.adobe.com/xap/1.0/t/";
  /** */
  static TYPE_PAGEDFILE = "http://ns.adobe.com/xap/1.0/t/pg/";
  /** */
  static TYPE_GRAPHICS = "http://ns.adobe.com/xap/1.0/g/";
  /** The XML namespace for fields of a graphical image. Used for the Thumbnail type. */
  static TYPE_IMAGE = "http://ns.adobe.com/xap/1.0/g/img/";
  /** */
  static TYPE_FONT = "http://ns.adobe.com/xap/1.0/sType/Font#";
  /** The XML namespace for fields of the ResourceEvent type. */
  static TYPE_RESOURCEEVENT = "http://ns.adobe.com/xap/1.0/sType/ResourceEvent#";
  /** The XML namespace for fields of the ResourceRef type. */
  static TYPE_RESOURCEREF = "http://ns.adobe.com/xap/1.0/sType/ResourceRef#";
  /** The XML namespace for fields of the Version type. */
  static TYPE_ST_VERSION = "http://ns.adobe.com/xap/1.0/sType/Version#";
  /** The XML namespace for fields of the JobRef type. */
  static TYPE_ST_JOB = "http://ns.adobe.com/xap/1.0/sType/Job#";
  /** */
  static TYPE_MANIFESTITEM = "http://ns.adobe.com/xap/1.0/sType/ManifestItem#";
  // ---------------------------------------------------------------------------------------------
  // Basic types and constants

  /**
   * The canonical true string value for Booleans in serialized XMP. Code that converts from the
   * string to a bool should be case insensitive, and even allow "1".
   */
  static TRUESTR = "True";
  /**
   * The canonical false string value for Booleans in serialized XMP. Code that converts from the
   * string to a bool should be case insensitive, and even allow "0".
   */
  static FALSESTR = "False";
  /** Index that has the meaning to be always the last item in an array. */
  static ARRAY_LAST_ITEM = -1;
  /** Node name of an array item. */
  static ARRAY_ITEM_NAME = "[]";
  /** The x-default string for localized properties */
  static X_DEFAULT = "x-default";
  /** xml:lang qualfifier */
  static XML_LANG = "xml:lang";
  /** rdf:type qualfifier */
  static RDF_TYPE = "rdf:type";
  /** Processing Instruction (PI) for xmp packet */
  static XMP_PI = "xpacket";
  /** XMP meta tag version new */
  static TAG_XMPMETA = "xmpmeta";
  /** XMP meta tag version old */
  static TAG_XAPMETA = "xapmeta";
}

