use flate2::Compression;
use napi_derive_ohos::napi;
use napi_ohos::bindgen_prelude::Uint8Array;

/// 压缩或解压缩所支持的选项，更详细定义参考：https://zlib.net/manual.html#Advanced
/// 不同函数支持的选项不同，详见各函数自身说明
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
    pub fn compression(&self) -> Compression {
        self.level
            .map(|level| Compression::new(u32::from(level)))
            .unwrap_or_default()
    }

    #[inline]
    pub fn window_bits(&self) -> u8 {
        self.window_bits.unwrap_or(15u8)
    }
}
