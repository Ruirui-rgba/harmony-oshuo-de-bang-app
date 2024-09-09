@CustomDialog
@Component
export struct PhoneDiag{
  @Prop phonenumber:string=''
  private controller:CustomDialogController
  build() {
    Column(){
      Row(){
        Text(this.phonenumber)
          .fontSize($r('app.string.TitleFontSize'))
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
      }
      .padding(20)
      Row(){
        Text('取消')
          .fontSize($r('app.string.TitleFontSize'))
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
      }
      .padding(20)
      .onClick(()=>{
        this.controller.close()
      })
    }
    .width('100%')
    .backgroundColor(Color.White)
  }
}