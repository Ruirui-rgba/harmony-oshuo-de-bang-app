import { router } from '@kit.ArkUI';
import { LoginByAcount } from '../api/LoginDoApi';
import { LoginModel } from '../model/LoginDo';

@Entry
@Component
struct LoginByAccount {
  @State message: string = 'Hello World';
  @State account:string=''
  @State password:string=''
  @State loading:boolean=false
  LoginDo(){
    LoginByAcount(new LoginModel(this.account,this.password))
      .then((value)=>{
        if (value) {
          this.loading=false
          router.pushUrl({
            url:'mainpage/IndexPage'
          })
        }
      })
  }
  build() {
    Column() {
      Row(){
        Text($r('app.string.IndexPage_title'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      Row(){
        Text($r('app.string.LoginAccount'))
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Row(){
          Text($r('app.string.LoginPhone'))
            .fontColor($r('app.color.Auxiliary_Color_Error'))
            .fontWeight(FontWeight.Bold)
            .fontSize($r('app.string.TextTwoFontSize'))
          Image($r('app.media.ic_date_right'))
            .width(12)
            .height(12)
            .fillColor($r('app.color.Auxiliary_Color_Error'))
        }
        .onClick(()=>{
          router.back()
        })
      }
      .padding(20)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      Column(){
        TextInput({placeholder:'请输入账号'})
          .type(InputType.Number)
          .input()
          .onChange((value)=>{
            this.account=value
          })
        TextInput({placeholder:'请输入密码'})
          .input()
          .type(InputType.Password)
          .width('90%')
          .onChange((value)=>{
            this.password=value
          })
      }
      if (this.loading){
        LoadingProgress() // 加载进度组件
          .color(Color.Black) // 颜色
          .width(50) // 宽度
          .height(50) // 高度
          .margin({ top: 20 }) // 上方边距
      }
      Button('登陆')
        .backgroundColor($r('app.color.Auxiliary_Color_Error'))
        .width('90%')
        .height(50)
        .margin({
          top:40
        })
        .onClick(()=>{
          if (!this.loading) {
            this.LoginDo()
            this.loading=true
          }
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.Neutral_Colors_NeutralColor_White'))
  }
}

@Extend(TextInput)
function input(){
  .width('90%')
  .height(60)
  .maxLength(11)
  .fontSize($r('app.string.TextTwoFontSize'))
  .backgroundColor($r('app.color.Neutral_Colors_NeutralColor_White'))
  .border({
    radius:0,
    width:{
      bottom:1
    },
    color:$r('app.color.Neutral_Colors_Formbox')
  })
}