import { promptAction, router } from '@kit.ArkUI';
import { GetAllTaskList, Register } from '../api/LoginDoApi';
import { axiosInstance } from '../http/Axois';
import { RegisterModel } from '../model/LoginDo';

import { validateChinesePhoneNumber } from '../utils/PhoneNumberDo';
import preferencesUtil from '../utils/PreferencesUtil';
import { Appstart } from './AppStart';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State timeout:number=0
  @State phonenumberiferror:boolean=false
  @State yanzhengma:boolean=false
  @State phoneinshow:string=''
  @State phonenumber:string=''
  @State yanzhengmanumber:string=''
  @State clickyanzheng:number=60
  @State ifhaveyanzheng:boolean=false
  @State password:string='123456'
  @State imageurl:string=''
  @State timeinstart:number=5
  dialogController:CustomDialogController=new CustomDialogController({
    builder:Appstart(),
    customStyle:true,
    maskColor:Color.Black
  })
  async aboutToAppear(): Promise<void> {
    router.clear()
    this.dialogController.open()
    let timeinstartdo=setInterval(()=>{
      this.timeinstart--
      if (this.timeinstart === 0) {
        clearInterval(timeinstartdo)
        this.dialogController.close()

        // bug  每次登陆时候无法验证token是否有效
        let preference=preferencesUtil.getValue('Authorization','') as string
        if (preference != '') {
          axiosInstance.defaults.headers.common['Authorization'] = preference
          let para:Record<string, string> = { 'Authorization': preference};
          let storage: LocalStorage = new LocalStorage(para);
          router.pushUrl({
            url:'mainpage/IndexPage'
          })
        }



      }
    },1000)

  }
  getyanzheng(){
    this.imageurl='http://123.57.165.155/driver/register/captcha?key='+this.phonenumber
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

  doregister(){
    Register(new RegisterModel(this.phonenumber,this.password, this.phonenumber,this.yanzhengmanumber))
      .then((value)=>{
        if (value) {
          promptAction.showToast({
            message:'注册成功'
          })
        }else {
          promptAction.showToast({
            message:'验证码过期或者账号已经存在请使用账号密码登陆'
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
        Text($r('app.string.LoginPhone'))
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Row(){
          Text($r('app.string.LoginAccount'))
            .fontColor($r('app.color.Auxiliary_Color_Error'))
            .fontWeight(FontWeight.Bold)
            .fontSize($r('app.string.TextTwoFontSize'))
          Image($r('app.media.ic_date_right'))
            .width(12)
            .height(12)
            .fillColor($r('app.color.Auxiliary_Color_Error'))
        }
        .onClick(()=>{
          router.pushUrl({
            url:'pages/LoginByAccount'
          })
        })
      }
      .padding(20)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      Column(){
        TextInput({placeholder:'请输入手机号',text:this.phoneinshow})
          .type(InputType.Number)
          .inputFilter('[0-9 ]')
          .input()
          .maxLength(13)
          .onChange((value)=>{
            let phone = value.toString()
            while (phone.indexOf(' ') != -1) {
              phone = phone.replace(' ', '')
            }
            this.phonenumber = phone
            this.phonenumberiferror=!validateChinesePhoneNumber(this.phonenumber)
            let temp: string = ''
            for (let i = 0; i < phone.length; i++) {
              temp = temp + phone[i]
              if (i == 2 || i == 6) {
                temp = temp + ' '
              }
            }
            this.phoneinshow = temp
          })
        Line()
          .lineStyle(this.phonenumberiferror)
        if (this.phonenumberiferror){
          Text($r('app.string.PhoneError'))
            .fontColor($r('app.color.Auxiliary_Color_Error'))
            .width('90%')
        }
        Row({space:10}){
          TextInput({placeholder:'请输入验证码'})
            .input()
            .maxLength(6)
            .type(InputType.Number)
            .width('70%')
            .onChange((value)=>{
              this.yanzhengmanumber=value
            })
          Text(this.ifhaveyanzheng?this.clickyanzheng+'s后重新获取':'获取验证码')
            .fontColor(this.ifhaveyanzheng?$r('app.color.Neutral_Colors_SecondaryText'):$r('app.color.Neutral_Colors_MainFont'))
            .fontSize(13)
            .onClick(()=>{
              this.getyanzheng()

            })
        }      // Image(this.imageurl)
        // .width('90%')

        Line()
          .lineStyle(this.yanzhengma)
        if (this.yanzhengma){
          Text($r('app.string.YanzhengError'))
            .fontColor($r('app.color.Auxiliary_Color_Error'))
            .width('90%')
        }
      }
      Button('登陆')
        .backgroundColor($r('app.color.Auxiliary_Color_Error'))
        .width('90%')
        .height(50)
        .margin({
          top:40
        })
        .onClick(()=>{
            this.doregister()
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
  .fontSize($r('app.string.TextTwoFontSize'))
  .backgroundColor($r('app.color.Neutral_Colors_NeutralColor_White'))
  // .border({
  //   radius:0,
  //   width:{
  //     bottom:1
  //   },
  //   color:iferror?$r('app.color.Auxiliary_Color_Error'):$r('app.color.Neutral_Colors_Formbox')
  // })
}

@Extend(Line)
function lineStyle(iferror:boolean) {
  .width('90%') // 宽度为父组件的100%
  .height(1) // 高度
  .backgroundColor(iferror?$r('app.color.Auxiliary_Color_Error'):$r('app.color.Neutral_Colors_Formbox')) // 背景颜色
}


