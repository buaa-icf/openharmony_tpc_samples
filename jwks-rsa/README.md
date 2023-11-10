# jwks-rsa

## 简介

从 JWKS（JSON Web 密钥集）端点检索密钥的库，支持的加密算法：非对称公钥加密算法（RSA）、非对称椭圆曲线加密算法(ECC)。

## 安装教程

```shell
npm install @ohos/jwks-rsa --save
```

## 使用说明

1. 初始化：实例化JwksClient和设置对应的属性

 ```
this.client = new JwksClient({
    jwksUri: 'https://sandrino.auth0.com/.well-known/jwks.json',
    requestHeaders: {}, // Optional
    timeout: 30000, // Defaults to 30s
    cache: false,
    rateLimit: true
    });
},
```
 
2. 获取publicKey和属性值：

```
let signingKey = await this.client.getSigningKey(kid)
this.kid = signingKey.kid
this.alg = signingKey.alg
this.kty = signingKey.kty
this.use = signingKey.use
this.publicKey = await signingKey.getPublicKey()
```

## 约束与限制

在下述版本验证通过：

DevEco Studio 版本：3.1 Beta1(3.1.0.200)，SDK:API9 Beta5(3.2.10.6)

## 目录结构

````
|---- OHOS_APP_jwks-rsa
|   |---- entry                                                # 示例代码文件夹
|   |---- jwks-rsa                                             # OHOS_APP_jwks-rsa库文件夹
|       |---- src
            |----main
                |----js
                    |----components
                        |----errors
                            |----ArgumentError.js              #错误日志
                            |----JwksError.js                  #错误日志
                            |----JwksRateLimitError.js         #错误日志
                            |----SigningKeyNotFoundError.js    #错误日志
                        |----integrations
                            |----config.js                     #支持的加密算法
                            |----express.js                    #expressJwtSecret生成秘密提供者
                            |----hapi.js                       #hapiJwtSecret生成秘密提供者
                            |----koa.js                        #koaJwtSecret生成秘密提供者
                            |----passport.js                   #passportJwtSecret生成秘密提供者
                        |----wrappers
                            |----cache.js                      #从缓存中获取密钥
                            |----callbackSupport.js            #回调方法
                            |----interceptor.js                #回调方法
                            |----rateLimit.js                  #设置请求密钥的速率
                            |----request.js                    #网路请求
                        |----JwksClient.js                     #构造方法
                        |----utils.js                          #加密算法
|   |---- README.md                                            #使用方法
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/hihopeorg/jwks-rsa/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/hihopeorg/jwks-rsa/pulls) 。

## 开源协议

本项目基于 [MIT License](https://gitee.com/hihopeorg/jwks-rsa/blob/master/LICENSE) ，请自由地享受和参与开源。