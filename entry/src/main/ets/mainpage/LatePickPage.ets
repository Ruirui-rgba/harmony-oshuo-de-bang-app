import { promptAction, router } from '@kit.ArkUI';
import { LateToPick } from '../api/LatePickApi';
import { LatePiceModel } from '../model/LatePickDo';
import { DateDiag } from './DateDiag';

class myrouterinfo{
    id:string='0'
    time:string='2000-01-01 00:00:00'
}

@Entry
@Component
struct LatePickPage {
  @State taskid:string=''
  @State time:string=''
  @State @Watch('iftrue')dalytime:string=''
  @State ifdosub:boolean=false
  @State @Watch('iftrue')textinp:string=''
  iftrue(){
    if (this.dalytime != '' && this.textinp!='') {
      this.ifdosub=true
    }
  }
  @State ti:Date=new Date('2020-12-25T08:30:00')
  dialogController:CustomDialogController=new CustomDialogController({
    builder:DateDiag({
      time:this.ti,
      dalytime:this.dalytime
    }),
    customStyle:true,
    alignment:DialogAlignment.Bottom
  })
  aboutToAppear(): void {
    let info:myrouterinfo=router.getParams() as myrouterinfo
    this.taskid=info.id
    this.time=info.time
  }
  gettime(){
    this.ti=new Date(this.time)
    console.info(`date = : ${this.ti.getHours()}`)
    console.info(`date = : ${this.ti.getMinutes()}`)
    this.dialogController.open()
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
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(10)
      Text('延迟提货')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  build() {
    Column() {
      this.Intop()
      Column(){
        Row(){
          Text('原定时间')
            .fontColor($r('app.color.Neutral_Colors_MainFont'))
            .fontSize($r('app.string.TextOneFontSize'))
          Text(this.time)
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            .fontSize($r('app.string.TextTwoFontSize'))
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left:20, top:15,bottom:15 ,right:20})
        .width('100%')
        Line()
          .width('95%')
          .height(1)
          .backgroundColor($r('app.color.Neutral_Colors_Divided'))
        Row(){
          Text('延迟时间')
            .fontColor($r('app.color.Neutral_Colors_MainFont'))
            .fontSize($r('app.string.TextOneFontSize'))
          Row({space:5}){
            Text(this.dalytime==''?'不可超过2个小时':this.dalytime)
              .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
              .fontSize($r('app.string.TextTwoFontSize'))
            Image($r('app.media.ic_btn_more'))
              .width(25)
              .height(25)
          }
        }
        .onClick(()=>{
          this.gettime()
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({left:20, top:15,bottom:15,right:20})
        .width('100%')
        Line()
          .width('95%')
          .height(1)
          .backgroundColor($r('app.color.Neutral_Colors_Divided'))
        Stack({alignContent:Alignment.BottomEnd}){
          TextArea({placeholder:'请输入延迟提货原因',text:this.textinp})
            .width('100%')
            .height(130)
            .onChange((value)=>{
                this.textinp=value
            })
            .align(Alignment.TopStart)
            .maxLines(3)
            .maxLength(50)
            .border({
              radius:10
            })
          Text(this.textinp.length+'/50')
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            .fontSize($r('app.string.TextTwoFontSize'))
        }
        .margin({bottom:20})
        .alignSelf(ItemAlign.Center)
        .width('95%')
        Button('提交')
          .width(100)
          .height(30)
          .backgroundColor(this.ifdosub?$r('app.color.Brand_Color'):'#f9dcd8')
          .margin({bottom:20})
          .onClick(()=>{
            if (this.ifdosub) {
              this.ifdosub=false
              LateToPick(new LatePiceModel(this.taskid,this.dalytime,this.textinp))
                .then((value)=>{
                  if (value) {
                    promptAction.showToast({
                      message:'提交成功'
                    })
                    router.pushUrl({
                      url:'mainpage/IndexPage'
                    })
                  }else {
                    promptAction.showToast({
                      message:'系统异常'
                    })
                  }
                })
            }
          })
      }
      .width('95%')
      .backgroundColor(Color.White)
      .margin({top:20})
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}