import { promptAction, router } from '@kit.ArkUI'
import { UrlImg } from '../model/TaskDo'
import { gettime } from './ErrorMessage'
import { imgialog } from './IndexPageStruct/ImgDia'
import { common, Permissions } from '@kit.AbilityKit'
import { checkPermissions } from '../utils/PermissionUtil'
import { chossleImage, uploadImg } from '../utils/PhotoUtil'
import { HuiCheModel, HuiCheViewModel } from '../model/HuoWuDo'
import { HuiCheDengJi } from '../api/HuoWuApi'
import { emitter } from '@kit.BasicServicesKit'

const permissions: Array<Permissions> = ['ohos.permission.READ_MEDIA'];
const context = getContext(this) as common.UIAbilityContext
class getJob{
  jobId:string=''
  gotime:string=''
}
@Entry
@Component
struct HuiChePage {
  @State gotime:string=''
  @State backtime:string=''
  @State taskid:string=''
  @State ifweizhang:boolean=false   //车辆是否违章 -
  @State WeizhangIndex:string='1'  //违章类型 -
  @State Fakuan:string='0'  //罚款金额 -
  @State KouFen:number=0   //扣分金额 -
  @State breakRulesDescription:string=''   //违章类型说明  - 为其他的时候调用
  @State ifguzhang:boolean=false   //车辆是否故障
  @State GuzhangType:string='1'  //故障类型
  @State GuzhangMessage:string=''  //故障说明
  @State GuzhangImg:Array<UrlImg>=[]   //故障图片列表
  @State imgpath:string=''
  @State ifShigu:boolean=false  //车辆是否事故  -
  @State ShiguType:string='1'  //事故类型 -
  @State ShiguMessage:string=''  //事故说明 -
  @State ShiguImg:Array<UrlImg>=[]   //事故图片列表 -
  @State HuiCheView:HuiCheModel=HuiCheViewModel
  @State ifsub:boolean=true
  selectedDate: Date = new Date()
  aboutToAppear(): void {
    this.taskid=(router.getParams() as getJob).jobId
    this.gotime=(router.getParams() as getJob).gotime
    this.HuiCheView.id=this.taskid
    this.HuiCheView.startTime= this.gotime
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
      Text('回车登记')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  changetodate(){
    this.backtime=gettime(this.selectedDate)
  }
  openDatetick(){
    DatePickerDialog.show({
      start: new Date("2000-1-1"),
      end: new Date(),
      selected: this.selectedDate,
      showTime:true,
      useMilitaryTime:false,
      onDateAccept: (value: Date) => {
        this.selectedDate = value
        this.changetodate()
      },
    })
  }

  // 判断当某个选项为false时  清除对应的照片
  OnSub(){
    this.ifsub=false
    this.HuiCheView.endTime=this.backtime

    if (this.ifShigu) {
      this.HuiCheView.isAccident=true
      this.HuiCheView.accidentType= this.ShiguType
      this.HuiCheView.accidentImagesList=this.ShiguImg
      if (this.ShiguType==='9') {
        this.HuiCheView.accidentDescription=this.ShiguMessage
      }
    }

    if (this.ifweizhang) {

      this.HuiCheView.isBreakRules=true
      this.HuiCheView.breakRulesType= this.WeizhangIndex
      this.HuiCheView.penaltyAmount= this.Fakuan
      this.HuiCheView.deductPoints=this.KouFen
      if (this.WeizhangIndex==='6') {
        this.HuiCheView.breakRulesDescription=this.breakRulesDescription
      }
    }

    if (this.ifguzhang) {
      this.HuiCheView.isFault=true
      this.HuiCheView.faultType=this.GuzhangType
      this.HuiCheView.faultImagesList=this.GuzhangImg
      if (this.GuzhangType === '9') {
        this.HuiCheView.faultDescription=this.GuzhangMessage
      }
    }

    // bug  后端报错400
    HuiCheDengJi(this.HuiCheView)
      .then((value)=>{
        if (value) {
          promptAction.showToast({
            message:'成功'
          })
        }else {
          promptAction.showToast({
            message:'失败'
          })
        }
        router.back()
        emitter.emit({eventId:2})
      })
    console.info(`=====${JSON.stringify(this.HuiCheView)}`)
  }

  //   故障  上传并获取照片url
  GetGuZhangImgUrl(){
    // 获取权限
    checkPermissions(permissions,context)
      .then((value)=>{
        chossleImage()
          .then((value)=>{
            for (let i = 0; i < value.length; i++) {
                let c:Array<UrlImg>=[]
                c.push(new UrlImg(value[i]))
                let a=Date.now().toString()
                uploadImg(value[i],a,context)
                  .then((value)=>{
                    let c=new UrlImg(value)
                    this.GuzhangImg.push(c)
                  })

            }
          })
          .catch((error:Error)=>{
            console.info(`errorin this :${error}`)
          })
      })
  }

  //   故障  删除照片
  DelGuzhangImg(index:number){
    this.ShiguImg.splice(index,1)
  }


  //   事故  上传并获取照片url
  GetShiguImgUrl(){
    // 获取权限
    checkPermissions(permissions,context)
      .then((value)=>{
        chossleImage()
          .then((value)=>{
            for (let i = 0; i < value.length; i++) {
              let c:Array<UrlImg>=[]
              c.push(new UrlImg(value[i]))
              let a=Date.now().toString()
              uploadImg(value[i],a,context)
                .then((value)=>{
                  let c=new UrlImg(value)
                  this.ShiguImg.push(c)
                })

            }
          })
          .catch((error:Error)=>{
            console.info(`errorin this :${error}`)
          })
      })
  }

  //   事故  删除照片
  DelShiguImg(index:number){
    this.GuzhangImg.splice(index,1)
  }


  dialogController:CustomDialogController=new CustomDialogController({
    builder:imgialog({
      imgpath:this.imgpath
    }),
    cancel:()=>{
      this.imgpath=''
    },
    customStyle:true,
    maskColor:Color.Black
  })

  // 违章的类型
  @Builder
  Weizhang(title:string,index:string){
    Text(title)
      .width('30%')
      .height(40)
      .backgroundColor(this.WeizhangIndex===index?'#ffe0dd':'#f5f5f5')
      .borderWidth(this.WeizhangIndex===index?2:0)
      .borderRadius(10)
      .borderColor(this.WeizhangIndex===index?Color.Red:'')
      .fontColor(this.WeizhangIndex===index?Color.Red:Color.Black)
      .textAlign(TextAlign.Center)
      .onClick(()=>{
        this.WeizhangIndex=index
      })
  }

  // 罚款的金额
  @Builder
  FaMoney(title:string){
    Text(title+'元')
      .width('30%')
      .height(40)
      .backgroundColor(this.Fakuan===title?'#ffe0dd':'#f5f5f5')
      .borderWidth(this.Fakuan===title?2:0)
      .borderRadius(10)
      .borderColor(this.Fakuan===title?Color.Red:'')
      .fontColor(this.Fakuan===title?Color.Red:Color.Black)
      .textAlign(TextAlign.Center)
      .onClick(()=>{
        this.Fakuan=title
      })
  }

  // 扣分的额度
  @Builder
  KouPoint(title:number){
    Text(title+'分')
      .width('30%')
      .height(40)
      .backgroundColor(this.KouFen==title?'#ffe0dd':'#f5f5f5')
      .borderWidth(this.KouFen==title?2:0)
      .borderRadius(10)
      .borderColor(this.KouFen==title?Color.Red:'')
      .fontColor(this.KouFen==title?Color.Red:Color.Black)
      .textAlign(TextAlign.Center)
      .onClick(()=>{
        this.KouFen=title
      })
  }

  // 故障的类型
  @Builder
  GuZhang(title:string,index:string){
    Text(title)
      .width('30%')
      .height(40)
      .backgroundColor(this.GuzhangType===index?'#ffe0dd':'#f5f5f5')
      .borderWidth(this.GuzhangType===index?2:0)
      .borderRadius(10)
      .borderColor(this.GuzhangType===index?Color.Red:'')
      .fontColor(this.GuzhangType===index?Color.Red:Color.Black)
      .textAlign(TextAlign.Center)
      .onClick(()=>{
        this.GuzhangType=index
      })
  }

  // 事故的类型
  @Builder
  ShiGu(title:string,index:string){
    Text(title)
      .width('30%')
      .height(40)
      .backgroundColor(this.ShiguType===index?'#ffe0dd':'#f5f5f5')
      .borderWidth(this.ShiguType===index?2:0)
      .borderRadius(10)
      .borderColor(this.ShiguType===index?Color.Red:'')
      .fontColor(this.ShiguType===index?Color.Red:Color.Black)
      .textAlign(TextAlign.Center)
      .onClick(()=>{
        this.ShiguType=index
      })
  }


  build() {
      Column() {
        this.Intop()
        Scroll(){
          Column(){
            Column(){


              Row(){
                Text('出车时间')
                  .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
                Text(this.gotime)
                  .fontColor($r('app.color.Neutral_Colors_MainFont'))
              }
              .padding(10)
              .height(40)
              .width('95%')
              .justifyContent(FlexAlign.SpaceBetween)

              Line()
                .width('95%')
                .height(1)
                .backgroundColor($r('app.color.Neutral_Colors_Divided'))

              Row(){
                Text('回车时间')
                  .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
                Row({space:5}){
                  Text(this.backtime=''?'请选择':this.backtime)
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))
                  Image($r('app.media.ic_btn_more'))
                    .width(35)
                    .height(35)
                }
              }
              .padding(10)
              .onClick(()=>{
                this.openDatetick()
              })
              .height(40)
              .width('95%')
              .justifyContent(FlexAlign.SpaceBetween)




            }
            .padding({top:10,bottom:10})
            .margin({ top:20 })
            .backgroundColor(Color.White)
            .width('95%')
            .borderRadius(10)


            // 车辆违章
            Column(){
              Row(){
                Text('车辆违章')
                  .fontColor($r('app.color.Neutral_Colors_MainFont'))
                Row({space:10}){
                  Row({space:5}){
                    Image(this.ifweizhang?$r('app.media.ic_radio_true'):$r('app.media.ic_radio_false'))
                      .width(25)
                      .height(25)
                      .onClick(()=>{
                        this.ifweizhang=true
                      })
                    Text('是')
                      .fontColor($r('app.color.Neutral_Colors_MainFont'))
                  }
                  Row({space:5}){
                    Image(!this.ifweizhang?$r('app.media.ic_radio_true'):$r('app.media.ic_radio_false'))
                      .width(25)
                      .height(25)
                      .onClick(()=>{
                        this.ifweizhang=false
                      })
                    Text('否')
                      .fontColor($r('app.color.Neutral_Colors_MainFont'))
                  }
                }
              }
              .padding(10)
              .height(40)
              .width('95%')
              .justifyContent(FlexAlign.SpaceBetween)


              if (this.ifweizhang){
                // 有违章 开启这个
                Line()
                  .width('95%')
                  .height(1)
                  .backgroundColor($r('app.color.Neutral_Colors_Divided'))

                // 违章类型
                Row(){
                  Text('违章类型')
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))
                }
                .padding(10)
                .height(40)
                .width('95%')
                .justifyContent(FlexAlign.Start)
                Row(){
                  this.Weizhang('闯红灯','1')
                  this.Weizhang('无证驾驶','2')
                  this.Weizhang('超载','3')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  this.Weizhang('酒后驾驶','4')
                  this.Weizhang('超速行驶','5')
                  this.Weizhang('其他','6')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)



                // 为其他时候的描述

                if (this.WeizhangIndex==='6'){
                  Stack({alignContent:Alignment.BottomEnd}){
                    TextArea({placeholder:'请简单描述违章',text:this.breakRulesDescription})
                      .width('100%')
                      .height(130)
                      .onChange((value)=>{
                        this.breakRulesDescription=value
                      })
                      .align(Alignment.TopStart)
                      .maxLines(3)
                      .maxLength(50)
                      .border({
                        radius:10
                      })
                    Text(this.breakRulesDescription.length+'/50')
                      .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
                      .fontSize($r('app.string.TextTwoFontSize'))
                  }
                  .margin({bottom:20})
                  .alignSelf(ItemAlign.Center)
                  .width('95%')

                }


                // 罚款金额
                Row(){
                  Text('罚款金额')
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))
                }
                .padding(10)
                .height(40)
                .width('95%')
                .justifyContent(FlexAlign.Start)
                Row(){
                  this.FaMoney('0')
                  this.FaMoney('100')
                  this.FaMoney('200')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  this.FaMoney('300')
                  this.FaMoney('500')
                  this.FaMoney('1000')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)


                // 扣分
                Row(){
                  Text('扣分')
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))
                }
                .padding(10)
                .height(40)
                .width('95%')
                .justifyContent(FlexAlign.Start)
                Row(){
                  this.KouPoint(0)
                  this.KouPoint(1)
                  this.KouPoint(2)
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  this.KouPoint(3)
                  this.KouPoint(6)
                  this.KouPoint(12)
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
              }



            }
            .padding({top:10,bottom:10})
            .margin({ top:20 })
            .backgroundColor(Color.White)
            .width('95%')
            .borderRadius(10)


            //   车辆故障
            Column(){
              Row(){
                Text('车辆故障')
                  .fontColor($r('app.color.Neutral_Colors_MainFont'))
                Row({space:10}){
                  Row({space:5}){
                    Image(this.ifguzhang?$r('app.media.ic_radio_true'):$r('app.media.ic_radio_false'))
                      .width(25)
                      .height(25)
                      .onClick(()=>{
                        this.ifguzhang=true
                      })
                    Text('是')
                      .fontColor($r('app.color.Neutral_Colors_MainFont'))
                  }
                  Row({space:5}){
                    Image(!this.ifguzhang?$r('app.media.ic_radio_true'):$r('app.media.ic_radio_false'))
                      .width(25)
                      .height(25)
                      .onClick(()=>{
                        this.ifguzhang=false
                      })
                    Text('否')
                      .fontColor($r('app.color.Neutral_Colors_MainFont'))
                  }
                }
              }
              .padding(10)
              .height(40)
              .width('95%')
              .justifyContent(FlexAlign.SpaceBetween)


              if (this.ifguzhang){
                // 有违章 开启这个
                Line()
                  .width('95%')
                  .height(1)
                  .backgroundColor($r('app.color.Neutral_Colors_Divided'))

                // 故障类型
                Row(){
                  Text('故障类型')
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))
                }
                .padding(10)
                .height(40)
                .width('95%')
                .justifyContent(FlexAlign.Start)
                Row(){
                  this.GuZhang('启动困难','1')
                  this.GuZhang('不着车','2')
                  this.GuZhang('漏油','3')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  this.GuZhang('漏水','4')
                  this.GuZhang('照明失灵','5')
                  this.GuZhang('有异响','6')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  this.GuZhang('排烟异常','7')
                  this.GuZhang('温度异常','8')
                  this.GuZhang('其他','9')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)



                // 为其他时候的描述

                if (this.GuzhangType==='9'){
                  Stack({alignContent:Alignment.BottomEnd}){
                    TextArea({placeholder:'请简单描述故障',text:this.GuzhangMessage})
                      .width('100%')
                      .height(130)
                      .onChange((value)=>{
                        this.GuzhangMessage=value
                      })
                      .align(Alignment.TopStart)
                      .maxLines(3)
                      .maxLength(50)
                      .border({
                        radius:10
                      })
                    Text(this.GuzhangMessage.length+'/50')
                      .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
                      .fontSize($r('app.string.TextTwoFontSize'))
                  }
                  .margin({bottom:20})
                  .alignSelf(ItemAlign.Center)
                  .width('95%')

                }


                Row(){
                  Text('请拍照')
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))

                }
                .padding(10)
                .height(40)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)

                Column({space:20}){
                  Text(){
                    ForEach(this.GuzhangImg,
                      (item:UrlImg,index:number)=>{
                        ContainerSpan(){
                          ImageSpan(item.url)
                            .imagespando()
                            .onClick(()=>{
                              this.imgpath=item.url
                              this.dialogController.open()
                            })
                          ImageSpan($r('app.media.ic_btn_delete'))
                            .width(20)
                            .height(20)
                            .onClick(()=>{
                              this.DelGuzhangImg(index)
                            })
                        }
                      })
                  }
                  .width('100%')
                  Column(){
                    Image($r('app.media.ic_add_img'))
                      .imagedo()
                  }
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
                  .width(100)
                  .height(100)
                  .onClick(()=>{
                    this.GetGuZhangImgUrl()
                  })

                }
                .alignItems(HorizontalAlign.Start)
                .width('95%')
                .padding(10)
              }






            }
            .padding({top:10,bottom:10})
            .margin({ top:20 })
            .backgroundColor(Color.White)
            .width('95%')
            .borderRadius(10)


            //   车辆事故
            Column(){
              Row(){
                Text('事故类型')
                  .fontColor($r('app.color.Neutral_Colors_MainFont'))
                Row({space:10}){
                  Row({space:5}){
                    Image(this.ifShigu?$r('app.media.ic_radio_true'):$r('app.media.ic_radio_false'))
                      .width(25)
                      .height(25)
                      .onClick(()=>{
                        this.ifShigu=true
                      })
                    Text('是')
                      .fontColor($r('app.color.Neutral_Colors_MainFont'))
                  }
                  Row({space:5}){
                    Image(!this.ifguzhang?$r('app.media.ic_radio_true'):$r('app.media.ic_radio_false'))
                      .width(25)
                      .height(25)
                      .onClick(()=>{
                        this.ifguzhang=false
                      })
                    Text('否')
                      .fontColor($r('app.color.Neutral_Colors_MainFont'))
                  }
                }
              }
              .padding(10)
              .height(40)
              .width('95%')
              .justifyContent(FlexAlign.SpaceBetween)


              if (this.ifShigu){
                // 有事故 开启这个
                Line()
                  .width('95%')
                  .height(1)
                  .backgroundColor($r('app.color.Neutral_Colors_Divided'))

                // 事故类型
                Row(){
                  Text('事故类型')
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))
                }
                .padding(10)
                .height(40)
                .width('95%')
                .justifyContent(FlexAlign.Start)
                Row(){
                  this.ShiGu('直行事故','1')
                  this.ShiGu('追尾事故','2')
                  this.ShiGu('超车事故','3')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  this.ShiGu('左转弯事故','4')
                  this.ShiGu('右转弯事故','5')
                  this.ShiGu('弯道事故','6')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)
                Row(){
                  this.ShiGu('坡道事故','7')
                  this.ShiGu('会车事故','8')
                  this.ShiGu('其他','9')
                }
                .padding(10)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)



                // 为其他时候的描述

                if (this.ShiguType==='9'){
                  Stack({alignContent:Alignment.BottomEnd}){
                    TextArea({placeholder:'请简单描述故障',text:this.ShiguMessage})
                      .width('100%')
                      .height(130)
                      .onChange((value)=>{
                        this.ShiguMessage=value
                      })
                      .align(Alignment.TopStart)
                      .maxLines(3)
                      .maxLength(50)
                      .border({
                        radius:10
                      })
                    Text(this.ShiguMessage.length+'/50')
                      .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
                      .fontSize($r('app.string.TextTwoFontSize'))
                  }
                  .margin({bottom:20})
                  .alignSelf(ItemAlign.Center)
                  .width('95%')

                }


                Row(){
                  Text('请拍照')
                    .fontColor($r('app.color.Neutral_Colors_MainFont'))

                }
                .padding(10)
                .height(40)
                .width('95%')
                .justifyContent(FlexAlign.SpaceBetween)

                Column({space:20}){
                  Text(){
                    ForEach(this.ShiguImg,
                      (item:UrlImg,index:number)=>{
                        ContainerSpan(){
                          ImageSpan(item.url)
                            .imagespando()
                            .onClick(()=>{
                              this.imgpath=item.url
                              this.dialogController.open()
                            })
                          ImageSpan($r('app.media.ic_btn_delete'))
                            .width(20)
                            .height(20)
                            .onClick(()=>{
                              this.DelShiguImg(index)
                            })
                        }
                      })
                  }
                  .width('100%')
                  Column(){
                    Image($r('app.media.ic_add_img'))
                      .imagedo()
                  }
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
                  .width(100)
                  .height(100)
                  .onClick(()=>{
                    this.GetShiguImgUrl()
                  })

                }
                .alignItems(HorizontalAlign.Start)
                .width('95%')
                .padding(10)

              }







            }
            .padding({top:10,bottom:10})
            .margin({ top:20 })
            .backgroundColor(Color.White)
            .width('95%')
            .borderRadius(10)



          }
        }
        .align(Alignment.Top)
        .scrollBar(BarState.Off)
        .height('85%')
        Row(){
          Button('交车')
            .backgroundColor(this.backtime!=''&&this.ifsub?$r('app.color.Brand_Color'):'#f9dcd8')
            .fontColor(Color.White)
            .width('90%')
            .height(60)
            .onClick(()=>{
              if (this.backtime != '') {
                this.OnSub()
              }
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .padding({left:20,right:20 ,top:10,bottom:10})
        .backgroundColor(Color.White)

      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}


@Extend(ImageSpan)
function  imagespando(){
  .width(100)
  .height(100)
  .margin({bottom:20})

}

@Extend(Image)
function  imagedo(){
  .width(40)
  .height(40)
}
