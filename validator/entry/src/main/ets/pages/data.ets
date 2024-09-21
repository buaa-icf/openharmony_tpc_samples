/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
const array: Array<SelectOption> = [
  { value: 'crc32' }, { value: 'crc32b' }, { value: 'md4' }, { value: 'md5' }, { value: 'ripemd128' },
  { value: 'ripemd160' }, { value: 'sha1' }, { value: 'sha256' }, { value: 'sha384' }, { value: 'sha512' },
  { value: 'tiger128' }, { value: 'tiger160' }, { value: 'tiger192' }
]
const LicensePlateArray: Array<SelectOption> = [
  { value: 'es-AR' }, { value: 'de-DE' }, { value: 'de-LI' }, { value: 'en-IN' }, { value: 'cs-CZ' },
  { value: 'hu-HU' }, { value: 'pt-BR' }, { value: 'pt-PT' }, { value: 'sq-AL' }, { value: 'sv-SE' },
  { value: 'any' }
]
const IDCardArray: Array<SelectOption> = [
  { value: 'LK' }, { value: 'PL' }, { value: 'ES' }, { value: 'FI' }, { value: 'IN' },
  { value: 'IT' }, { value: 'IR' }, { value: 'MZ' }, { value: 'NO' }, { value: 'TH' },
  { value: 'zh-TW' }, { value: 'he-IL' }, { value: 'ar-LY' }, { value: 'ar-TN' },
  { value: 'zh-CN' }, { value: 'zh-HK' }, { value: 'any' }
]

