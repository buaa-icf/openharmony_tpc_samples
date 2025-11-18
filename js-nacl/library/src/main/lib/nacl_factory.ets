
import type { Nacl, NaclCallback, NaclOpts } from './naclType';
import utils from './utils';

// 常量定义
export const crypto_auth_BYTES: number = utils.crypto_auth_BYTES;
export const crypto_auth_KEYBYTES: number = utils.crypto_auth_KEYBYTES;
export const crypto_box_BEFORENMBYTES: number = utils.crypto_box_BEFORENMBYTES;
export const crypto_box_BOXZEROBYTES: number = utils.crypto_box_BOXZEROBYTES;  // 密文的前16字节必须为0
export const crypto_box_NONCEBYTES: number = utils.crypto_box_NONCEBYTES;
export const crypto_box_PUBLICKEYBYTES: number = utils.crypto_box_PUBLICKEYBYTES;
export const crypto_box_SECRETKEYBYTES: number = utils.crypto_box_SECRETKEYBYTES;
export const crypto_box_ZEROBYTES: number = utils.crypto_box_ZEROBYTES;     // 消息的前32字节必须为0
export const crypto_hash_BYTES: number = utils.crypto_hash_BYTES;
export const crypto_hash_sha256_BYTES: number = utils.crypto_hash_sha256_BYTES;
export const crypto_onetimeauth_BYTES: number = utils.crypto_onetimeauth_BYTES;
export const crypto_onetimeauth_KEYBYTES: number = utils.crypto_onetimeauth_KEYBYTES;
export const crypto_secretbox_BOXZEROBYTES: number = utils.crypto_secretbox_BOXZEROBYTES;
export const crypto_secretbox_KEYBYTES: number = utils.crypto_secretbox_KEYBYTES;
export const crypto_secretbox_NONCEBYTES: number = utils.crypto_secretbox_NONCEBYTES;
export const crypto_secretbox_ZEROBYTES: number = utils.crypto_secretbox_ZEROBYTES;
export const crypto_sign_BYTES: number = utils.crypto_sign_BYTES;
export const crypto_sign_PUBLICKEYBYTES: number = utils.crypto_sign_PUBLICKEYBYTES;
export const crypto_sign_SECRETKEYBYTES: number = utils.crypto_sign_SECRETKEYBYTES;
export const crypto_stream_KEYBYTES: number = utils.crypto_stream_KEYBYTES;
export const crypto_stream_NONCEBYTES: number = utils.crypto_stream_NONCEBYTES;
export const crypto_scalarmult_BYTES: number = utils.crypto_scalarmult_BYTES;


