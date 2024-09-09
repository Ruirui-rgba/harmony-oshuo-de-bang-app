import { router } from '@kit.ArkUI';
import { Mymessage, someMessage } from '../model/UserDo';
import preferencesUtil from '../utils/PreferencesUtil';

@Entry
@Component
struct MessagePage {
  @State Message:Array<Mymessage>=someMessage
  aboutToAppear(): void {

    for (let i = 0; i < this.Message.length; i++) {
      let pre=preferencesUtil.getValue('MyMessageHuancun:'+this.Message[i].id,'')
      if (pre!='') {
        if (pre === '0') {
          this.Message[i].value=true
        }else {
          this.Message[i].value=false
        }
      }
    }
  }
  @Builder
  OnRow(id:number,title:string,value:boolean){
    Row(){
      Text(title)
        .fontSize($r('app.string.TitleFontSize'))
      Toggle({ type: ToggleType.Switch, isOn: value })
        .onChange((value)=>{
          let c='0'
          if (value == true) {
            c='0'
          }else {
            c='1'
          }
          preferencesUtil.putValue('MyMessageHuancun:'+id,c)
        })
    }
    .padding(20)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }
  @Builder
  InTop(){
    Column({space:10}){
      Stack({alignContent:Alignment.Start}){
        Row(){
          Text('消息通知设置')
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
    }
    .width('100%')
    .backgroundColor(Color.White)
  }
  build() {
    Column() {
      this.InTop()
      Row(){
        Text('开启后，有新的任务通知你')
      }
      .width('95%')
      .height(40)
      ForEach(this.Message,(item:Mymessage)=>{
        this.OnRow(item.id,item.title,item.value)
      })
    }
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
    .height('100%')
    .width('100%')
  }
}