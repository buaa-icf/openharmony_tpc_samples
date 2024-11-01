## 1.0.2-rc.0

- Fix the issue of failed file creation for unzippToDirectory interface decompression

## 1.0.1

- Update the version to 1.0.1.

## 1.0.1-rc.2

- Upgrade the dependent aki version to 1.2.13

## 1.0.1-rc.1

- unzipToDirectory supports user-defined character encoding.

## 1.0.1-rc.0

- Fix the issue of Chinese character garbling.
  - Add new interfaces SetCharEncoding(charEncoding : number)
- Fix the issue of failing to create multi-level directories.
- Fix the issue of unzipToDirectory interface failing to decompress 0KB files.

## 1.0.0

- Support decryption and decompression of zip packages, including support for the GetEntryNames (get the list of files in the archive) and ExtractFileToJS (decompress file content) interfaces.
