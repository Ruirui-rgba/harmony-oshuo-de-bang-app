import { promptAction, router } from '@kit.ArkUI'
import { UrlImg } from '../model/TaskDo'
import { ErrorDiag } from './ErrorDiag'
import { imgialog } from './IndexPageStruct/ImgDia'
import { common, Permissions } from '@kit.AbilityKit'
import { checkPermissions } from '../utils/PermissionUtil'
import { chossleImage, uploadImg } from '../utils/PhotoUtil'
import { ErrorModel, ErrorView } from '../model/ErrorDo'
import { ErrorSub } from '../api/ErrorMessageApi'

class myinfo{
  transportTaskId:string=''
}
const permissions: Array<Permissions> = ['ohos.permission.READ_MEDIA'];
const context = getContext(this) as common.UIAbilityContext
@Entry
@Component
struct ErrorMessage {
  @State nowdate:string=gettime(new Date())
  @State transportTaskId:string=''
  @State Postation:string='北京市 北京市 海淀区'
  @State ErrorRype:string=''
  @State nowchoose:number=1
  @State textinp:string=''
  @State imgs:Array<UrlImg>=[]
  @State imgpath:string=''
  selectedDate: Date = new Date()
  @State date:string=''
  @State ifsub:boolean=false

  @State ErrorMessageDo:ErrorModel=ErrorView
  dialogController:CustomDialogController=new CustomDialogController({
    builder:ErrorDiag({
      error:this.ErrorRype,
      nowchoose:this.nowchoose
    }),
    customStyle:true,
    alignment:DialogAlignment.Bottom
  })

