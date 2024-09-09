import { promptAction, router } from '@kit.ArkUI'
import { validateChinesePhoneNumber } from '../utils/PhoneNumberDo'
import { Myphone } from './XiTongPage'

@Entry
@Component
struct ChangePassword {
  // 18877776666
  @State inpphonenumber:string=''
  @State TextError: string = ''
  @State realphone:string=''
  @State phonenumberiferror:boolean=false
  @State yanzheng:string=''
  @State YanZhengError: string = ''
  @State ifhaveyanzheng:boolean=false
  @State clickyanzheng:number=60
  @State NowPone:string=''
  @State Cansub:boolean=false
  @State newpassword:string=''
  aboutToAppear(): void {
    this.NowPone=(router.getParams() as Myphone).phonenumber
  }
  getyanzheng(){
    let imgurl='http://123.57.165.155/driver/register/captcha?key='+this.realphone
    // LoginByPhone(this.phonenumber)
    let timeyan=setInterval(()=>{
      this.ifhaveyanzheng=true
      this.clickyanzheng--
      if (this.clickyanzheng == 0) {
        clearInterval(timeyan)
        this.clickyanzheng=60
        this.ifhaveyanzheng=false
      }
    },1000)
  }
  @Builder
  InTop(){
    Column({space:10}){
      Stack({alignContent:Alignment.Start}){
        Row(){
          Text('换绑手机')
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
      Column(){
        Row(){
          TextInput({placeholder:'请输入已绑定手机号',text: this.inpphonenumber})
            .showUnderline(true)
            .width('90%')
            .showError(this.TextError)
            .onChange((value: string) => {
              let phone = value.toString()
              while (phone.indexOf(' ') != -1) {
                phone = phone.replace(' ', '')
              }
              this.realphone = phone
              this.NowPone==this.realphone?this.phonenumberiferror=false:this.phonenumberiferror=true
              if (this.phonenumberiferror) {
                this.TextError='手机号码错误'
                this.Cansub=false
              }else {
                this.TextError=''
                this.Cansub=true
              }
              let temp: string = ''
              for (let i = 0; i < phone.length; i++) {
                temp = temp + phone[i]
                if (i == 2 || i == 6) {
                  temp = temp + ' '
                }
              }
              this.inpphonenumber = temp
            })
        }
        .alignItems(VerticalAlign.Top)
        .height(70)
        Stack({alignContent:Alignment.End}){
          TextInput({placeholder:'请输入验证码',text: this.yanzheng})
            .showUnderline(true)
            .width('100%')
            .showError(this.YanZhengError)
            .onChange((value)=>{
              this.yanzheng=value
            })
          Text(this.ifhaveyanzheng?this.clickyanzheng+'s后重新获取':'获取验证码')
            .fontColor(this.ifhaveyanzheng?$r('app.color.Neutral_Colors_SecondaryText'):$r('app.color.Neutral_Colors_MainFont'))
            .fontSize(13)
            .onClick(()=>{
              if (this.TextError === ''&&this.realphone!='') {
                this.getyanzheng()
              }else {
                promptAction.showToast({
                  message:'请输入正确的手机号'
                })
              }

            })

        }
        .width('90%')
        TextInput({placeholder:'请输入新密码',text: this.newpassword})
          .type(InputType.Password)
          .showUnderline(true)
          .showError('')
          .borderRadius(0)
          .backgroundColor(Color.White)
          .width('95%')
          .onChange((value: string) => {
              this.newpassword=value
          })
      }

      Button('确定修改')
        .width('90%')
        .height(60)
        .fontColor(Color.White)
        .backgroundColor((this.Cansub&& this.yanzheng!='')?$r('app.color.Brand_Color'):'#f9dcd8')
        .margin({
          top:30
        })
        .onClick(()=>{
          if (this.Cansub && this.yanzheng != ''&&this.newpassword!='') {
            promptAction.showToast({
              message:'修改成功'
            })
            router.back()
          }
        })

    }
    .height('100%')
    .width('100%')
  }
}