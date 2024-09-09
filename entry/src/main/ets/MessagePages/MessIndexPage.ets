import { GetMessageIndex } from '../api/MessAgeApi'
import { MessageInModel } from '../model/MessageDo'
import { MessageShow } from './MessageShow'
import { MessageXitong } from './MessageXitongShow'
import { router } from '@kit.ArkUI'

@Component
export struct IndexMessage{
  @State indexnumber:number=0
  @State Message:Array<MessageInModel>=[]
  @State MessageXitong:Array<MessageInModel>=[]
  @State page:number=1
  @State pages:number=1
  @State contentType:number=200
  @Provide allread:boolean=false
  @Provide allreadxitong:boolean=false
  @State Xipage:number=1
  @State Xipages:number=1
  aboutToAppear(): void {
    GetMessageIndex(200,1,10)
      .then((value)=>{
        if (value.items.length>=1) {
          this.Message=value.items
          this.page=value.page
          this.pages=value.pages
          console.info(`pages===${this.pages}`)
        }
      })
    GetMessageIndex(201,1,10)
      .then((value)=>{
        if (value.items.length>=1) {
          this.Xipage=value.page
          this.Xipages=value.pages
          this.MessageXitong=value.items
        }
      })
  }
  @Builder
  InTop(){
    Column({space:10}){
      Stack({alignContent:Alignment.Start}){
        Row(){
          Text('消息')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        Image($r('app.media.ic_btn_nav_back'))
          .width(30)
          .height(30)
          .onClick(()=>{
            router.back()
          })
      }
      .width('95%')
      Row(){
        Column({space:10}){
          Text('公告')
            .fontSize($r('app.string.TitleFontSize'))
            .fontColor(0===this.indexnumber?$r('app.color.Neutral_Colors_MainFont'):$r('app.color.Neutral_Colors_SecondaryText'))
          if (this.indexnumber==0){
            Line()
              .height(4)
              .width(24)
              .borderRadius(4)
              .backgroundColor($r('app.color.Auxiliary_Color_Error'))
              .margin({top:4})
          }
        }
        .onClick(()=>{
          if (this.indexnumber != 0) {
            this.indexnumber=0
          }
        })
        Column({space:10}){
          Text('任务通知')
            .fontSize($r('app.string.TitleFontSize'))
            .fontColor(1===this.indexnumber?$r('app.color.Neutral_Colors_MainFont'):$r('app.color.Neutral_Colors_SecondaryText'))
          if (this.indexnumber==1){
            Line()
              .height(4)
              .width(24)
              .borderRadius(4)
              .backgroundColor($r('app.color.Auxiliary_Color_Error'))
              .margin({top:4})
          }
        }
        .onClick(()=>{
          if (this.indexnumber != 1) {
            this.indexnumber=1
          }
        })
      }
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left:40,right:40})
      .width('80%')
    }
    .width('100%')
    .backgroundColor(Color.White)
  }
  build() {
    Column(){
      this.InTop()
      Row(){
        Image($r('app.media.ic_yidu'))
          .width(25)
          .height(25)
        Text('全部已读')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      }
      .onClick(()=>{
      //   全部已读
        if (this.indexnumber==0) {
          this.allread=!this.allread
        }
        if (this.indexnumber==1) {
          this.allreadxitong=!this.allreadxitong
        }
      })
      .padding(20)
      .width('100%')
      Column(){
        if (this.indexnumber==0){
          MessageShow({
            Message:this.Message,
            page:this.page
          })
        }
        if (this.indexnumber==1){
          MessageXitong({
            Message:this.MessageXitong,
            page:this.Xipage,
            pages:this.Xipages
          })
        }
      }
      .height('85%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}