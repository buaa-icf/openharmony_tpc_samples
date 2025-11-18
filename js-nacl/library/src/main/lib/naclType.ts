

// instantiate is the main entry point to generate a Nacl instance,
// which contains all functionality
export interface NaclFactory {
  instantiate: (cb: NaclCallback, opts?: NaclOpts | undefined) => Promise<Nacl>;
}
export type NaclCallback = (nacl: Nacl) => void;
export interface NaclOpts {
  readonly [key: string]: any;
}

// types for signing
export type SignerSecretKey = Uint8Array;
export type SignerPublicKey = Uint8Array;
export interface SignKeyPair {
  signPk: SignerPublicKey;
  signSk: SignerSecretKey;
}
export type Message = Uint8Array;
export type Signature = Uint8Array;
export type MessageWithSignature = Uint8Array;

// types for secrets
export type BoxSecretKey = Uint8Array;
export type BoxPublicKey = Uint8Array;
export interface BoxKeyPair {
  boxPk: BoxPublicKey;
  boxSk: BoxSecretKey;
}
export type Nonce = Uint8Array;
export type CipherText = Uint8Array;
export interface BoxSharedSecret {
  boxK: Uint8Array;
}

// types for streams
export type Stream = Uint8Array;
export type StreamKey = Uint8Array;

// === 常量定义接口扩展 ===
export interface NaclConstants {
  // === Box 相关常量 (6个) ===
  readonly crypto_box_PUBLICKEYBYTES: number;      // 32 - 公钥长度
  readonly crypto_box_SECRETKEYBYTES: number;      // 32 - 私钥长度
  readonly crypto_box_BEFORENMBYTES: number;       // 32 - 派生密钥长度
  readonly crypto_box_NONCEBYTES: number;          // 24 - Nonce 长度
  readonly crypto_box_ZEROBYTES: number;           // 32 - 零字节填充长度
  readonly crypto_box_BOXZEROBYTES: number;        // 16 - 解密零字节长度

  // === SecretBox 相关常量 (4个) ===
  readonly crypto_secretbox_KEYBYTES: number;      // 32 - 密钥长度
  readonly crypto_secretbox_NONCEBYTES: number;    // 24 - Nonce 长度
  readonly crypto_secretbox_ZEROBYTES: number;     // 32 - 零字节填充长度
  readonly crypto_secretbox_BOXZEROBYTES: number;  // 16 - 解密零字节长度

  // === 签名相关常量 (3个) ===
  readonly crypto_sign_PUBLICKEYBYTES: number;     // 32 - 公钥长度
  readonly crypto_sign_SECRETKEYBYTES: number;     // 64 - 私钥长度
  readonly crypto_sign_BYTES: number;              // 64 - 签名长度

  // === 哈希相关常量 (2个) ===
  readonly crypto_hash_BYTES: number;              // 64 - SHA-512 哈希长度
  readonly crypto_hash_sha256_BYTES: number;       // 32 - SHA-256 哈希长度

  // === 认证相关常量 (4个) ===
  readonly crypto_auth_BYTES: number;              // 32 - 认证标签长度
  readonly crypto_auth_KEYBYTES: number;           // 32 - 认证密钥长度
  readonly crypto_onetimeauth_BYTES: number;       // 16 - 一次性认证标签长度
  readonly crypto_onetimeauth_KEYBYTES: number;    // 32 - 一次性认证密钥长度

  // === 流加密相关常量 (2个) ===
  readonly crypto_stream_KEYBYTES: number;         // 32 - 流密钥长度
  readonly crypto_stream_NONCEBYTES: number;       // 24 - 流 Nonce 长度

  readonly crypto_scalarmult_BYTES: number;
}

// Nacl functions taken from js-nacl api spec
export interface Nacl {
  // ==================== 字符串编码/解码 (6个) ====================
  to_hex: (arr: Uint8Array) => string;
  from_hex: (hex: string) => Uint8Array;
  encode_utf8: (utf8: string) => Uint8Array;
  encode_latin1: (latin1: string) => Uint8Array;
  decode_utf8: (arr: Uint8Array) => string;
  decode_latin1: (arr: Uint8Array) => string;

  // ==================== 哈希函数 (2个) ====================
  crypto_hash: (raw: Uint8Array) => Uint8Array;
  crypto_hash_sha256: (raw: Uint8Array) => Uint8Array;

  // ==================== 数字签名 (5个) ====================
  crypto_sign_keypair: () => SignKeyPair;
  crypto_sign: (msg: Message, sk: SignerSecretKey) => MessageWithSignature;
  crypto_sign_open: (
    packet: MessageWithSignature,
    pk: SignerPublicKey,
  ) => Message | null;
  crypto_sign_detached: (msg: Message, sk: SignerSecretKey) => Signature;
  crypto_sign_verify_detached: (
    sig: Signature,
    msg: Message,
    pk: SignerPublicKey,
  ) => boolean;

  // ==================== 公钥加密 Box (7个) ====================
  crypto_box_keypair: () => BoxKeyPair;
  crypto_box_random_nonce: () => Nonce;
  crypto_box: (
    msg: Message,
    nonce: Nonce,
    rcpt: BoxPublicKey,
    sender: BoxSecretKey,
  ) => CipherText;
  crypto_box_open: (
    cipher: CipherText,
    nonce: Nonce,
    sender: BoxPublicKey,
    rcpt: BoxSecretKey,
  ) => Message;
  crypto_box_precompute: (
    sender: BoxPublicKey,
    rcpt: BoxSecretKey,
  ) => BoxSharedSecret;
  crypto_box_precomputed: (
    msg: Message,
    nonce: Nonce,
    shared: BoxSharedSecret,
  ) => CipherText;
  crypto_box_open_precomputed: (
    cipher: CipherText,
    nonce: Nonce,
    shared: BoxSharedSecret,
  ) => Message;

  // ==================== 对称加密 SecretBox (3个) ====================
  crypto_secretbox_random_nonce: () => Nonce;
  crypto_secretbox: (
    msg: Message,
    nonce: Nonce,
    key: BoxSecretKey,
  ) => CipherText;
  crypto_secretbox_open: (
    cipher: CipherText,
    nonce: Nonce,
    key: BoxSecretKey,
  ) => Message;

  // ==================== 派生密钥 (3个) ====================
  crypto_sign_seed_keypair: (seed: Uint8Array) => SignKeyPair;
  crypto_box_seed_keypair: (seed: Uint8Array) => BoxKeyPair;
  crypto_box_keypair_from_raw_sk: (seed: Uint8Array) => BoxKeyPair;

  // ==================== 随机数生成 (1个) ====================
  random_bytes: (length: number) => Uint8Array;
}


