/**
 *  The MIT License (MIT)
 *
 *  Copyright (c) 2022 HUAWEI
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */
import Jwks from "@ohos/jwks_rsa"
import util from '@ohos.util';

@Entry
@Component
struct Index {
  @State kid: string = ''
  @State alg: string = ''
  @State kty: string = ''
  @State usage: string = ''
  @State publicKey: string = ''
  private client: any;

  build() {
    Column() {
      Scroll() {
        Column({ space: 5 }) {
          Row() {
            Button('点击生成公钥').fontSize($r('app.string.button_font_size')).width('70%').height('70%').padding($r('app.string.margin')).onClick(() => {
              console.info("===== get publicKey start =====")
              const kid = 'RkI5MjI5OUY5ODc1N0Q4QzM0OUYzNkVGMTJDOUEzQkFCOTU3NjE2Rg';
              //根据kid从秘钥集中获取对应的jwk
              this.getData(kid)
            })
          }.justifyContent(FlexAlign.Center).width('100%').height('100vp')

          Text("kid: " + this.kid)
            .fontSize($r('app.string.font_size'))
          Text("alg: " + this.alg)
            .fontSize($r('app.string.font_size'))
          Text("kty: " + this.kty)
            .fontSize($r('app.string.font_size'))
          Text("usage: " + this.usage)
            .fontSize($r('app.string.font_size'))
          Text("publicKey: " + this.publicKey)
            .fontSize($r('app.string.font_size'))
        }
        .width('100%').margin($r('app.string.margin')).alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Start)
      }
    }.height('100%').justifyContent(FlexAlign.Start).alignItems(HorizontalAlign.Start)
  }

  aboutToAppear() {
    this.client = new Jwks.JwksClient({
      jwksUri: 'https://sandrino.auth0.com/.well-known/jwks.json',
      requestHeaders: {}, // Optional
      timeout: 5000, // Defaults to 30s
      cache: false,
      rateLimit: true
    });
  }

  async getData(kid) {
    let signingKey = await this.client.getSigningKey(kid)
    this.kid = signingKey.kid ? signingKey.kid : this.kid
    this.alg = signingKey.algorithm ? signingKey.algorithm : this.alg
    this.kty = signingKey.type ? signingKey.type : this.kty
    this.usage = signingKey.usage ? signingKey.usage : this.usage
    let pubKey = await signingKey.getPublicKey()
    let publicData = pubKey.getEncoded().data;
    console.info("public key encode  = " + publicData)
    let base64 = new util.Base64();
    this.publicKey = base64.encodeToStringSync(publicData);
    console.info("publicKey = " + this.publicKey)
  }
}