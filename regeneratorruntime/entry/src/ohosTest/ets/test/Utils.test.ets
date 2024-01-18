/**
 * MIT License
 *
 * Copyright (c) 2023 Huawei Device Co., Ltd. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

// 低配版context
export class Context{
  next: number = 0
  prev: number = 0
  done: boolean = false
  stop: Function = ()=> {
      this.done = true;
  }
}

// 低配版invoke
export function next(): Entity{
    let context: Context = new Context()
    let value: Function = ()=>{}
    let done: boolean = context.done
    return new Entity(value, done)
};

export class Entity{
  value:Function = ()=>{}
  done:boolean = false
  constructor(value: Function, done: boolean) {
    this.value = value
    this.done = done
  }
}

export function normalFun() {
  return 0;
}

async function complexNumberProcessing(): Promise<Number> {
  return 0;
}

export async function foo() {
   await complexNumberProcessing();
}