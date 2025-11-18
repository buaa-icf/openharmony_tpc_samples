
import type { Nacl, NaclCallback, NaclOpts } from './naclType';
import utils from './utils';

// 常量定义
export const crypto_auth_BYTES: number = 32;
export const crypto_auth_KEYBYTES: number = 32;
export const crypto_box_BEFORENMBYTES: number = 32;
export const crypto_box_BOXZEROBYTES: number = 16;  // 密文的前16字节必须为0
export const crypto_box_NONCEBYTES: number = 24;
export const crypto_box_PUBLICKEYBYTES: number = 32;
export const crypto_box_SECRETKEYBYTES: number = 32;
export const crypto_box_ZEROBYTES: number = 32;     // 消息的前32字节必须为0
export const crypto_hash_BYTES: number = 64;
export const crypto_hash_sha256_BYTES: number = 32;
export const crypto_onetimeauth_BYTES: number = 16;
export const crypto_onetimeauth_KEYBYTES: number = 32;
export const crypto_secretbox_BOXZEROBYTES: number = 16;
export const crypto_secretbox_KEYBYTES: number = 32;
export const crypto_secretbox_NONCEBYTES: number = 24;
export const crypto_secretbox_ZEROBYTES: number = 32;
export const crypto_sign_BYTES: number = 64;
export const crypto_sign_PUBLICKEYBYTES: number = 32;
export const crypto_sign_SECRETKEYBYTES: number = 64;
export const crypto_stream_KEYBYTES: number = 32;
export const crypto_stream_NONCEBYTES: number = 24;
export const crypto_scalarmult_BYTES: number = 32;


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
    random_bytes: utils.random_bytes
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
