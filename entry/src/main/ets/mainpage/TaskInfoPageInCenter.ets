import { errorintask, TaskDatil, UrlImg } from '../model/TaskDo'
import { common, Permissions } from '@kit.AbilityKit'
import { checkPermissions } from '../utils/PermissionUtil'
import { chossleImage, uploadImg } from '../utils/PhotoUtil'
import { url } from '@kit.ArkTS'
import { HuoModer, HuoTwoModel } from '../model/HuoWuDo'
import { imgialog } from './IndexPageStruct/ImgDia'
import { router } from '@kit.ArkUI'

@Component
export struct carmessage{
  @Prop ifshow:boolean=false
  @Prop task:TaskDatil|null
  @Builder
  InRow(title:string,message:string){
    Row(){
      Text(title)
        .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
      Text(message)
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
    }
    .padding({left:20})
    .height(40)
    .width('95%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
  build() {
    Column(){
      Row(){
        Text('车辆司机信息')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
        Image(this.ifshow?$r('app.media.ic_btn_cut'):$r('app.media.ic_btn_add'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))
          .onClick(()=>{
            this.ifshow=!this.ifshow
          })
      }
      .borderRadius(10)
      .padding({ left:20,top:10,bottom:10,right:20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      if (this.ifshow){
        this.InRow('车牌号',this.task?.licensePlate as string)
        this.InRow('司机姓名',this.task?.driverName as string)
      }
    }
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
}

@Component
export struct luxian{
  @Prop ifshow:boolean=false
  @Prop task:TaskDatil|null
  @Prop index:number=1
    build() {
      Column(){
        Row(){
          Text('运输路线')
            .fontColor($r('app.color.Neutral_Colors_MainFont'))
            .fontSize($r('app.string.TitleFontSize'))
            .fontWeight(FontWeight.Bold)
          Image(this.ifshow?$r('app.media.ic_btn_cut'):$r('app.media.ic_btn_add'))
            .width(25)
            .height(25)
            .fillColor($r('app.color.Brand_Color'))
            .onClick(()=>{
              this.ifshow=!this.ifshow
            })
        }
        .borderRadius(10)
        .padding({ left:20,top:10,bottom:10,right:20 })
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        if (this.ifshow){
          Row({space:20}){
            Column(){
              Text(this.task?.startProvince)
                .fontColor($r('app.color.Neutral_Colors_MainFont'))
                .fontSize($r('app.string.TitleFontSize'))
                .fontWeight(FontWeight.Bold)
              Text(this.task?.startCity)
                .fontSize($r('app.string.TextOneFontSize'))
            }
            .alignItems(HorizontalAlign.Center)
            Image($r('app.media.ic_right_arrow'))
              .width(50)
              .height(50)
            Column(){
              Text(this.task?.endProvince)
                .fontColor($r('app.color.Neutral_Colors_MainFont'))
                .fontSize($r('app.string.TitleFontSize'))
                .fontWeight(FontWeight.Bold)
              Text(this.task?.endCity)
                .fontSize($r('app.string.TextOneFontSize'))
            }
            .alignItems(HorizontalAlign.Center)
          if(this.index==2){
            // 导航 开启地图
            Text('导航')
              .width(70)
              .height(70)
              .borderRadius(50)
              .borderWidth(1)
              .borderColor(Color.Black)
              .textAlign(TextAlign.Center)
              .onClick(()=>{
                router.pushUrl({
                  url:'mainpage/DaoHangPage',
                  params:{
                    task:this.task
                  }
                })
              })
          }




          }
          .padding({bottom:10})
          .alignItems(VerticalAlign.Center)
        }
      }
      .width('95%')
      .backgroundColor(Color.White)
      .borderRadius(10)
    }
}

@Component
export struct wupin{
  @Prop ifshow:boolean=false
  @Prop task:TaskDatil|null
  build() {
    Column(){
      Row(){
        Text('物品信息')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
        Image(this.ifshow?$r('app.media.ic_btn_cut'):$r('app.media.ic_btn_add'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))
          .onClick(()=>{
            this.ifshow=!this.ifshow
          })
      }
      .borderRadius(10)
      .padding({ left:20,top:10,bottom:10,right:20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      if (this.ifshow){

      }
    }
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
}

const permissions: Array<Permissions> = ['ohos.permission.READ_MEDIA'];
const context = getContext(this) as common.UIAbilityContext
@Component
export struct tihuo{
  @Prop ifshow:boolean=false
  @Prop task:TaskDatil|null=null
  @State url:string=''
  @Link Huo:HuoModer
  @Link ifcando:boolean
  @State @Watch('ifdonext')HuoImg:Array<UrlImg>=[]
  @State @Watch('ifdonext')HuoImgTwo:Array<UrlImg>=[]
  @State imgpath:string=''
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

  ifdonext(){
    if (this.HuoImg.length > 0 && this.HuoImgTwo.length > 0) {
      this.ifcando=true
    }else {
      this.ifcando=false
    }
  }
  GetPermissonThenUploadGetUrl(){
    // 获取权限
    checkPermissions(permissions,context)
      .then((value)=>{
        chossleImage()
          .then((value)=>{
            for (let i = 0; i < value.length; i++) {
              if (this.task?.deliverPictureList == null) {
                let c:Array<UrlImg>=[]
                c.push(new UrlImg(value[i]))
                // bug
                // this.task?.deliverPictureList as Array<UrlImg>=c
                let a=Date.now().toString()
                uploadImg(value[i],a,context)
                  .then((value)=>{
                    let c=new UrlImg(value)
                    this.HuoImg.push(c)
                    this.Huo.cargoPickUpPictureList=this.HuoImg
                    console.info(`url=====${value}`)
                  })
              }
            }
          })
          .catch((error:Error)=>{
            console.info(`errorin this :${error}`)
          })
      })
  }
  GetPermissonThenUploadGetUrlTwo(){
    // 获取权限
    checkPermissions(permissions,context)
      .then((value)=>{
        chossleImage()
          .then((value)=>{
            for (let i = 0; i < value.length; i++) {
              if (this.task?.deliverPictureList == null) {
                let c:Array<UrlImg>=[]
                c.push(new UrlImg(value[i]))
                // bug
                // this.task?.deliverPictureList as Array<UrlImg>=c
                let a=Date.now().toString()
                uploadImg(value[i],a,context)
                  .then((value)=>{
                    let c=new UrlImg(value)
                    this.HuoImgTwo.push(c)
                    this.Huo.cargoPictureList=this.HuoImgTwo
                    console.info(`url=====${value}`)
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
    this.HuoImg.splice(index,1)
    this.Huo.cargoPickUpPictureList=this.HuoImg
    console.info(`Huoimg===${JSON.stringify(this.HuoImg)}`)
  }
  delbyHuoImgTwo(index:number){
    this.HuoImgTwo.splice(index,1)
    this.Huo.cargoPictureList=this.HuoImgTwo
  }
  build() {
    Column(){
      Row(){
        Text('提货信息')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
        Image(this.ifshow?$r('app.media.ic_btn_cut'):$r('app.media.ic_btn_add'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))
          .onClick(()=>{
            this.ifshow=!this.ifshow
          })
      }
      .borderRadius(10)
      .padding({ left:20,top:10,bottom:10,right:20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      if (this.ifshow){
        Column({space:20}){
          Text('请拍照上传回单凭证')
            .fontSize($r('app.string.TextTwoFontSize'))
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          if (this.HuoImg.length>0)   {
              Text(){
                ForEach(this.HuoImg,
                  (item:UrlImg,index:number)=>{
                  ContainerSpan(){
                    ImageSpan(item.url)
                      .imagespando()
                      .margin({left:20})
                      .onClick(()=>{
                        this.imgpath=item.url
                        this.dialogController.open()
                      })
                    ImageSpan($r('app.media.ic_btn_delete'))
                      .width(20)
                      .height(20)
                      .onClick(()=>{
                        this.delbyHuoImg(index)
                      })
                  }
              })
              }
              .width('95%')
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
            .onClick(()=>{
             this.GetPermissonThenUploadGetUrl()
            })
          }else {
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .onClick(()=>{
              this.GetPermissonThenUploadGetUrl()
            })
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({left:20,bottom:20})


        Column({space:20}){
          Text('请拍照上传货品照片')
            .fontSize($r('app.string.TextTwoFontSize'))
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          if (this.HuoImgTwo.length>0)   {
            Text(){
              ForEach(this.HuoImgTwo,
                (item:UrlImg,index:number)=>{
                  ContainerSpan(){
                    ImageSpan(item.url)
                      .imagespando()
                      .margin({left:20})
                      .onClick(()=>{
                        this.imgpath=item.url
                        this.dialogController.open()
                      })
                    ImageSpan($r('app.media.ic_btn_delete'))
                      .width(20)
                      .height(20)
                      .onClick(()=>{
                        this.delbyHuoImgTwo(index)
                      })
                  }
                })
            }
            .width('95%')
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
            .onClick(()=>{
              this.GetPermissonThenUploadGetUrlTwo()
            })
          }else {
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .onClick(()=>{
              this.GetPermissonThenUploadGetUrlTwo()
            })
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({left:20,bottom:20})


      }
    }
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
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


@Component
export struct tihuoInTwo{
  @Prop ifshow:boolean=false
  @Prop task:TaskDatil|null=null
  @State url:string=''
  @Link Huo:HuoTwoModel
  @Link ifcando:boolean
  @State @Watch('ifdonext')HuoImg:Array<UrlImg>=[]
  @State @Watch('ifdonext')HuoImgTwo:Array<UrlImg>=[]
  @State imgpath:string=''
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

  ifdonext(){
    if (this.HuoImg.length > 0 && this.HuoImgTwo.length > 0) {
      this.ifcando=true
    }else {
      this.ifcando=false
    }
  }
  GetPermissonThenUploadGetUrl(){
    // 获取权限
    checkPermissions(permissions,context)
      .then((value)=>{
        chossleImage()
          .then((value)=>{
            for (let i = 0; i < value.length; i++) {
              if (this.task?.deliverPictureList == null) {
                let c:Array<UrlImg>=[]
                c.push(new UrlImg(value[i]))
                // bug
                // this.task?.deliverPictureList as Array<UrlImg>=c
                let a=Date.now().toString()
                uploadImg(value[i],a,context)
                  .then((value)=>{
                    let c=new UrlImg(value)
                    this.HuoImg.push(c)
                    this.Huo.certificatePictureList=this.HuoImg
                    console.info(`url=====${value}`)
                  })
              }
            }
          })
          .catch((error:Error)=>{
            console.info(`errorin this :${error}`)
          })
      })
  }
  GetPermissonThenUploadGetUrlTwo(){
    // 获取权限
    checkPermissions(permissions,context)
      .then((value)=>{
        chossleImage()
          .then((value)=>{
            for (let i = 0; i < value.length; i++) {
              if (this.task?.deliverPictureList == null) {
                let c:Array<UrlImg>=[]
                c.push(new UrlImg(value[i]))
                // bug
                // this.task?.deliverPictureList as Array<UrlImg>=c
                let a=Date.now().toString()
                uploadImg(value[i],a,context)
                  .then((value)=>{
                    let c=new UrlImg(value)
                    this.HuoImgTwo.push(c)
                    this.Huo.deliverPictureList=this.HuoImgTwo
                    console.info(`url=====${value}`)
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
    this.HuoImg.splice(index,1)
    this.Huo.certificatePictureList=this.HuoImg
    console.info(`Huoimg===${JSON.stringify(this.HuoImg)}`)
  }
  delbyHuoImgTwo(index:number){
    this.HuoImgTwo.splice(index,1)
    this.Huo.deliverPictureList=this.HuoImgTwo
  }
  build() {
    Column(){
      Row(){
        Text('提货信息')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
        Image(this.ifshow?$r('app.media.ic_btn_cut'):$r('app.media.ic_btn_add'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))
          .onClick(()=>{
            this.ifshow=!this.ifshow
          })
      }
      .borderRadius(10)
      .padding({ left:20,top:10,bottom:10,right:20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      if (this.ifshow){
        Column({space:20}){
          Text('请拍照上传回单凭证')
            .fontSize($r('app.string.TextTwoFontSize'))
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          if (this.HuoImg.length>0)   {
            Text(){
              ForEach(this.HuoImg,
                (item:UrlImg,index:number)=>{
                  ContainerSpan(){
                    ImageSpan(item.url)
                      .imagespando()
                      .margin({left:20})
                      .onClick(()=>{
                        this.imgpath=item.url
                        this.dialogController.open()
                      })
                    ImageSpan($r('app.media.ic_btn_delete'))
                      .width(20)
                      .height(20)
                      .onClick(()=>{
                        this.delbyHuoImg(index)
                      })
                  }
                  // ImageSpan(item.url)
                  //   .imagespando()
                  //   .margin({left:20})
                  //   .onClick(()=>{
                  //     this.imgpath=item.url
                  //     this.dialogController.open()
                  //   })
                })
            }
            .width('95%')
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
            .onClick(()=>{
              this.GetPermissonThenUploadGetUrl()
            })
          }else {
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .onClick(()=>{
              this.GetPermissonThenUploadGetUrl()
            })
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({left:20,bottom:20})


        Column({space:20}){
          Text('请拍照上传货品照片')
            .fontSize($r('app.string.TextTwoFontSize'))
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          if (this.HuoImgTwo.length>0)   {
            Text(){
              ForEach(this.HuoImgTwo,
                (item:UrlImg,index:number)=>{
                  ContainerSpan(){
                    ImageSpan(item.url)
                      .imagespando()
                      .margin({left:20})
                      .onClick(()=>{
                        this.imgpath=item.url
                        this.dialogController.open()
                      })
                    ImageSpan($r('app.media.ic_btn_delete'))
                      .width(20)
                      .height(20)
                      .onClick(()=>{
                        this.delbyHuoImgTwo(index)
                      })
                  }
                })
            }
            .width('95%')
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
            .onClick(()=>{
              this.GetPermissonThenUploadGetUrlTwo()
            })
          }else {
            Column(){
              Image($r('app.media.ic_add_img'))
                .imagedo()
            }
            .onClick(()=>{
              this.GetPermissonThenUploadGetUrlTwo()
            })
            .justifyContent(FlexAlign.Center)
            .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
            .width(100)
            .height(100)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({left:20,bottom:20})


      }
    }
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
}

@Component
export struct TiHuoInEnd{
  @Prop ifshow:boolean=false
  @Prop task:TaskDatil
  @State url:string=''
  @State imgpath:string=''
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


  build() {
    Column(){
      Row(){
        Text('提货信息')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
        Image(this.ifshow?$r('app.media.ic_btn_cut'):$r('app.media.ic_btn_add'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))
          .onClick(()=>{
            this.ifshow=!this.ifshow
          })
      }
      .borderRadius(10)
      .padding({ left:20,top:10,bottom:10,right:20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      if (this.ifshow){
        Column({space:20}){
          Text('回单凭证')
            .fontSize($r('app.string.TextTwoFontSize'))
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            Text(){
              ForEach(this.task.cargoPickUpPictureList,
                (item:UrlImg,index:number)=>{
                  ContainerSpan(){
                    ImageSpan(item.url)
                      .imagespando()
                      .margin({left:20})
                      .onClick(()=>{
                        this.imgpath=item.url
                        this.dialogController.open()
                      })
                  }
                })
            }
            .width('95%')
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({left:20,bottom:20})


        Column({space:20}){
          Text('提货照片')
            .fontSize($r('app.string.TextTwoFontSize'))
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            Text(){
              ForEach(this.task.cargoPictureList,
                (item:UrlImg,index:number)=>{
                  ContainerSpan(){
                    ImageSpan(item.url)
                      .imagespando()
                      .margin({left:20})
                      .onClick(()=>{
                        this.imgpath=item.url
                        this.dialogController.open()
                      })
                  }
                })
            }
            .width('95%')


        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding({left:20,bottom:20})


      }
    }
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
}

@Component
export struct errorend{
  @Prop ifshow:boolean=false
  @Prop exceptionList:Array<errorintask>=[]
  @Builder
  Inrow(title:string,value:string){
    Row({space:20}){
      Text(title)
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
      Text(value)
        .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
    }
    .justifyContent(FlexAlign.Start)
    .width('95%')
    .padding(10)
  }
  build() {
    Column(){
      Row(){
        Text('提货信息')
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
        Image(this.ifshow?$r('app.media.ic_btn_cut'):$r('app.media.ic_btn_add'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))
          .onClick(()=>{
            this.ifshow=!this.ifshow
          })
      }
      .borderRadius(10)
      .padding({ left:20,top:10,bottom:10,right:20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      if (this.ifshow){
       ForEach(this.exceptionList,
         (item:errorintask)=>{
            this.Inrow('上报时间',item.exceptionTime)
           Stack({alignContent:Alignment.End}){
             this.Inrow('异常类型',item.exceptionType)
             Image($r('app.media.ic_btn_more'))
               .width(30)
               .height(30)

           }
            this.Inrow('处理结果',item.handleResult)
         })
      }
    }
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)

  }
}