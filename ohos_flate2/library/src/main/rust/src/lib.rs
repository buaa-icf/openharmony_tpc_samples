use std::io::Read;

use flate2::{
    bufread::{DeflateDecoder, DeflateEncoder, GzDecoder, GzEncoder, ZlibDecoder, ZlibEncoder},
    Compress, Compression, Decompress,
};

use napi_derive_ohos::napi;
use napi_ohos::bindgen_prelude::Uint8Array;

/// 压缩或解压缩所支持的选项，详细定义参考：https://zlib.net/manual.html#Advanced
/// 不同函数支持的选项不同，详见各函数自身说买
#[napi(object)]
#[derive(Default)]
pub struct Options {
    /// 压缩等级，0为最低（没有压缩），9为最高，默认值为6，数据有效值范围[0..9]，超出范围取默认值
    pub level: Option<u8>,
    /// 窗口大小（历史缓冲区的大小）的底数2的对数，默认值为15，数据有效值范围[9..15]，超出范围取默认值
    pub window_bits: Option<u8>,
    /// 初始压缩/解压缩字典，默认为空
    pub dictionary: Option<Uint8Array>,
}

impl Options {
    #[inline]
    fn compression(&self) -> Compression {
        self.level
            .map(|level| Compression::new(u32::from(level)))
            .unwrap_or_default()
    }

    #[inline]
    fn window_bits(&self) -> u8 {
        self.window_bits.unwrap_or(15u8)
    }
}

/**
 * @description 使用gzip算法压缩数据
 * @param buf - 待压缩数据
 * @param options - 压缩选项，支持选项为level
 * @returns 输入压缩后的数据，若压缩过程中发生错误，则返回数据大小为0
 */
#[napi]
pub fn gzip(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
    let opts = options.unwrap_or_default();
    let level = opts.compression();
    let encoder = GzEncoder::new(buf.as_ref(), level);
    compress(encoder, buf.len())
}

/**
 * @description 使用deflate算法压缩数据
 * @param buf - 待压缩数据
 * @param options - 压缩选项，支持选项为level
 * @returns 输入压缩后的数据，若压缩过程中发生错误，则返回数据大小为0
 */
#[napi]
pub fn deflate(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
    let opts = options.unwrap_or_default();
    let level = opts.compression();
    let encoder = DeflateEncoder::new(buf.as_ref(), level);
    compress(encoder, buf.len())
}

/**
 * @description 使用zlib算法压缩数据
 * @param buf - 待压缩数据
 * @param options - 压缩选项，支持选项为level，window_bits,dictionary
 * @returns 输入压缩后的数据，若压缩过程中发生错误，则返回数据大小为0
 */
#[napi]
pub fn zlib(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
    let opts = options.unwrap_or_default();
    let level = opts.compression();
    let window_bits = opts.window_bits();
    let mut comp = Compress::new_with_window_bits(level, true, window_bits);
    if let Some(dict) = &opts.dictionary {
        if let Err(e) = comp.set_dictionary(dict) {
            eprintln!("invalid zlib dictionary, error {e}");
            return Uint8Array::new(vec![]);
        }
    }
    let encoder = ZlibEncoder::new_with_compress(buf.as_ref(), comp);
    compress(encoder, buf.len())
}

/**
 * @description 使用gzip算法解压缩数据
 * @param buf - 待解压数据
 * @param options - 解压缩选项，当前选项无效
 * @returns 输入解压后的数据，若解压过程中发生错误，则返回数据大小为0
 */
#[napi]
pub fn ungzip(buf: Uint8Array, _options: Option<Options>) -> Uint8Array {
    let decoder = GzDecoder::new(buf.as_ref());
    decompress(decoder, buf.len() * 2)
}

/**
 * @description 使用deflate算法解压缩数据
 * @param buf - 待解压数据
 * @param options - 解压缩选项，当前选项无效
 * @returns 输入解压后的数据，若解压过程中发生错误，则返回数据大小为0
 */
#[napi]
pub fn inflate(buf: Uint8Array, _options: Option<Options>) -> Uint8Array {
    let decoder = DeflateDecoder::new(buf.as_ref());
    decompress(decoder, buf.len() * 2)
}

/**
 * @description 使用zlib算法解压缩数据
 * @param buf - 待解压数据
 * @param options - 解压缩选项，支持选项为window_bits,dictionary
 * @returns 输入解压后的数据，若解压过程中发生错误，则返回数据大小为0
 */
#[napi]
pub fn unzlib(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
    let opts = options.unwrap_or_default();
    let window_bits = opts.window_bits();
    let mut decomp = Decompress::new_with_window_bits(true, window_bits);
    if let Some(dict) = &opts.dictionary {
        if let Err(e) = decomp.set_dictionary(dict) {
            eprintln!("invalid zlib dictionary, error {e}");
            return Uint8Array::new(vec![]);
        }
    }
    let decoder = ZlibDecoder::new_with_decompress(buf.as_ref(), decomp);
    decompress(decoder, buf.len())
}

#[inline]
fn decompress<T: Read>(mut decoder: T, buf_size: usize) -> Uint8Array {
    let mut output = Vec::with_capacity(buf_size);
    if let Err(e) = decoder.read_to_end(&mut output) {
        eprintln!("failed to decompress data, error {e}");
        output.clear();
    }
    Uint8Array::new(output)
}

#[inline]
fn compress<T: Read>(mut encoder: T, buf_size: usize) -> Uint8Array {
    let mut output = Vec::with_capacity(buf_size);
    if let Err(e) = encoder.read_to_end(&mut output) {
        eprintln!("failed to compress data, error {e}");
        output.clear();
    }
    Uint8Array::new(output)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_gzip() {
        for len in [10, 100, 1000] {
            let data = (0..len)
                .map(|x| (x % (u8::MAX as u32 + 1)) as u8)
                .collect::<Vec<u8>>();
            let buf = Uint8Array::new(data.clone());
            let compressed = gzip(buf, None);
            let decompressed = ungzip(compressed, None).to_vec();
            assert_eq!(data, decompressed)
        }
    }

    #[test]
    fn test_deflate() {
        for len in [10, 100, 1000] {
            let data = (0..len)
                .map(|x| (x % (u8::MAX as u32 + 1)) as u8)
                .collect::<Vec<u8>>();
            let buf = Uint8Array::new(data.clone());
            let compressed = deflate(buf, None);
            let decompressed = inflate(compressed, None).to_vec();
            assert_eq!(data, decompressed)
        }
    }

    #[test]
    fn test_zlib() {
        for len in [10, 100, 1000] {
            let data = (0..len)
                .map(|x| (x % (u8::MAX as u32 + 1)) as u8)
                .collect::<Vec<u8>>();
            let buf = Uint8Array::new(data.clone());
            let compressed = zlib(buf, None);
            let decompressed = unzlib(compressed, None).to_vec();
            assert_eq!(data, decompressed)
        }
    }
}
