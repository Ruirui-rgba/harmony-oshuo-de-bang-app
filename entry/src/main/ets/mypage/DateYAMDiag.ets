@CustomDialog
@Component
export struct DateYAMDiag{
  private controller:CustomDialogController
  @Prop generateYearMonth: TextCascadePickerRangeContent [] = []
  @Link yearreal:string
  @Link mounthreal:string
  @State year:string=''
  @State mounth:string=''
  @Builder
  Intop(){
    Stack({alignContent:Alignment.Center}){
      Row(){
        Text('取消')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          .onClick(()=>{
            this.controller.close()
          })
        Text('完成')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          .onClick(()=>{
            this.yearreal=this.year
            this.mounthreal=this.mounth
            this.controller.close()
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(10)
      Text('选择日期')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  build() {
    Column(){
      Row(){
        this.Intop()

      }
      TextPicker({ range: this.generateYearMonth })
        .onChange((value, index: number | number[]) => {
            let a =value as string[]
          this.year=a[0].replace("年", "")
          this.mounth=a[1].replace("月", "")
        })
    }
    .backgroundColor(Color.White)
  }
}