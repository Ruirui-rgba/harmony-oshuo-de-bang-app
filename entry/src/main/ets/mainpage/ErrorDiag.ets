@CustomDialog
@Component
export struct ErrorDiag{
  private controller:CustomDialogController
  @Link nowchoose:number
  @State nowtitle:string='发动机启动困难'
  @Link error:string
  @Builder
  InRow(title:string,index:number){
    Row(){
      Text(title)
        .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      Image(this.nowchoose==index?$r('app.media.ic_radio_true'):$r('app.media.ic_radio_false'))
        .width(25)
        .height(25)
    }
    .onClick(()=>{
      this.nowchoose=index
      this.nowtitle=title

    })
    .padding({left:20})
    .height(40)
    .width('95%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
  build() {
    Column(){
      Row(){
        Text('选择类型')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
        Image($r('app.media.ic_btn_close'))
          .width(25)
          .height(25)
          .onClick(()=>{
            this.controller.close()
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('95%')

      Line()
        .width('95%')
        .height(1)
        .backgroundColor($r('app.color.Neutral_Colors_Divided'))

      this.InRow('发动机启动困难',1)
      this.InRow('不着车，漏油',2)
      this.InRow('照明失灵',3)
      this.InRow('有异常响动',4)
      this.InRow('排烟异常，温度异常',5)
      this.InRow('其他问题',6)
    Button('确定')
      .width('90%')
      .height(60)
      .backgroundColor(Color.Red)
      .onClick(()=>{
        this.error=this.nowtitle
        this.controller.close()
      })
    }
    .backgroundColor(Color.White)
    .padding(20)
  }
}