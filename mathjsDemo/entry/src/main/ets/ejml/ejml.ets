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
import {
  Matrix,
  EigenvalueDecomposition,
  CholeskyDecomposition,
  LuDecomposition,
  inverse,
  SingularValueDecomposition
} from 'ml-matrix';
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
  @State enabledBool: boolean = true
  @State MyMatrix: Matrix = new Matrix(0, 0)
  @State MyMatrixA: Matrix = new Matrix(0, 0)
  @State MyMatrixB: Matrix = new Matrix(0, 0)
  @State addAB: Matrix = new Matrix(0, 0)
  @State subAB: Matrix = new Matrix(0, 0)
  @State mulAB: Matrix = new Matrix(0, 0)
  @State divAB: Matrix = new Matrix(0, 0)
  @State modAB: Matrix = new Matrix(0, 0)
  @State maxAB: Matrix = new Matrix(0, 0)
  @State minAB: Matrix = new Matrix(0, 0)
  @State expAB: Matrix = new Matrix(0, 0)
  @State cosAB: Matrix = new Matrix(0, 0)
  @State setAB: Matrix = new Matrix(0, 0)
  @State diagAB: number[] = []
  @State randMatrix: Matrix = new Matrix(0, 0)
  @State edMatrix: EigenvalueDecomposition = new EigenvalueDecomposition([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
  @State inMatrix: Matrix = new Matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
  @State transposeMatrix: Matrix = new Matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
  @State eigenvalueMatrix: Matrix = new Matrix([])
  @State eigenvalueMatrix1: Matrix = new Matrix([])
  @State eigenvalueMatrix2: Array<number> = new Array<number>(0)
  @State mathTimeEigenvalue: string = '0'
  @State mathTimeLu: string = '0'
  @State luMatrix: Matrix = new Matrix([])
  @State luMatrix1: Matrix = new Matrix([])
  @State luMatrix2: Array<number> = new Array<number>(0)
  @State SVDMatrix: SingularValueDecomposition = new SingularValueDecomposition([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
  @State mathTimeSVD: string = '0'
  @State mathTimeCholesky: string = '0'
  @State CholeskyMatrix: Matrix = new Matrix([])
  SymmetricMatrixCholesky: Matrix = new Matrix([[10, 1, 10], [1, 10, 1], [10, 1, 10]])
  SymmetricMatrixSVD: Matrix = new Matrix([[10, 1, 10], [1, 10, 1], [10, 1, 10]])
  SymmetricMatrixEigenvalue: Matrix = new Matrix([[10, 1, 10], [1, 10, 1], [10, 1, 10]])
  nRows: number = 0
  nColumns: number = 0
  randnRows: number = 0
  randnColumns: number = 0
  rowIndex: number = 0
  columnIndex: number = 0
  setValue: number = 0
  MatrixA: Array<Array<number>> = [[1, 3, 2, 5, 6], [1, 2, 4, 5, 5], [2, 6, 9, 8, 7]]
  MatrixB: Array<Array<number>> = [[2, 3, 2, 5, 5], [3, 2, 4, 5, 5], [9, 8, 6, 5, 8]]
  SymmetricMatrix: Matrix = new Matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
  digMatrix: Matrix = new Matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
  ludigMatrix: Matrix = new Matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
  inverseMatrix: Matrix = new Matrix([[2, 0, 0], [0, 2, 0], [0, 0, 2]])

  build() {
    Scroll(this.scroller) {
      Column() {
        Text('矩阵测试')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： 10,1,10;1,10,1;10,1,10' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrixCholesky = new Matrix(this.strTransformationArr(value))
          })

        Text('Cholesky分解')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            let l = new CholeskyDecomposition(this.SymmetricMatrixCholesky)
            this.CholeskyMatrix = l.lowerTriangularMatrix;
            let time1 = Date.now()
            this.mathTimeCholesky = (time1 - time).toString()
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('Cholesky分解: ' + JSON.stringify(this.CholeskyMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeCholesky)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： 10,1,10;1,10,1;10,1,10' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrixSVD = new Matrix(this.strTransformationArr(value))
          })

        Text('SVD分解')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            this.SVDMatrix = new SingularValueDecomposition(this.SymmetricMatrixSVD)
            let time1 = Date.now()
            this.mathTimeSVD = (time1 - time).toString()
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('SVD diagonalMatrix分解: ' + JSON.stringify(this.SVDMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解norm2: ' + JSON.stringify(this.SVDMatrix.norm2))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解threshold: ' + JSON.stringify(this.SVDMatrix.threshold))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解leftSingularVectors: ' + JSON.stringify(this.SVDMatrix.leftSingularVectors))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解condition: ' + JSON.stringify(this.SVDMatrix.condition))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解rank: ' + JSON.stringify(this.SVDMatrix.rank))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解rightSingularVectors: ' + JSON.stringify(this.SVDMatrix.rightSingularVectors))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解diagonal: ' + JSON.stringify(this.SVDMatrix.diagonal))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('SVD diagonalMatrix分解diagonalMatrix: ' + JSON.stringify(this.SVDMatrix.diagonalMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeSVD)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： 10,1,10;1,10,1;10,1,10' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrix = new Matrix(this.strTransformationArr(value))
          })

        Text('特征分解')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            let l = new EigenvalueDecomposition(this.SymmetricMatrix)
            this.eigenvalueMatrix = l.diagonalMatrix;
            this.eigenvalueMatrix1 = l.eigenvectorMatrix;
            this.eigenvalueMatrix2 = l.realEigenvalues;
            let time1 = Date.now()
            this.mathTimeEigenvalue = (time1 - time).toString()
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('Eigenvalue diagonalMatrix: ' + JSON.stringify(this.eigenvalueMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('Eigenvalue eigenvectorMatrix: ' + JSON.stringify(this.eigenvalueMatrix1))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('Eigenvalue realEigenvalues: ' + JSON.stringify(this.eigenvalueMatrix2))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeEigenvalue)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入nRows' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.nRows = Number(value)
          })

        TextInput({ placeholder: '请输入nColumns' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.nColumns = Number(value)
          })


        Text('生成矩阵')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.MyMatrix = new Matrix(this.nRows, this.nColumns)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)


        Text('生成矩阵: ' + JSON.stringify(this.MyMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入 格式： 1,3,2,5,6;1,2,4,5,5;2,6,9,8,7' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.MatrixA = this.strTransformationArr(value)
          })

        Text('生成矩阵A')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.MyMatrixA = new Matrix(this.MatrixA)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('生成矩阵A: ' + JSON.stringify(this.MyMatrixA))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入 格式： 2,3,2,5,5;3,2,4,5,5;9,8,6,5,8' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.MatrixB = this.strTransformationArr(value)
          })

        Text('生成矩阵B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.MyMatrixB = new Matrix(this.MatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('生成矩阵B: ' + JSON.stringify(this.MyMatrixB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A+B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.addAB = Matrix.add(this.MyMatrixA, this.MyMatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A+B: ' + JSON.stringify(this.addAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A-B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.subAB = Matrix.sub(this.MyMatrixA, this.MyMatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A-B: ' + JSON.stringify(this.subAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A*B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.mulAB = Matrix.mul(this.MyMatrixA, this.MyMatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A*B: ' + JSON.stringify(this.mulAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A div B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.divAB = Matrix.div(this.MyMatrixA, this.MyMatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A div B: ' + JSON.stringify(this.divAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A mod B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.modAB = Matrix.mod(this.MyMatrixA, this.MyMatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A mod B: ' + JSON.stringify(this.modAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A max B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.maxAB = Matrix.max(this.MyMatrixA, this.MyMatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A max B: ' + JSON.stringify(this.maxAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A min B')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.minAB = Matrix.min(this.MyMatrixA, this.MyMatrixB)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A min B: ' + JSON.stringify(this.minAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A exp')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.expAB = Matrix.exp(this.MyMatrixA)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A exp: ' + JSON.stringify(this.expAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A cos')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.cosAB = Matrix.cos(this.MyMatrixA)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A cos: ' + JSON.stringify(this.cosAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入数字' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.rowIndex = Number(value)
          })

        TextInput({ placeholder: '请输入数字' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.columnIndex = Number(value)
          })

        TextInput({ placeholder: '请输入数字' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.setValue = Number(value)
          })

        Text('矩阵A set')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.setAB = this.MyMatrixA.set(this.rowIndex, this.columnIndex, this.setValue)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A set: ' + JSON.stringify(this.setAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A 对角线')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.diagAB = this.MyMatrixA.diag()
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A diag: ' + JSON.stringify(this.diagAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('矩阵A 转置')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.transposeMatrix = this.MyMatrixA.transpose()
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('矩阵A transpose: ' + JSON.stringify(this.transposeMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入nRows' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.randnRows = Number(value)
          })

        TextInput({ placeholder: '请输入nColumns' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.randnColumns = Number(value)
          })

        Text('创建随机矩阵')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.randMatrix = Matrix.random(this.randnRows, this.randnColumns)
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('随机矩阵: ' + JSON.stringify(this.randMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： 1,0,0;0,1,0;0,0,1' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.digMatrix = new Matrix(this.strTransformationArr(value))
          })

        TextInput({ placeholder: '请输入对称矩阵 如： 1,0,0;0,1,0;0,0,1' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.ludigMatrix = new Matrix(this.strTransformationArr(value))
          })

        Text('LU分解')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            let time = Date.now()
            let l = new LuDecomposition(this.ludigMatrix)
            this.luMatrix = l.lowerTriangularMatrix;
            this.luMatrix1 = l.upperTriangularMatrix;
            this.luMatrix2 = l.pivotPermutationVector;
            let time1 = Date.now()
            this.mathTimeLu = (time1 - time).toString()
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text('lu lowerTriangularMatrix: ' + JSON.stringify(this.luMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('lu upperTriangularMatrix: ' + JSON.stringify(this.luMatrix1))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('lu pivotPermutationVector: ' + JSON.stringify(this.luMatrix2))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text("时间：" + this.mathTimeLu)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入对称矩阵 如： 1,0,0;0,1,0;0,0,1' })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.inverseMatrix = new Matrix(this.strTransformationArr(value))
          })

        Text('inverse 矩阵 ')
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.inMatrix = inverse(this.inverseMatrix);
            this.enabledBool = false
            setTimeout(() => {
              this.enabledBool = true;
            }, 1000);
          })
          .enabled(this.enabledBool)

        Text(' inverse 矩阵: ' + JSON.stringify(this.inMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('跳转到 ejmlMathjs 页面')
          .fontSize(20)
          .padding(8)
          .margin({ top: 32 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            routerfun('ejml/ejmlMathjs')
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

      }.width('100%')
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

  strTransformationArr(str: string): Array<Array<number>> {
    var arr = str.split(";");

    var array = new Array(arr.length);

    for (var i = 0; i < arr.length; i++) {
      var temp = new Array(2);
      temp = arr[i].split(",");
      array[i] = new Array(temp.length);

      for (var j = 0; j < temp.length; j++) {
        array[i][j] = Number(temp[j]);
      }
    }
    return array
  }
}