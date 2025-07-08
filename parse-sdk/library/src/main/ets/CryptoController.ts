import CryptoJS from '@ohos/crypto-js'
const CryptoController = {
    encrypt(obj: any, secretKey: string): string {
        const encrypted = CryptoJS.AES.encrypt(JSON.stringify(obj), secretKey);
        return encrypted.toString();
    },

    decrypt(encryptedText: string, secretKey: string): string {
        const decryptedStr = CryptoJS.AES.decrypt(encryptedText, secretKey).toString(CryptoJS.enc.Utf8);
        return decryptedStr;
    },
};

export default CryptoController;
