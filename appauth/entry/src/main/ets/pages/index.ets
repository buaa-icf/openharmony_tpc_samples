import router from '@ohos.router';
@Entry
@Component
struct Index {

  build() {
    Row() {
      Column({space: 100}) {
        Button('MSAL SAMPLE')
          .onClick(()=>{
            router.push({
              url:'pages/MsalSample'
            })
          })
        Button('OAUTH SAMPLE')
          .onClick(()=>{
            router.push({
              url:'pages/OAuthSample'
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}