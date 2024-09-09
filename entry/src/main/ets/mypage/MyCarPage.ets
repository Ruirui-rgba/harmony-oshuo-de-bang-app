import { GetUserCar } from '../api/UserApi'
import { UserCar } from '../model/UserDo'
import { text } from '@kit.ArkGraphics2D'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct MyCarPage {
  @State carinfo:UserCar=new UserCar('','','',[],'','')

  @Builder
  InTop(){
    Column({space:10}){
      Stack({alignContent:Alignment.Start}){
        Row(){
          Text('车辆信息')
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
  OnRow(title:string,value:string){
    Row(){
      Text(title)
        .textdo()
      Text(value)
        .textvalue()
    }
    .width('95%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
  aboutToAppear(): void {
    GetUserCar()
      .then((value)=>{
        this.carinfo=value
      })
  }
  build() {
    Column({space:20}) {
      this.InTop()
      Image(this.carinfo.pictureList.length==0?$r('app.media.ic_avatar_driver'):this.carinfo.pictureList[0].url)
        .width('95%')
        .height('30%')
        .borderRadius(10)
      Column(){
        Row(){
          Text('车辆编号')
            .textdo()
          Text(this.carinfo.id)
            .textvalue()
        }
        .height(40)
        .width('95%')
        Row(){
          Text('车辆号牌')
            .textdo()
          Text(this.carinfo.licensePlate)
            .textvalue()
        }
        .height(40)
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)
        Row(){
          Text('车型')
            .textdo()
          Text(this.carinfo.truckType)
            .textvalue()
        }
        .height(40)
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)
        Row(){
          Text('所属机构')
            .textdo()
          Text(this.carinfo.currentOrganName)
            .textvalue()
        }
        .height(40)
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)
        Row(){
          Text('载重')
            .textdo()
          Text(this.carinfo.allowableLoad)
            .textvalue()
        }
        .height(40)
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)

      }
      .backgroundColor(Color.White)
      .padding(20)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}

@Extend(Text)
function  textdo(){
  .fontSize($r('app.string.TitleFontSize'))
  .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
}
@Extend(Text)
function  textvalue(){
  .fontSize($r('app.string.TitleFontSize'))
}