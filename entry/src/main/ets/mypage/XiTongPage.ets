import { promptAction, router } from '@kit.ArkUI';
import { fileIo } from '@kit.CoreFileKit';
import preferencesUtil from '../utils/PreferencesUtil';

export  class Myphone{
  phonenumber:string=''
}

@Entry
@Component
struct XiTongPage {
  @State phone:string=''
  aboutToAppear(): void {
    this.phone=(router.getParams() as Myphone).phonenumber
  }
  @Builder
  InTop(){
    Column({space:10}){
      Stack({alignContent:Alignment.Start}){
        Row(){
          Text('系统设置')
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
  @Builder
  OnRow(title:string){
    Row(){
      Text(title)
        .fontSize($r('app.string.TitleFontSize'))
      Image($r('app.media.ic_btn_more'))
        .width(30)
        .height(30)
    }
    .padding({ left:20 ,top:10,right:20,bottom:10 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
  build() {
    Column() {
      this.InTop()

      Column(){
        Row(){
          this.OnRow('换绑手机')
        }.width('100%')
        .onClick(()=>{
          router.pushUrl({
            url:'mypage/ChangePhonePage',
            params:{
              phonenumber:this.phone
            }
          })
        })
        Line()
          .ALine()
        Row(){
          this.OnRow('修改密码')
        }.width('100%')
        .onClick(()=>{
          router.pushUrl({
            url:'mypage/ChangePassword',
            params:{
              phonenumber:this.phone
            }
          })
        })
        Line()
          .ALine()
        Row(){
          this.OnRow('消息通知设置')
        }.width('100%')
        .onClick(()=>{
          router.pushUrl({
            url:'mypage/MessagePage'
          })
        })
        Line()
          .ALine()
        Row(){
          this.OnRow('清理缓存')
        }.width('100%')
        .onClick((event: ClickEvent) => {
          promptAction.showDialog({
            title:'清理缓存后会清空所有数据',
            buttons:[
              {
                text:'取消',
                color:'#000000'
              },
              {
                text:'确认',
                color:$r('app.color.Brand_Color')
              }
            ]
          })
            .then((resp)=>{
              let index=resp.index
              if(index==1){
                const cacheDir = getContext(this).cacheDir
                fileIo.rmdirSync(cacheDir)
                promptAction.showToast({
                  message:'已清理'
                })
              }
            })
        })

      }
      .borderRadius(10)
      .margin({top:20})
      .backgroundColor(Color.White)
      .width('95%')

      Column(){
       Text('退出')
      }
      .height(60)
      .onClick(()=>{
        promptAction.showDialog({
          title:'确定要退出吗？',
          buttons:[
            {
              text:'取消',
              color:'#000000'
            },
            {
              text:'退出',
              color:$r('app.color.Brand_Color')
            }
          ]
        })
          .then((resp)=>{
            let index=resp.index
            if(index==1){
              preferencesUtil.delValue('Authorization')
              router.pushUrl({
                url:'pages/Index'
              })
            }
          })
      })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderRadius(10)
      .margin({top:20})
      .backgroundColor(Color.White)
      .width('95%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}

@Extend(Line)
function  ALine(){
    .width('95%')
    .height(1)
    .backgroundColor($r('app.color.Neutral_Colors_Divided'))
}