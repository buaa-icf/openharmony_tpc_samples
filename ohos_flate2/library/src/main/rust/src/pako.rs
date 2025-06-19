use napi_derive_ohos::napi;

#[napi]
pub mod pako{
    use napi_ohos::bindgen_prelude::Uint8Array;
    use crate::{flate2, options::Options};

    /**
     * 参考flate2.gzip
     */
    #[napi]
    pub fn gzip(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
        flate2::gzip(buf, options)
    }

    /**
     * 参考flate2.ungzip
     */
    #[napi]
    pub fn ungzip(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
        flate2::ungzip(buf, options)
    }

    /**
     * 参考flate2.deflate
     */
    #[napi]
    pub fn deflate_raw(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
        flate2::deflate(buf, options)
    }

    /**
     * 参考flate2.inflate
     */
    #[napi]
    pub fn inflate_raw(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
        flate2::inflate(buf, options)
    }

    /**
     * 参考flate2.zlib
     */
    #[napi]
    pub fn deflate(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
        flate2::zlib(buf, options)
    }

    /**
     * 参考flate2.unzlib
     */
    #[napi]
    pub fn inflate(buf: Uint8Array, options: Option<Options>) -> Uint8Array {
        flate2::unzlib(buf, options)
    }
}