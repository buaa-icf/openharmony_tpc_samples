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

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  _matrix: Matrix = new Matrix(0, 0)
  @State MyMatrix: Matrix = this._matrix
  @State MyMatrixA: Matrix = this._matrix
  @State MyMatrixB: Matrix = this._matrix
  @State addAB: Matrix = this._matrix
  @State subAB: Matrix = this._matrix
  @State mulAB: Matrix = this._matrix
  @State divAB: Matrix = this._matrix
  @State modAB: Matrix = this._matrix
  @State maxAB: Matrix = this._matrix
  @State minAB: Matrix = this._matrix
  @State expAB: Matrix = this._matrix
  @State cosAB: Matrix = this._matrix
  @State setAB: Matrix = this._matrix
  @State diagAB: number[] = []
  @State randMatrix: Matrix = this._matrix
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
  SymmetricMatrixCholesky: string = '10,1,10;1,10,1;10,1,10'
  SymmetricMatrixSVD: string = '10,1,10;1,10,1;10,1,10'
  SymmetricMatrixEigenvalue: string = '10,1,10;1,10,1;10,1,10'
  nRows: number = 0
  nColumns: number = 0
  randnRows: number = 0
  randnColumns: number = 0
  rowIndex: number = 0
  columnIndex: number = 0
  setValue: number = 0
  MatrixA: string = '1,3,2,5,6;1,2,4,5,5;2,6,9,8,7'
  MatrixB: string = '2,3,2,5,5;3,2,4,5,5;9,8,6,5,8'
  SymmetricMatrix: string = '10,1,10;1,10,1;10,1,10'
  ludigMatrix: string = '1,0,0;0,1,0;0,0,1'
  inverseMatrix: string = '1,0,0;0,1,0;0,0,1'

  uiContext = this.getUIContext();
  getResourceString(res: Resource):string {
    try {
      let result = this.uiContext?.getHostContext()?.resourceManager.getStringSync(res.id)
      if (result == undefined) {
        return ""
      } else {
        return result;
      }
    } catch (error) {
      return "getResourceString Failed:" + error;
    }
  }

  build() {
    Scroll(this.scroller) {
      Column() {
        Text($r('app.string.Matrix_testing'))
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_symmetric2') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrixCholesky = value
          })

        Text($r('app.string.Cholesky_decomposition'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              let time = Date.now()
              let l: CholeskyDecomposition =
                new CholeskyDecomposition(new Matrix(this.strTransformationArr(this.SymmetricMatrixCholesky)))
              this.CholeskyMatrix = l.lowerTriangularMatrix;
              let time1 = Date.now()
              this.mathTimeCholesky = (time1 - time).toString()
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Cholesky_decomposition')) + JSON.stringify(this.CholeskyMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.Time')) + this.mathTimeCholesky)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_symmetric2') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrixSVD = value
          })

        Text($r('app.string.SVD_decomposition'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              let time = Date.now()
              this.SVDMatrix =
                new SingularValueDecomposition(new Matrix(this.strTransformationArr(this.SymmetricMatrixSVD)))
              let time1 = Date.now()
              this.mathTimeSVD = (time1 - time).toString()
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.SVD_diagnosticMatrix_decomposition')) +
        JSON.stringify(this.SVDMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_diagnosticMatrix_decomposition_norm2')) +
        JSON.stringify(this.SVDMatrix.norm2))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_diagnosticMatrix_decomposes_threshold')) +
        JSON.stringify(this.SVDMatrix.threshold))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_leftSingleVectors')) +
        JSON.stringify(this.SVDMatrix.leftSingularVectors))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_condition')) + JSON.stringify(this.SVDMatrix.condition))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_rank')) + JSON.stringify(this.SVDMatrix.rank))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_rightSingularVectors')) +
        JSON.stringify(this.SVDMatrix.rightSingularVectors))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_diagnostically')) + JSON.stringify(this.SVDMatrix.diagonal))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.SVD_diagnosticMatrix')) +
        JSON.stringify(this.SVDMatrix.diagonalMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.Time')) + this.mathTimeSVD)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_symmetric2') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.SymmetricMatrix = value
          })

        Text($r('app.string.Feature_decomposition'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              let time = Date.now()
              let l: EigenvalueDecomposition =
                new EigenvalueDecomposition(new Matrix(this.strTransformationArr(this.SymmetricMatrix)))
              this.eigenvalueMatrix = l.diagonalMatrix;
              this.eigenvalueMatrix1 = l.eigenvectorMatrix;
              this.eigenvalueMatrix2 = l.realEigenvalues;
              let time1 = Date.now()
              this.mathTimeEigenvalue = (time1 - time).toString()
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text('Eigenvalue diagonalMatrix: ' + JSON.stringify(this.eigenvalueMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('Eigenvalue eigenvectorMatrix: ' + JSON.stringify(this.eigenvalueMatrix1))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('Eigenvalue realEigenvalues: ' + JSON.stringify(this.eigenvalueMatrix2))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.Time')) + this.mathTimeEigenvalue)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_nRows') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.nRows = Number(value)
          })

        TextInput({ placeholder: $r('app.string.Please_nColumns') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.nColumns = Number(value)
          })


        Text($r('app.string.Generate_matrix'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.MyMatrix = new Matrix(this.nRows, this.nColumns)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })


        Text(this.getResourceString($r('app.string.Generate_matrix')) + JSON.stringify(this.MyMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_format') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.MatrixA = value
          })

        Text($r('app.string.Generate_matrix_A'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.MyMatrixA = new Matrix(this.strTransformationArr(this.MatrixA))
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Generate_matrix_A')) + JSON.stringify(this.MyMatrixA))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_format2') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.MatrixB = value
          })

        Text($r('app.string.Generate_matrix_b'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.MyMatrixB = new Matrix(this.strTransformationArr(this.MatrixB))
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Generate_matrix_b')) + JSON.stringify(this.MyMatrixB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_A_B'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.addAB = Matrix.add(this.MyMatrixA, this.MyMatrixB)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_A_B')) + JSON.stringify(this.addAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_A_B2'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.subAB = Matrix.sub(this.MyMatrixA, this.MyMatrixB)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_A_B2')) + JSON.stringify(this.subAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_A_B3'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.mulAB = Matrix.mul(this.MyMatrixA, this.MyMatrixB)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_A_B3')) + JSON.stringify(this.mulAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_A_B4'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.divAB = Matrix.div(this.MyMatrixA, this.MyMatrixB)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_A_B4')) + JSON.stringify(this.divAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_A_B5'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.modAB = Matrix.mod(this.MyMatrixA, this.MyMatrixB)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_A_B5')) + JSON.stringify(this.modAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_A_B6'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.maxAB = Matrix.max(this.MyMatrixA, this.MyMatrixB)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_A_B6')) + JSON.stringify(this.maxAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_A_B7'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.minAB = Matrix.min(this.MyMatrixA, this.MyMatrixB)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_A_B7')) + JSON.stringify(this.minAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_exp'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.expAB = Matrix.exp(this.MyMatrixA)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_exp')) + JSON.stringify(this.expAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Matrix_cos'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.cosAB = Matrix.cos(this.MyMatrixA)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_cos')) + JSON.stringify(this.cosAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.please_enter_a_number') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.rowIndex = Number(value)
          })

        TextInput({ placeholder: $r('app.string.please_enter_a_number') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.columnIndex = Number(value)
          })

        TextInput({ placeholder: $r('app.string.please_enter_a_number') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.setValue = Number(value)
          })

        Text($r('app.string.Matrix_set'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.setAB = this.MyMatrixA.set(this.rowIndex, this.columnIndex, this.setValue)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_set')) + JSON.stringify(this.setAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Diagonal_matrix_A'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.diagAB = this.MyMatrixA.diag()
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_diag')) +JSON.stringify(this.diagAB))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Transpose_matrix'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.transposeMatrix = this.MyMatrixA.transpose()
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Matrix_transpose')) + JSON.stringify(this.transposeMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_nRows') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.randnRows = Number(value)
          })

        TextInput({ placeholder: $r('app.string.Please_nColumns') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value: string) => {
            this.randnColumns = Number(value)
          })

        Text($r('app.string.Create_matrix'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.randMatrix = Matrix.random(this.randnRows, this.randnColumns)
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Random_matrix')) + JSON.stringify(this.randMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_input_symmetric') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.ludigMatrix = value
          })

        Text($r('app.string.LU_decomposition'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              let time = Date.now()
              let l: LuDecomposition = new LuDecomposition(new Matrix(this.strTransformationArr(this.ludigMatrix)))
              this.luMatrix = l.lowerTriangularMatrix;
              this.luMatrix1 = l.upperTriangularMatrix;
              this.luMatrix2 = l.pivotPermutationVector;
              let time1 = Date.now()
              this.mathTimeLu = (time1 - time).toString()
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text('lu lowerTriangularMatrix: ' + JSON.stringify(this.luMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('lu upperTriangularMatrix: ' + JSON.stringify(this.luMatrix1))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text('lu pivotPermutationVector: ' + JSON.stringify(this.luMatrix2))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text(this.getResourceString($r('app.string.Time')) + this.mathTimeLu)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        TextInput({ placeholder: $r('app.string.Please_input_symmetric') })
          .caretColor(Color.Blue)
          .height(50)
          .fontSize(30)
          .onChange((value) => {
            this.inverseMatrix = value
          })

        Text($r('app.string.Inverse_matrix'))
          .fontSize(16)
          .margin({ top: 32 })
          .padding(8)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            try {
              this.inMatrix = inverse(new Matrix(this.strTransformationArr(this.inverseMatrix)));
            } catch (err) {
              console.log('errerr ' + err)
            }
          })

        Text(this.getResourceString($r('app.string.Inverse_matrix')) + JSON.stringify(this.inMatrix))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)

        Text($r('app.string.Jump_to_homepage'))
          .fontSize(20)
          .padding(8)
          .margin({ top: 52 })
          .fontWeight(FontWeight.Bold)
          .border({ width: 2, color: '#535353', radius: 6 })
          .onClick(() => {
            this.getUIContext().getRouter().back()
          })

      }.width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(30)
    .onWillScroll((xOffset: number, yOffset: number) => {
      console.info(xOffset + ' ' + yOffset)
    })
    .onScrollEdge((side: Edge) => {
      console.info('To the edge')
    })
    .onScrollStop(() => {
      console.info('Scroll Stop')
    })
  }

  strTransformationArr(str: string): Array<Array<number>> {
    let arr: Array<string> = str.split(";");

    let array: Array<Array<number>> = new Array(arr.length);

    for (let i = 0; i < arr.length; i++) {
      let temp: Array<string> = new Array(2);
      temp = arr[i].split(",");
      array[i] = new Array(temp.length);

      for (let j = 0; j < temp.length; j++) {
        array[i][j] = Number(temp[j]);
      }
    }
    return array
  }
}