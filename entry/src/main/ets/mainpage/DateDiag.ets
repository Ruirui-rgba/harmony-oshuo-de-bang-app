@CustomDialog
@Component
export struct DateDiag{
  @Prop time:Date
  @Link dalytime:string
  private controller:CustomDialogController
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
            let year=this.time.getFullYear().toString()
            let month=this.time.getMonth()+1<10?'0'+(this.time.getMonth()+1):(this.time.getMonth()+1).toString()
            let day=this.time.getDate()<10?'0'+(this.time.getDate()):(this.time.getDate()).toString()
            let hour=this.time.getHours()<10?'0'+this.time.getHours():this.time.getHours().toString()
            let min=this.time.getMinutes()<10?'0'+this.time.getMinutes():this.time.getMinutes().toString()
            this.dalytime=`${year}-${month}-${day} ${hour}:${min}`
            this.controller.close()
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(10)
      Text('任务详情')
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
      TimePicker({
        selected:this.time
      })
        .onChange((value)=>{
          this.time.setHours(value.hour, value.minute)
        })
        .useMilitaryTime(true)
    }
      .backgroundColor(Color.White)
  }
}