const TaxIDArray:Array<SelectOption> = [
  { value: 'bg-BG' }, { value: 'cs-CZ' }, { value: 'de-AT' }, { value: 'de-DE' }, { value: 'dk-DK' },
  { value: 'el-CY' }, { value: 'el-GR' }, { value: 'en-CA' }, { value: 'en-GB' }, { value: 'en-IE' },
  { value: 'en-US' }, { value: 'es-ES' }, { value: 'et-EE' }, { value: 'fi-FI' },
  { value: 'fr-BE' }, { value: 'fr-CA' }, { value: 'fr-FR' }
]
const VATArray: Array<SelectOption> = [
  { value: 'AT' }, { value: 'AL' }, { value: 'AR' }, { value: 'AU' }, { value: 'BE' },
  { value: 'BG' }, { value: 'BO' }, { value: 'BR' }, { value: 'BY' }, { value: 'CA' },
  { value: 'CH' }, { value: 'CL' }, { value: 'CO' }, { value: 'CR' }, { value: 'CY' },
  { value: 'CZ' }, { value: 'DE' }, { value: 'DK' }, { value: 'DO' }, { value: 'EC' },
  { value: 'EE' }, { value: 'EL' }, { value: 'ES' }, { value: 'FI' }, { value: 'FR' },
  { value: 'GB' }, { value: 'GT' }, { value: 'HN' }, { value: 'HR' }, { value: 'HU' },
  { value: 'ID' }, { value: 'IE' }, { value: 'IL' }, { value: 'IN' }, { value: 'IS' },
  { value: 'IT' }, { value: 'KZ' }, { value: 'LT' }, { value: 'LU' }, { value: 'LV' },
  { value: 'MK' }, { value: 'MT' }, { value: 'MX' }, { value: 'NG' }, { value: 'NI' },
]
const PostalCodeArray: Array<SelectOption> = [
  { value: 'AU' }, { value: 'AT' }, { value: 'AD' }, { value: 'BA' }, { value: 'BE' },
  { value: 'BG' }, { value: 'BR' }, { value: 'BY' }, { value: 'CA' },{ value: 'CH' },
  { value: 'CN' }, { value: 'CZ' }, { value: 'DE' }, { value: 'DK' }, { value: 'DO' },
  { value: 'DZ' }, { value: 'EE' }, { value: 'ES' }, { value: 'FI' }, { value: 'FR' },
  { value: 'GB' }, { value: 'GR' }, { value: 'HR' }, { value: 'HU' },{ value: 'any' },
]
export  interface  dataType{
  text:Resource
  str:string
  str1?:string
  default?:string
  local?: SelectOption[]
  min?:number
  max?:number
  values?: string[]
  IPVersion?: number
  mode:string
}
let  data:dataType[] = [
  { text:$r("app.string.text_title_1"), str:"ZG======",mode:"isBase32" },
  { text:$r("app.string.text_title_2"), str:"91GHkLMNtyo98",mode:"isBase58" },
  { text:$r("app.string.text_title_3"), str:"Zm9vYmFy",mode:"isBase64" },
  { text:$r("app.string.text_title_4"), str:"foobar",mode:"isAscii" },
  { text:$r("app.string.text_title_5"), str:"SBICKEN1345",mode:"isBIC" },
  { text:$r("app.string.text_title_6"), str:"true",mode:"isBoolean" },
  { text:$r("app.string.text_title_7"), str:"1MUz4VMYui5qY1mxUiG8BQ1Luv6tqkvaiL",mode:"isBtcAddress" },
  { text:$r("app.string.text_title_8"), str:"375556917985515",mode:"isCreditCard" },
  { text:$r("app.string.text_title_9"), str:"$10,123",mode:"isCurrency" },
  { text:$r("app.string.text_title_10"), str:"data:text/html;charset=US-ASCII,%3Ch1%3EHello!%3C%2Fh1%3E",mode:"isDataURI" },
  { text:$r("app.string.text_title_11"), str:"2020/02/29",mode:"isDate" },
  { text:$r("app.string.text_title_12"), str:"10",mode:"isDecimal" },
  { text:$r("app.string.text_title_13"), str:"9421023610112",mode:"isEAN" },
  { text:$r("app.string.text_title_14"), str:"foo@bar.com",mode:"isEmail" },
  { text:$r("app.string.text_title_15"), str:"",mode:"isEmpty" },
  { text:$r("app.string.text_title_16"), str:"0x0000000000000000000000000000000000000001",mode:"isEthereumAddress" },
  { text:$r("app.string.text_title_17"), str:"domain.com",mode:"isFQDN" },
  { text:$r("app.string.text_title_18"), str:"ひらがな・カタカナ、．漢字",mode:"isFullWidth" },
  { text:$r("app.string.text_title_19"), str:"abc123い",mode:"isHalfWidth" },
  { text:$r("app.string.text_title_20"), str:"0xff0044",mode:"isHexadecimal" },
  { text:$r("app.string.text_title_21"), str:"#ff0000ff",mode:"isHexColor" },
  { text:$r("app.string.text_title_22"), str:"hsl(360,0000000000100%,000000100%)",mode:"isHSL" },
  { text:$r("app.string.text_title_23"), str:"SC52BAHL01031234567890123456USD",mode:"isIBAN" },
  { text:$r("app.string.text_title_24"), str:"722222222v", default :"LK",local:IDCardArray, mode:"isIdentityCard" },
  { text:$r("app.string.text_title_25"), str:"352099001761481",mode:"isIMEI" },
  { text:$r("app.string.text_title_26"), str:"3836221195",mode:"isISBN" },
  { text:$r("app.string.text_title_27"), str:"AU0000XVGZA3",mode:"isISIN" },
  { text:$r("app.string.text_title_28"), str:"ay",mode:"isISO6391" },
  { text:$r("app.string.text_title_29"), str:"2009-12T12:34",mode:"isISO8601" },
  { text:$r("app.string.text_title_30"), str:"FR",mode:"isISO31661Alpha2" },
  { text:$r("app.string.text_title_31"), str:"ABW",mode:"isISO31661Alpha3" },
  { text:$r("app.string.text_title_32"), str:"AED",mode:"isISO4217" },
  { text:$r("app.string.text_title_33"), str:"Hello World", str1:"H", mode:"contains" },
  { text:$r("app.string.text_title_34"), str:"Hello World", str1:"Hello World", mode:"equals" },
  { text:$r("app.string.text_title_35"), str:"2022-04-10", str1:"2023-07-18", mode:"isAfter" },
  { text:$r("app.string.text_title_36"), str:"2010-08-04", str1:"2010-07-02", mode:"isBefore" },
  { text:$r("app.string.text_title_37"), str:"aweawrfadfaff", mode:"isAlpha" },
  { text:$r("app.string.text_title_38"), str:"aweawrfadfaff", mode:"isAlphanumeric" },
  { text:$r("app.string.text_title_39"), str:"abc", min:1, max:4, mode:"isByteLength" },
  { text:$r("app.string.text_title_40"), str:"1.2", min:1, max:2, mode:"isFloat" },
  { text:$r("app.string.text_title_41"), str:"2", min:1, max:3, mode:"isInt" },
  { text:$r("app.string.text_title_42"), str:"10", min:2, mode:"isDivisibleBy" },
  { text:$r("app.string.text_title_43"), str:"foo", values:['foo','bar'], mode:"isIn" },
  { text:$r("app.string.text_title_44"), str:"127.0.0.1", IPVersion:4 , mode:"isIP" },
  { text:$r("app.string.text_title_45"), str:"127.0.0.1/1", IPVersion:4 , mode:"isIPRange" },
  { text:$r("app.string.text_title_46"), str:"d94f3f01", default :"crc32" ,local:array, mode:"isHash" },
  { text:$r("app.string.text_title_47"), str:"USAT29900609", mode:"isISRC" },
  { text:$r("app.string.text_title_48"), str:"0378-5955", mode:"isISSN" },
  { text:$r("app.string.text_title_49"), str:'{ "key": "value" }', mode:"isJSON" },
  { text:$r("app.string.text_title_50"), str:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dnZWRJbkFzIjoiYWRtaW4iLCJpYXQiOjE0MjI3Nzk2Mzh9.gzSraSYS8EXBxLN_oWnFSRgCzcmJmMjLiuyu5CSpyHI', mode:"isJWT" },
  { text:$r("app.string.text_title_51"), str:'(-17.738223, 85.605469)', mode:"isLatLong" },
  { text:$r("app.string.text_title_52"), str:'abc', min:1, max:4, mode:"isLength" },
  { text:$r("app.string.text_title_53"), str:'abc', mode:"isLowercase" },
  { text:$r("app.string.text_title_54"), str:'AB123CD', default :'es-AR',local:LicensePlateArray, mode:"isLicensePlate" },
  { text:$r("app.string.text_title_55"), str:'uz_Latn_UZ',  mode:"isLocale" },
  { text:$r("app.string.text_title_56"), str:'01234567897',  mode:"isLuhnNumber" },
  { text:$r("app.string.text_title_57"), str:'ab:ab:ab:ab:ab:ab',  mode:"isMACAddress" },
  { text:$r("app.string.text_title_58"), str:'magnet:?xt.1=urn:sha1:ABCDEFGHIJKLMNOPQRSTUVWXYZ123456&xt.2=urn:sha1:ABCDEFGHIJKLMNOPQRSTUVWXYZ123456',  mode:"isMagnetURI" },
  { text:$r("app.string.text_title_59"), str:'d94f3f016ae679c3008de268209132f2',  mode:"isMD5" },
  { text:$r("app.string.text_title_60"), str:'application/json',  mode:"isMimeType" },
  { text:$r("app.string.text_title_61"), str:'19876543210',  mode:"isMobilePhone" },
  { text:$r("app.string.text_title_62"), str:'507f1f77bcf86cd799439011',  mode:"isMongoId" },
  { text:$r("app.string.text_title_63"), str:'ひらがな・カタカナ、．漢字',  mode:"isMultibyte" },
  { text:$r("app.string.text_title_64"), str:'123',  mode:"isNumeric" },
  { text:$r("app.string.text_title_65"), str:'076543210',  mode:"isOctal" },
  { text:$r("app.string.text_title_66"), str:'AF0549358',  str1:"AM",  mode:"isPassportNumber" },
  { text:$r("app.string.text_title_67"), str:'22', mode:"isPort" },
  { text:$r("app.string.text_title_68"), str:'4000', default :"AU",local:PostalCodeArray, mode:"isPostalCode" },
  { text:$r("app.string.text_title_69"), str:'2009-05-19 14:39:22-06:00', mode:"isRFC3339" },
  { text:$r("app.string.text_title_70"), str:'rgb(0,0,0)', mode:"isRgbColor" },
  { text:$r("app.string.text_title_71"), str:'1.0.0-beta', mode:"isSemVer" },
  { text:$r("app.string.text_title_72"), str:'ABC千𥧄1-2-3', mode:"isSurrogatePair" },
  { text:$r("app.string.text_title_73"), str:'ABC', mode:"isUppercase" },
  { text:$r("app.string.text_title_74"), str:'foo-bar', mode:"isSlug" },
  { text:$r("app.string.text_title_75"), str:'%2%k{7BsL"M%Kd6e', mode:"isStrongPassword" },
  { text:$r("app.string.text_title_76"), str:'00:00', mode:"isTime" },
  { text:$r("app.string.text_title_77"), str:'0101010012', default :"bg-BG",local:TaxIDArray, mode:"isTaxID" },
  { text:$r("app.string.text_title_78"), str:'www.foobar.com', mode:"isURL" },
  { text:$r("app.string.text_title_79"), str:'A987FBC9-4BED-3078-CF07-9141BA07C9F3', mode:"isUUID" },
  { text:$r("app.string.text_title_80"), str:'ひらがなカタカナ漢字ABCDE', mode:"isVariableWidth" },
  { text:$r("app.string.text_title_81"), str:'ATU12345678', default :'AT',local:VATArray, mode:"isVAT" },
  { text:$r("app.string.text_title_82"), str:'foo',str1:"abcdefghijklmnopqrstuvwxyz-", mode:"isWhitelisted" },
  { text:$r("app.string.text_title_83"), str:'abc',str1:"abc", mode:"matches" },
  { text:$r("app.string.text_title_84"), str:'\\S010100201000\\S',str1:"\\S", mode:"trim" },
  { text:$r("app.string.text_title_85"), str:'\\S010100201000',str1:"\\S", mode:"ltrim" },
  { text:$r("app.string.text_title_86"), str:'010100201000\\S',str1:"\\S", mode:"rtrim" },
  { text:$r("app.string.text_title_87"), str:"<script> alert('xss&fun'); </script>", mode:"escape" },
  { text:$r("app.string.text_title_88"), str:'&lt;script&gt; alert(&quot;xss&amp;fun&quot;); &lt;&#x2F;script&gt;', mode:"unescape" },
  { text:$r("app.string.text_title_89"), str:'\u2206\x0A', mode:"stripLow" },
  { text:$r("app.string.text_title_90"), str:'3', mode:"toInt" },
  { text:$r("app.string.text_title_91"), str:'2.', mode:"toFloat" },
  { text:$r("app.string.text_title_92"), str:'abcdef', str1:"abc",mode:"whitelist" },
  { text:$r("app.string.text_title_93"), str:'abcdef', str1:"abc",mode:"blacklist" },
  { text:$r("app.string.text_title_94"), str:'some.name@qq.com', mode:"normalizeEmail" },
  { text:$r("app.string.text_title_95"), str:'true', mode:"toBoolean" },
  { text:$r("app.string.text_title_96"), str:'2022/05/07', mode:"toDate" }
]
export { data}