// 创建Nacl对象
function createNacl(): Nacl {
  return {
    // strings vs. binary
    to_hex: utils.to_hex,
    from_hex: utils.from_hex,
    encode_utf8: utils.encode_utf8,
    encode_latin1: utils.encode_latin1,
    decode_utf8: utils.decode_utf8,
    decode_latin1: utils.decode_latin1,

    // hash
    crypto_hash: utils.crypto_hash,
    crypto_hash_sha256: utils.crypto_hash_sha256,

    // crypto_stream
    crypto_stream: utils.crypto_stream,
    crypto_stream_xor: utils.crypto_stream_xor,

    // crypto_auth
    crypto_auth: utils.crypto_auth,
    crypto_auth_verify: utils.crypto_auth_verify,

    crypto_onetimeauth: utils.crypto_onetimeauth,
    crypto_onetimeauth_verify: utils.crypto_onetimeauth_verify,

    // crypto_sign
    crypto_sign_keypair: utils.crypto_sign_keypair,
    crypto_sign: utils.crypto_sign,
    crypto_sign_open: utils.crypto_sign_open,
    crypto_sign_detached: utils.crypto_sign_detached,
    crypto_sign_verify_detached: utils.crypto_sign_verify_detached,

    // crypto_box
    crypto_box_keypair: utils.crypto_box_keypair,
    crypto_box_random_nonce: utils.crypto_box_random_nonce,
    crypto_box: utils.crypto_box,
    crypto_box_open: utils.crypto_box_open,
    crypto_box_precompute: utils.crypto_box_precompute,
    crypto_box_precomputed: utils.crypto_box_precomputed,
    crypto_box_open_precomputed: utils.crypto_box_open_precomputed,

    // crypto_secretbox
    crypto_secretbox_random_nonce: utils.crypto_secretbox_random_nonce,
    crypto_secretbox: utils.crypto_secretbox,
    crypto_secretbox_open: utils.crypto_secretbox_open,

    // derived keys
    crypto_sign_seed_keypair: utils.crypto_sign_seed_keypair,
    crypto_box_seed_keypair: utils.crypto_box_seed_keypair,
    crypto_box_keypair_from_raw_sk: utils.crypto_box_keypair_from_raw_sk,

    // random
    random_bytes: utils.random_bytes,

    // === Box 相关常量 ===
    crypto_box_PUBLICKEYBYTES: utils.crypto_box_PUBLICKEYBYTES,
    crypto_box_SECRETKEYBYTES: utils.crypto_box_SECRETKEYBYTES,
    crypto_box_BEFORENMBYTES: utils.crypto_box_BEFORENMBYTES,
    crypto_box_NONCEBYTES: utils.crypto_box_NONCEBYTES,
    crypto_box_ZEROBYTES: utils.crypto_box_ZEROBYTES,
    crypto_box_BOXZEROBYTES: utils.crypto_box_BOXZEROBYTES,

    // === SecretBox 相关常量 ===
    crypto_secretbox_KEYBYTES: utils.crypto_secretbox_KEYBYTES,
    crypto_secretbox_NONCEBYTES: utils.crypto_secretbox_NONCEBYTES,
    crypto_secretbox_ZEROBYTES: utils.crypto_secretbox_ZEROBYTES,
    crypto_secretbox_BOXZEROBYTES: utils.crypto_secretbox_BOXZEROBYTES,

    // === 签名相关常量 ===
    crypto_sign_PUBLICKEYBYTES: utils.crypto_sign_PUBLICKEYBYTES,
    crypto_sign_SECRETKEYBYTES: utils.crypto_sign_SECRETKEYBYTES,
    crypto_sign_BYTES: utils.crypto_sign_BYTES,

    // === 哈希相关常量 ===
    crypto_hash_BYTES: utils.crypto_hash_BYTES,
    crypto_hash_sha256_BYTES: utils.crypto_hash_sha256_BYTES,

    // === 认证相关常量 ===
    crypto_auth_BYTES: utils.crypto_auth_BYTES,
    crypto_auth_KEYBYTES: utils.crypto_auth_KEYBYTES,
    crypto_onetimeauth_BYTES: utils.crypto_onetimeauth_BYTES,
    crypto_onetimeauth_KEYBYTES: utils.crypto_onetimeauth_KEYBYTES,

    // === 流加密相关常量 ===
    crypto_stream_KEYBYTES: utils.crypto_stream_KEYBYTES,
    crypto_stream_NONCEBYTES: utils.crypto_stream_NONCEBYTES,
    crypto_scalarmult_BYTES: utils.crypto_scalarmult_BYTES
  };
}

interface NaclFactory {
  instantiate: (cb: NaclCallback, opts?: NaclOpts | undefined) => Promise<Nacl>;
}

// instantiate函数实现
export function instantiate(cb: NaclCallback, opts?: NaclOpts): Promise<Nacl> {
  return new Promise<Nacl>((resolve) => {
    const nacl = createNacl();
    if (cb) {
      cb(nacl);
    }
    resolve(nacl);
  });
}

const nacl_factory: NaclFactory = {
  instantiate: instantiate
}

export default nacl_factory;
