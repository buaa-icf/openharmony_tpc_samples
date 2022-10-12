/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import * as math from 'mathjs';
import router from '@ohos.router';

function routerfun(url) {
  let options = {
    url: url
  }
  router.push(options)
}

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  zerosStr = '0'
  @State touchableBool: boolean = true
  @State mathApply: string = this.zerosStr
  @State mathTimeApply: string = this.zerosStr
  @State mathColumn: string = this.zerosStr
  @State mathTimeColumn: string = this.zerosStr
  @State mathConcat: string = this.zerosStr
  @State mathTimeConcat: string = this.zerosStr
  @State mathCount: string = this.zerosStr
  @State mathTimeCount: string = this.zerosStr
  @State mathCross: string = this.zerosStr
  @State mathTimeCross: string = this.zerosStr
  @State mathDet: string = this.zerosStr
  @State mathTimeDet: string = this.zerosStr
  @State mathDiag: string = this.zerosStr
  @State mathTimeDiag: string = this.zerosStr
  @State mathDot: string = this.zerosStr
  @State mathTimeDot: string = this.zerosStr
  @State mathTimeEigenvectors: string = this.zerosStr
  @State Matrix: math.MathCollection = math.matrix([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
  @State Matrix1: math.MathCollection = math.matrix([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
  @State mathEigs: string = this.zerosStr
  @State mathTimeEigs: string = this.zerosStr
  @State mathExpm: string = this.zerosStr
  @State mathTimeExpm: string = this.zerosStr
  @State mathFft: string = this.zerosStr
  @State mathTimeFft: string = this.zerosStr
  @State mathFlatten: string = this.zerosStr
  @State mathTimeFlatten: string = this.zerosStr
  @State mathIdentity: string = this.zerosStr
  @State mathTimeIdentity: string = this.zerosStr
  @State mathInv: string = this.zerosStr
  @State mathTimeInv: string = this.zerosStr
  @State mathKron: string = this.zerosStr
  @State mathTimeKron: string = this.zerosStr
  @State mathOnes: string = this.zerosStr
  @State mathTimeOnes: string = this.zerosStr
  @State mathRange: string = this.zerosStr
  @State mathTimeRange: string = this.zerosStr
  @State mathReshape: string = this.zerosStr
  @State mathTimeReshape: string = this.zerosStr
  @State mathResize: string = this.zerosStr
  @State mathTimeResize: string = this.zerosStr
  @State mathRow: string = this.zerosStr
  @State mathTimeRow: string = this.zerosStr
  @State mathSize: string = this.zerosStr
  @State mathTimeSize: string = this.zerosStr
  @State mathSort: string = this.zerosStr
  @State mathTimeSort: string = this.zerosStr
  @State mathSqrtm: string = this.zerosStr
  @State mathTimeSqrtm: string = this.zerosStr
  @State mathSqueeze: string = this.zerosStr
  @State mathTimeSqueeze: string = this.zerosStr
  @State mathSubset: string = this.zerosStr
  @State mathTimeSubset: string = this.zerosStr
  @State mathTrace: string = this.zerosStr
  @State mathTimeTrace: string = this.zerosStr
  @State mathZeros: string = this.zerosStr
  @State mathTimeZeros: string = this.zerosStr
  @State mathTimeQr: string = this.zerosStr
  @State qrMatrix: math.QRDecomposition = math.qr([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
  @State mathTime: string = this.zerosStr
  @State sparseMatrix: math.Matrix = math.matrix([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
  @State SymmetricMatrix2: math.Matrix = math.matrix([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
  @State getMatrix: math.Matrix = math.matrix([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
  @State setMatrix: math.Matrix = math.matrix([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
  SymmetricMatrixQr = [[10, 1, 10], [1, 10, 1], [10, 1, 10]]
  arrays = [[10, 1, 10], [1, 10, 1], [10, 1, 10]]
  mathZeros1 = 1
  mathZeros2 = 0
  mathTrace1 = this.arrays
  mathSubset1 = this.arrays
  mathSubset2 = 0
  mathSqueeze1 = this.arrays
  mathSqrtm1 = this.arrays
  mathSort1 = this.arrays
  mathSize1 = this.arrays
  mathRow1 = this.arrays
  mathRow2 = 0
  mathResize1 = this.arrays
  mathnumResize: number[] = [1, 1]
  mathstr
  mathReshape1 = this.arrays
  mathnumReshape: number[] = [1, 1]
  mathRange1 = 1
  mathRange2 = 0
  mathOnes1 = 1
  mathOnes2 = 0
  mathKron1 = this.arrays
  mathkron2 = this.arrays
  mathInv1 = this.arrays
  mathIdentity1 = this.arrays
  mathnumIdentity
  mathFlatten1 = this.arrays
  mathFft1 = this.arrays
  mathExpm1 = this.arrays
  mathEigs1 = this.arrays
  mathnumEigs
  SymmetricMatrix = this.arrays
  mathDot1 = this.arrays
  mathnumDot = this.arrays
  mathDiag1 = this.arrays
  mathDet1 = this.arrays
  mathCross1 = this.arrays
  mathnumCross = this.arrays
  mathCount1 = this.arrays
  mathConcat1 = this.arrays
  mathnumConcat = this.arrays
  mathColumn1 = this.arrays
  mathnumColumn
  mathApply1 = this.arrays
  mathnumApply
  SymmetricMatrixSparse = [[10, 1, 10], [1, 10, 1], [10, 1, 10]]
  SymmetricMatrix1 = [0, 2]
  getMatrix2 = [0, 2]
  setMatrix2 = [0, 2]
  setMatrixIndex = [0, 2]

  build() {
    Scroll(this.scroller) {
      Column() {
        Text('ejmlMathjs')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：  [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrixQr = math.evaluate(value)
          })

        Text('qr分解')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            this.qrMatrix = math.qr(this.SymmetricMatrixQr);
            let time1 = Date.now()
            this.mathTimeQr = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text('qr分解: ' + JSON.stringify(this.qrMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('qr分解 Q: ' + JSON.stringify(this.qrMatrix.Q))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('qr分解 R: ' + JSON.stringify(this.qrMatrix.R))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeQr)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathZeros1 = Number(value)
          })

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathZeros2 = Number(value)
          })

        Text('zeros test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathZeros = math.zeros(this.mathZeros1, this.mathZeros2).toString()
            let time1 = Date.now()
            this.mathTimeZeros = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathZeros)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeZeros)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathTrace1 = math.evaluate(value)
          })

        Text('trace test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathTrace = math.trace(this.mathTrace1).toString()
            let time1 = Date.now()
            this.mathTimeTrace = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathTrace)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeTrace)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathSubset1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathSubset2 = Number(value)
          })

        Text('subset test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathSubset = math.subset(this.mathSubset1, this.mathSubset2).toString()
            let time1 = Date.now()
            this.mathTimeSubset = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathSubset)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeSubset)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathSqueeze1 = math.evaluate(value)
          })

        Text('squeeze test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathSqueeze = math.squeeze(this.mathSqueeze1).toString()
            let time1 = Date.now()
            this.mathTimeSqueeze = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathSqueeze)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeSqueeze)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathSqrtm1 = math.evaluate(value)
          })

        Text('sqrtm test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathSqrtm = math.sqrtm(this.mathSqrtm1).toString()
            let time1 = Date.now()
            this.mathTimeSqrtm = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathSqrtm)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeSqrtm)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathSort1 = math.evaluate(value)
          })

        Text('sort test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathSort = math.sort(this.mathSort1, math.compareNatural).toString()
            let time1 = Date.now()
            this.mathTimeSort = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathSort)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeSort)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathSize1 = math.evaluate(value)
          })

        Text('size test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathSize = math.size(this.mathSize1).toString()
            let time1 = Date.now()
            this.mathTimeSize = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathSize)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeSize)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathRow1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathRow2 = Number(value)
          })

        Text('row test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathRow = math.row(this.mathRow1, this.mathRow2).toString()
            let time1 = Date.now()
            this.mathTimeRow = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathRow)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeRow)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)


        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathResize1 = math.evaluate(value)
          })

        TextInput({ placeholder: '输入任意实数' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumResize[0] = Number(value)
          })

        TextInput({ placeholder: '输入任意实数' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumResize[1] = Number(value)
          })

        TextInput({ placeholder: '任意输入或者不输人' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathstr = value
          })

        Text('resize test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathResize = math.resize(this.mathResize1, this.mathnumResize, this.mathstr).toString()
            let time1 = Date.now()
            this.mathTimeResize = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathResize)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeResize)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathReshape1 = math.evaluate(value)
          })

        TextInput({ placeholder: '输入任意实数' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumReshape[0] = Number(value)
          })

        TextInput({ placeholder: '输入任意实数' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumReshape[1] = Number(value)
          })

        Text('reshape test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathReshape = math.reshape(this.mathReshape1, this.mathnumReshape).toString()
            let time1 = Date.now()
            this.mathTimeReshape = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathReshape)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeReshape)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathRange1 = Number(value)
          })

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathRange2 = Number(value)
          })

        Text('range test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathRange = math.range(this.mathRange1, this.mathRange2).toString()
            let time1 = Date.now()
            this.mathTimeRange = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathRange)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeRange)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathOnes1 = Number(value)
          })

        TextInput({ placeholder: '请输数值' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathOnes2 = Number(value)
          })

        Text('ones test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathOnes = math.ones(this.mathOnes1, this.mathOnes2).toString()
            let time1 = Date.now()
            this.mathTimeOnes = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathOnes)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeOnes)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathKron1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathkron2 = math.evaluate(value)
          })

        Text('kron test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathKron = math.kron(math.matrix(this.mathKron1), math.matrix(this.mathkron2)).toString()
            let time1 = Date.now()
            this.mathTimeKron = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathKron)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeKron)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathInv1 = math.evaluate(value)
          })

        Text('inv test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathInv = math.inv(this.mathInv1).toString()
            let time1 = Date.now()
            this.mathTimeInv = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathInv)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeInv)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathIdentity1 = math.evaluate(value)
          })

        TextInput({ placeholder: '输入任意实数或者不输入' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumIdentity = value
          })

        Text('identity test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathIdentity = math.identity(this.mathIdentity1, this.mathnumIdentity).toString()
            let time1 = Date.now()
            this.mathTimeIdentity = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathIdentity)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeIdentity)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathFlatten1 = math.evaluate(value)
          })

        Text('flatten test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathFlatten = math.flatten(this.mathFlatten1).toString()
            let time1 = Date.now()
            this.mathTimeFlatten = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathFlatten)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeFlatten)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathFft1 = math.evaluate(value)
          })

        Text('fft test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathFft = math.fft(this.mathFft1).toString()
            let time1 = Date.now()
            this.mathTimeFft = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathFft)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeFft)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathExpm1 = math.evaluate(value)
          })

        Text('expm test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathExpm = math.expm(math.matrix(this.mathExpm1)).toString()
            let time1 = Date.now()
            this.mathTimeExpm = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathExpm)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeExpm)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathEigs1 = math.evaluate(value)
          })

        TextInput({ placeholder: '输入任意实数或者不输入' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumEigs = Number(value)
          })

        Text('eigs test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathEigs = math.eigs(this.mathEigs1, this.mathnumEigs).toString()
            let time1 = Date.now()
            this.mathTimeEigs = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathEigs)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeEigs)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrix = math.evaluate(value)
          })

        Text('eigenvectors')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            let eigMatrix = math.matrix(this.SymmetricMatrix);
            this.Matrix = math.eigs(eigMatrix).values
            this.Matrix1 = math.eigs(eigMatrix).vectors
            let time1 = Date.now()
            this.mathTimeEigenvectors = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text('values: ' + JSON.stringify(this.Matrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('vectors: ' + JSON.stringify(this.Matrix1))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeEigenvectors)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathDot1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumDot = math.evaluate(value)
          })

        Text('dot test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathDot = math.dot(this.mathDot1, this.mathnumDot).toString()
            let time1 = Date.now()
            this.mathTimeDot = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathDot)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeDot)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathDiag1 = math.evaluate(value)
          })

        Text('diag test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathDiag = math.diag(this.mathDiag1).toString()
            let time1 = Date.now()
            this.mathTimeDiag = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathDiag)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeDiag)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathDet1 = math.evaluate(value)
          })

        Text('det test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathDet = math.det(this.mathDet1).toString()
            let time1 = Date.now()
            this.mathTimeDet = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathDet)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeDet)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathCross1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumCross = math.evaluate(value)
          })

        Text('cross test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathCross = math.cross(this.mathCross1, this.mathnumCross).toString()
            let time1 = Date.now()
            this.mathTimeCross = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathCross)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeCross)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathCount1 = math.evaluate(value)
          })

        Text('count test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathCount = math.count(this.mathCount1).toString()
            let time1 = Date.now()
            this.mathTimeCount = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathCount)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeCount)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathConcat1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumConcat = math.evaluate(value)
          })

        Text('concat test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathConcat = math.concat(this.mathConcat1, this.mathnumConcat).toString()
            let time1 = Date.now()
            this.mathTimeConcat = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathConcat)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeConcat)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathColumn1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输入任意实数' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumColumn = Number(value)
          })

        Text('column test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathColumn = math.column(this.mathColumn1, this.mathnumColumn).toString()
            let time1 = Date.now()
            this.mathTimeColumn = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathColumn)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeColumn)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)


        TextInput({ placeholder: '请输入对称矩阵 如： [[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathApply1 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输入任意实数' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.mathnumApply = Number(value)
          })

        Text('apply test')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let time = Date.now()
            this.mathApply = math.apply(this.mathApply1, this.mathnumApply, math.sum).toString()
            let time1 = Date.now()
            this.mathTimeApply = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text("结果：" + this.mathApply)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeApply)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('稀疏矩阵')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：[[10, 1, 10], [1, 10, 1], [10, 1, 10]]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrixSparse = math.evaluate(value)
          })

        Text('创建 sparseMatrix')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            this.sparseMatrix = math.matrix(this.SymmetricMatrixSparse, 'sparse', 'number');
            let time1 = Date.now()
            this.mathTime = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text('sparseMatrix: ' + JSON.stringify(this.sparseMatrix.valueOf()))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('获取矩阵使用的存储格式: ' + JSON.stringify(this.sparseMatrix.storage()))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('获取存储在矩阵中的数据的数据类型: ' + JSON.stringify(this.sparseMatrix.datatype()))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('获取矩阵密度: ' + JSON.stringify(this.sparseMatrix.datatype()))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [10, 1, 10]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrix1 = math.evaluate(value)
          })

        Text('获取矩阵的子集')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            this.SymmetricMatrix2 = this.sparseMatrix.subset(math.index(...this.SymmetricMatrix1));
            let time1 = Date.now()
            this.mathTime = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text('获取矩阵的子集: ' + JSON.stringify(this.SymmetricMatrix2.valueOf()))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： [10, 1, 10]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.getMatrix2 = math.evaluate(value)
          })

        Text('从矩阵中获取单个元素')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            this.getMatrix = this.sparseMatrix.get(this.getMatrix2);
            let time1 = Date.now()
            this.mathTime = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text('获取矩阵的子集: ' + JSON.stringify(this.getMatrix.valueOf()))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如：  [10, 1, 10]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.setMatrix2 = math.evaluate(value)
          })

        TextInput({ placeholder: '请输入对称矩阵 如：  [10, 1, 10]' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.setMatrixIndex = math.evaluate(value)
          })

        Text('替换矩阵中的单个元素')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            this.setMatrix = this.sparseMatrix.set(this.setMatrix2, this.setMatrixIndex);
            let time1 = Date.now()
            this.mathTime = (time1 - time).toString()
            this.touchableBool = false
            setTimeout(() => {
              this.touchableBool = true;
            }, 1000);
          })
          .touchable(this.touchableBool)

        Text('获取矩阵的子集: ' + JSON.stringify(this.setMatrix.valueOf()))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)


        Text("时间：" + this.mathTime)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('跳转到 ejml 页面')
          .fontSize(20)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('ejml/ejml')
          })

        Text('跳转到首页')
          .fontSize(20)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('pages/index')
          })

      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(30)
    .onScroll((xOffset: number, yOffset: number) => {
      console.info(xOffset + ' ' + yOffset)
    })
    .onScrollEdge((side: Edge) => {
      console.info('To the edge')
    })
    .onScrollEnd(() => {
      console.info('Scroll Stop')
    })
  }
}