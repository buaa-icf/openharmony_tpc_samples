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
export class CardLoadSupport{
  private mAsyncLoader: (loadinfo: string) => void
  private mAsyncPageLoader?: (page: number,loadinfo: string) => void

  constructor(asyncLoader?: (loadinfo: string) => void, asyncPageLoader?:(page:number, loadinfo: string) => void){
    this.mAsyncLoader = asyncLoader;
    this.mAsyncPageLoader = asyncPageLoader;
  }

  replaceLoader(asyncLoader?: (loadinfo: string) => void, asyncPageLoader?:(page:number, loadinfo: string) => void){
    this.mAsyncLoader = asyncLoader;
    this.mAsyncPageLoader = asyncPageLoader;
  }

  asyncLoader(loadinfo: string){
    Promise.resolve().then(res=>{
      this.mAsyncLoader(loadinfo);
    })
  }

  asyncPageLoader(page:number, loadinfo: string){
    Promise.resolve().then(res =>{
      this.mAsyncPageLoader(page,loadinfo);
    })
  }
}