  dialogControllerImg:CustomDialogController=new CustomDialogController({
    builder:imgialog({
      imgpath:this.imgpath
    }),
    cancel:()=>{
      this.imgpath=''
    },
    customStyle:true,
    maskColor:Color.Black
  })
  GetPermissonThenUploadGetUrl(){
    // 获取权限
    checkPermissions(permissions,context)
      .then((value)=>{
        chossleImage()
          .then(async (value)=>{
            for (let i = 0; i < value.length; i++) {
                if (this.imgs.length<6){
                  await uploadImg(value[i],Date.now().toString(),context)
                    .then((value)=>{
                      let c=new UrlImg(value)
                      this.imgs.push(c)
                    })
                }
            }
          })
          .catch((error:Error)=>{
            console.info(`errorin this :${error}`)
          })
      })
  }
  delbyHuoImg(index:number){
    this.imgs.splice(index,1)
  }
  aboutToAppear(): void {
    this.transportTaskId= (router.getParams() as myinfo).transportTaskId

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
      Text('异常详情')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  changetodate(){
    this.date=gettime(this.selectedDate)
    this.nowdate=this.date
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
  @Builder
  InRow(title:string,message:string){
    Row(){
      Text(title)
        .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      Row({space:5}){
        Text(message)
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
        Image($r('app.media.ic_btn_more'))
          .width(35)
          .height(35)
      }
    }
    .padding({left:20 , top:10 , bottom:10})
    .height(40)
    .width('95%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
  build() {
    Column() {
      this.Intop()
      Scroll(){
        Column(){
          Column(){
            // Row(){
            //   this.InRow('异常时间',this.nowdate)
            // }
            // .onClick(()=>{
            //   this.openDatetick()
            // })

            Row(){
              Text('异常时间')
                .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
              Row({space:5}){
                Text(this.nowdate)
                  .fontColor($r('app.color.Neutral_Colors_MainFont'))
                Image($r('app.media.ic_btn_more'))
                  .width(35)
                  .height(35)
              }
            }
            .onClick(()=>{
              this.openDatetick()
            })
            .padding({left:20 , top:10 , bottom:10})
            .height(40)
            .width('95%')
            .justifyContent(FlexAlign.SpaceBetween)



            Line()
              .width('95%')
              .height(1)
              .backgroundColor($r('app.color.Neutral_Colors_Divided'))

            // this.InRow('上报位置',this.Postation)

            Row(){
              Text('上报位置')
                .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
              Row({space:5}){
                Text(this.Postation)
                  .fontColor($r('app.color.Neutral_Colors_MainFont'))
                Image($r('app.media.ic_btn_more'))
                  .width(35)
                  .height(35)
              }
            }
            .padding({left:20 , top:10 , bottom:10})
            .height(40)
            .width('95%')
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(()=>{
                router.pushUrl({
                  url:''
                })
            })


            Line()
              .width('95%')
              .height(1)
              .backgroundColor($r('app.color.Neutral_Colors_Divided'))


            Row(){
              Text('异常类型')
                .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
              Row({space:5}){
                Text(this.ErrorRype)
                  .fontColor($r('app.color.Neutral_Colors_MainFont'))
                Image($r('app.media.ic_btn_more'))
                  .width(35)
                  .height(35)
              }
            }
            .padding({left:20 , top:10 , bottom:10})
            .height(40)
            .width('95%')
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(()=>{
              this.dialogController.open()
            })


            Line()
              .width('95%')
              .height(1)
              .backgroundColor($r('app.color.Neutral_Colors_Divided'))


            Column(){
              Text('异常描述')
                .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
              Stack({alignContent:Alignment.BottomEnd}){
                TextArea({placeholder:'请输入异常描述',text:this.textinp})
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
            }
            .alignItems(HorizontalAlign.Center)
            .padding({left:20 , top:10 , bottom:10,right:20})
            .width('95%')

          }
          .margin({top:20 , bottom:20})
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius(10)

          Column(){
            Text('上传照片(最多6张)')
            Text(){
              ForEach(this.imgs,
                (item:UrlImg,index:number)=>{
                  ContainerSpan(){
                    ImageSpan(item.url)
                      .imagespando()
                      .margin({bottom:10})
                      .onClick(()=>{
                        this.imgpath=item.url
                        this.dialogControllerImg.open()
                      })
                    ImageSpan($r('app.media.ic_btn_delete'))
                      .width(20)
                      .height(20)
                      .margin({bottom:10})
                      .onClick(()=>{
                        this.delbyHuoImg(index)
                      })
                  }
                })
            }
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
            .onClick(()=>{
              if (this.imgs.length<6) {
                this.GetPermissonThenUploadGetUrl()
              }
            })
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
          .padding(20)
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
      }
      .align(Alignment.Top)
      .scrollBar(BarState.Off)
      .height('80%')
      // Column(){
      //   // Row(){
      //   //   this.InRow('异常时间',this.nowdate)
      //   // }
      //   // .onClick(()=>{
      //   //   this.openDatetick()
      //   // })
      //
      //   Row(){
      //     Text('异常时间')
      //       .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      //     Row({space:5}){
      //       Text(this.nowdate)
      //         .fontColor($r('app.color.Neutral_Colors_MainFont'))
      //       Image($r('app.media.ic_btn_more'))
      //         .width(35)
      //         .height(35)
      //     }
      //   }
      //   .onClick(()=>{
      //     this.openDatetick()
      //   })
      //   .padding({left:20 , top:10 , bottom:10})
      //   .height(40)
      //   .width('95%')
      //   .justifyContent(FlexAlign.SpaceBetween)
      //
      //
      //
      //   Line()
      //     .width('95%')
      //     .height(1)
      //     .backgroundColor($r('app.color.Neutral_Colors_Divided'))
      //
      //   this.InRow('上报位置',this.Postation)
      //
      //
      //   Line()
      //     .width('95%')
      //     .height(1)
      //     .backgroundColor($r('app.color.Neutral_Colors_Divided'))
      //
      //
      //   Row(){
      //     Text('异常类型')
      //       .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      //     Row({space:5}){
      //       Text(this.ErrorRype)
      //         .fontColor($r('app.color.Neutral_Colors_MainFont'))
      //       Image($r('app.media.ic_btn_more'))
      //         .width(35)
      //         .height(35)
      //     }
      //   }
      //   .padding({left:20 , top:10 , bottom:10})
      //   .height(40)
      //   .width('95%')
      //   .justifyContent(FlexAlign.SpaceBetween)
      //   .onClick(()=>{
      //     this.dialogController.open()
      //   })
      //   Line()
      //     .width('95%')
      //     .height(1)
      //     .backgroundColor($r('app.color.Neutral_Colors_Divided'))
      //
      //
      //   Column(){
      //     Text('异常描述')
      //       .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      //     Stack({alignContent:Alignment.BottomEnd}){
      //       TextArea({placeholder:'请输入异常描述',text:this.textinp})
      //         .width('100%')
      //         .height(130)
      //         .onChange((value)=>{
      //           this.textinp=value
      //         })
      //         .align(Alignment.TopStart)
      //         .maxLines(3)
      //         .maxLength(50)
      //         .border({
      //           radius:10
      //         })
      //       Text(this.textinp.length+'/50')
      //         .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      //         .fontSize($r('app.string.TextTwoFontSize'))
      //     }
      //   }
      //   .padding({left:20 , top:10 , bottom:10})
      //   .width('95%')
      //
      // }
      // .margin({top:20 , bottom:20})
      // .width('95%')
      // .backgroundColor(Color.White)
      // .borderRadius(10)
      //
      // Column(){
      //   Text('上传照片(最多6张)')
      //   Text(){
      //     ForEach(this.imgs,
      //       (item:UrlImg,index:number)=>{
      //         ContainerSpan(){
      //           ImageSpan(item.url)
      //             .imagespando()
      //             .margin({bottom:10})
      //             .onClick(()=>{
      //               this.imgpath=item.url
      //               this.dialogControllerImg.open()
      //             })
      //           ImageSpan($r('app.media.ic_btn_delete'))
      //             .width(20)
      //             .height(20)
      //             .margin({bottom:10})
      //             .onClick(()=>{
      //               this.delbyHuoImg(index)
      //             })
      //         }
      //       })
      //   }
      //   Column(){
      //     Image($r('app.media.ic_add_img'))
      //       .imagedo()
      //   }
      //   .justifyContent(FlexAlign.Center)
      //   .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
      //   .width(100)
      //   .height(100)
      //   .onClick(()=>{
      //     if (this.imgs.length<6) {
      //       this.GetPermissonThenUploadGetUrl()
      //     }
      //   })
      // }
      // .alignItems(HorizontalAlign.Start)
      // .justifyContent(FlexAlign.Start)
      // .padding(20)
      // .width('95%')
      // .backgroundColor(Color.White)
      // .borderRadius(10)

      Row(){
        Button('提交')
          .width('80%')
          .height(60)
          .backgroundColor((this.Postation!=''&&this.nowdate!=''&&this.ErrorRype!=''&&this.textinp!=''&&this.imgs.length>0)?$r('app.color.Brand_Color'):'#f9dcd8')
          .onClick(()=>{
            if (this.Postation!=''
              &&this.nowdate!=''
              &&this.ErrorRype!=''
              &&this.textinp!=''
              &&this.imgs.length>0) {
              let c:ErrorModel=new ErrorModel(this.transportTaskId,this.nowdate,this.Postation,this.ErrorRype,this.textinp,this.imgs)
              this.ErrorMessageDo=c
              ErrorSub(this.ErrorMessageDo)
                .then((value)=>{
                  if (value) {
                    promptAction.showToast({message:'上报成功'})
                  }else {
                    promptAction.showToast({message:'系统异常'})
                  }
                  router.back()
                })
            }
          })
      }
      .padding(10)
      .margin({top:20})
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .width('100%')
    }
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
    .height('100%')
    .width('100%')
  }
}
@Extend(ImageSpan)
function  imagespando(){
  .width(80)
  .height(80)

}

@Extend(Image)
function  imagedo(){
  .width(40)
  .height(40)
}
export  function gettime(now:Date){

  const year = now.getFullYear(); // 获取年份
  const month = (now.getMonth() + 1).toString().padStart(2, '0'); // 获取月份，月份从0开始计数，所以加1，转化为两位数
  const day = now.getDate().toString().padStart(2, '0'); // 获取日，转化为两位数
  const hours = now.getHours().toString().padStart(2, '0'); // 获取小时，转化为两位数
  const minutes = now.getMinutes().toString().padStart(2, '0'); // 获取分钟，转化为两位数
  const seconds = now.getSeconds().toString().padStart(2, '0'); // 获取秒，转化为两位数

  const formattedDateTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  return formattedDateTime
}