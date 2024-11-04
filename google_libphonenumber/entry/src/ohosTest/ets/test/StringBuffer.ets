/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


export class StringBuffer{
  buffer_:string=''

  constructor(opt_1:string) {
    this.buffer_=opt_1
  }
  set(s:string){
    this.buffer_ = '' + s;
  }
  append(a1:ESObject, opt_a2:ESObject, var_args:ESObject):StringBuffer{
    this.buffer_ += String(a1);
    if (opt_a2 != null) {  // second argument is undefined (null == undefined)
      for (let i = 1; i < opt_a2.length; i++) {
        this.buffer_ += opt_a2[i];
      }
    }
    return this;
  }
  clear(){
    this.buffer_ = '';
  }
  getLength(){
    return this.buffer_.length;
  }
  toString(){
    return this.buffer_;
  }

}