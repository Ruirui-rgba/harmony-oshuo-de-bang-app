import { router } from '@kit.ArkUI';
import { MessageInModel } from '../model/MessageDo';

class routerinfo{
  item:MessageInModel

  constructor(item: MessageInModel) {
    this.item = item;
  }

}

@Entry
@Component
struct MessageToTalk {
  @State Messageinfo:MessageInModel=new MessageInModel(1,'',1,1,'',1,1,'',1,'',1,'',1)
  aboutToAppear(): void {
     let c=router.getParams() as routerinfo
    this.Messageinfo=c.item
  }
  @Builder
  Intop(){
    Stack({alignContent:Alignment.Center}){
      Row(){
        Image($r('app.media.ic_btn_nav_back'))
          .width(35)
          .height(35)
          .onClick(()=>{
            router.back()
          })
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .padding(10)
      Text('详情')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  build() {
    Column({space:10}) {
      this.Intop()
      Column({space:20}){
        Text(this.Messageinfo.title)
          .width('95%')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .textAlign(TextAlign.Start)
        Text(this.Messageinfo.updated)
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          .textAlign(TextAlign.Start)
          .width('95%')
        Text(this.Messageinfo.content)
          .width('95%')
          .textAlign(TextAlign.Start)
      }
      .padding(10)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
    }
    .backgroundColor(Color.White)
    .height('100%')
    .width('100%')
  }
}