import { InputAttributeModel, RealtimeInputPopup } from '@ohos/dialogs'

@Entry
@Component
struct RealtimeInput {
  private allData: string[] = ['abc', 'bcd', 'cde', 'def', 'efg', 'fgh', 'ghi', 'hij', 'ijk', 'jkl', 'bcd', 'cde', 'def', 'efg', 'fgh', 'ghi', 'hij', 'ijk', 'jkl']
  @State model: InputAttributeModel = new InputAttributeModel()
  @State @Watch('onChange') inputVal: string = ''

  onChange() {
    this.model.dataList = this.allData.filter(data => (data.indexOf(this.inputVal) != -1))
  }

  aboutToAppear() {
    this.model.setInputWidth(150)
  }

  build() {
    Column() {
      RealtimeInputPopup({ model: this.model, inputVal: this.inputVal })
    }
  }
}