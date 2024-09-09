import { router } from '@kit.ArkUI'
import { TaskDatil } from '../model/TaskDo'

class pageinfo{
  task:TaskDatil=new TaskDatil()
}

@Entry
@Component
struct DaoHangPage {
  @State task:TaskDatil=new TaskDatil()
  aboutToAppear(): void {
    this.task= (router.getParams() as pageinfo).task
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
      Text('导航')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  @Builder
  InCenter(){
    Column(){
      Column(){
        Row({space:10}){
          Column(){
            Text('起')
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .fontSize($r('app.string.TextThreeFontSize'))
              .width(20)
              .height(20)
              .borderRadius(50)
              .backgroundColor($r('app.color.Neutral_Colors_MainFont'))
            Text('|')
              .fontSize($r('app.string.TextThreeFontSize'))
              .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            Text('|')
              .fontSize($r('app.string.TextThreeFontSize'))
              .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            Text('|')
              .fontSize($r('app.string.TextThreeFontSize'))
              .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          }
          .alignItems(HorizontalAlign.Center)
          Text(this.task.startAddress)
            .textAlign(TextAlign.Start)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('80%')
            .maxLines(2)
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        }
        .alignItems(VerticalAlign.Top)
        Row({space:10}){
          Text('止')
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .fontSize($r('app.string.TextThreeFontSize'))
            .width(20)
            .height(20)
            .borderRadius(50)
            .backgroundColor($r('app.color.Auxiliary_Color_Error'))
          Text(this.task.endAddress)
            .textAlign(TextAlign.Start)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('80%')
            .maxLines(2)
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        }
      }
      .margin({
        top:20
      })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      top:10,
      left:20,
      bottom:20
    })
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
  build() {
    Column() {
      this.Intop()
      Stack({alignContent:Alignment.Top}){

        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Yellow)

      Column(){
          this.InCenter()
      }
      .margin({top:20})

      }
      .width('100%')
      .height('80%')
      Row(){
        // 开启地图导航


        Button('开始导航')
          .width('70%')
          .height(60)
          .backgroundColor(Color.Red)

      }
      .padding({top:20})
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .backgroundColor(Color.White)
    }
    .height('100%')
    .width('100%')
  }
}