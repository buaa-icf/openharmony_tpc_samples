import {CountryUtils} from 'util_code'

@Entry
@Component
struct CountryPage {



  @State message: string = ''
  @State err: string = ''

  build() {
    Column() {
      Row() {
        Button('地区获取拨号字冠'+CountryUtils.getCountryCode('CN'))
          .fontSize(18)
          .margin({ left: 18 })

        Button('系统地区获取拨号字冠'+CountryUtils.getCountryCodeByLanguage())
          .fontSize(18)
          .margin({ left: 18 })



      }

      Row() {

        Button('sim卡获取拨号字冠:'+ this.message)
          .fontSize(18)
          .margin({ left: 18 })
          .onClick(()=>{
            CountryUtils.getCountryCodeBySim((err,data)=>{
              this.err = err;
              this.message = data;
            })
          })



      }
      .margin({ top: 18 })

      Text('sim卡获取拨号字冠err:'+this.err)
    }
    .padding({ top: 18, bottom: 18 })
  }
}