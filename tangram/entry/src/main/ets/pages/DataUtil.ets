/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// @ts-nocheck
import http from '@ohos.net.http'

const data = require("./data.json")
const data2 = require('./data-2.json')

export class DataUtil{
  private TAG = "DataUtil"
  private url = 'https://yanqiu12.github.io/tangramTest.json'

  async getDataFromUrl(callback: (data:string)=>void){
    //每一个httpRequest对应一个http请求任务,不可服用
    let httpRequest = http.createHttp();

    httpRequest.request(
      // 填写http请求的url
      this.url,
        {
          method: http.RequestMethod.GET,
          connectTimeout: 60000,
          readTimeout:60000
        },(err,data)=>{
        if(!err){
          console.log('code: '+ data.responseCode);
          // data.result为http响应内容
          callback(JSON.stringify(JSON.parse(data.result)))
        }else{
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
          callback('error:'+JSON.stringify(err))
        }
      }
    )
    callback('')
  }

  getDataFormLocal(){
    return JSON.stringify(data);
  }

  getData2FormLocal(){
    return JSON.stringify(data2)
  }

  log(text: string){
    console.info("Tangram:" + this.TAG + ':' + text)
  }
}