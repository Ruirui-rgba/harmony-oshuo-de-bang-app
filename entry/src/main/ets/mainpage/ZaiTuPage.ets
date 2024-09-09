import { getJobId, TasKDataModel, TaskDatil } from '../model/TaskDo';
import { promptAction, router } from '@kit.ArkUI';
import { GetOneTaskListInfo } from '../api/LoginDoApi';
import { carmessage, luxian, tihuo, tihuoInTwo, wupin } from './TaskInfoPageInCenter';
import { PhoneDiag } from './PhoneDiag';
import { HuoModer, HuoTwoModel } from '../model/HuoWuDo';
import { JiaoFu, SubMit } from '../api/HuoWuApi';
import { emitter } from '@kit.BasicServicesKit';
@Entry
@Component
struct ZaiTuPage {
  @State message: string = 'Hello World';
  @State task:TaskDatil|null=null
  @State ifcando:boolean=false
  @State Huo:HuoTwoModel=new HuoTwoModel([],'',[])
  dialogController:CustomDialogController=new CustomDialogController({
    builder:PhoneDiag({
      phonenumber:this.task?.startHandoverPhone
    }),
    customStyle:true,
    alignment:DialogAlignment.Bottom
  })
  aboutToAppear(): void {
    let taskid=router.getParams() as getJobId
    console.info(`taskid:===${taskid.jobId}`)
    GetOneTaskListInfo(taskid.jobId)
      .then((value)=>{
        this.task=value
      })
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
      Text('任务详情')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  @Builder
  CenterBegintoEnd(){
    Column(){
      Row(){
        Text('基本信息')
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
        Image($r('app.media.ic_btn_add'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))
      }
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
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
          Text(this.task?.startAddress)
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
          Text(this.task?.endAddress)
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
      Line()
        .width('95%')
        .height(1)
        .backgroundColor($r('app.color.Neutral_Colors_Divided'))
        .margin({top:20})
      Row(){
        Text('任务编号')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        Text(this.task?.transportTaskId)
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
      }
      .height(40)
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row(){
        Text('联系人')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        Text(this.task?.startHandoverName)
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
      }
      .height(40)
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row(){
        Text('联系电话')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        Row({space:5}){
          Text(this.task?.startHandoverPhone)
            .fontColor($r('app.color.Neutral_Colors_MainFont'))
          Image($r('app.media.ic_phone'))
            .width(25)
            .height(25)
        }
        .onClick(()=>{
          this.dialogController.open()
        })
      }
      .height(40)
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
      //  bug  预计送达时间其实不为空  string 类型
      Row(){
        Text('提货时间')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        Text(this.task?.planDepartureTime)
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
      }
      .height(40)
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row(){
        Text('预计送达时间')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        Text(this.task?.planArrivalTime)
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
      }
      .height(40)
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
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
  @Builder
  bottonIn(title:string){
    Column(){
      Row(){
        Text(title)
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
          .fontSize($r('app.string.TitleFontSize'))
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.ic_add_img'))
          .width(25)
          .height(25)
          .fillColor($r('app.color.Brand_Color'))

      }
      .borderRadius(10)
      .padding({ left:20,top:10,bottom:10,right:20 })
      .justifyContent(FlexAlign.SpaceBetween)
      .width('95%')
      .backgroundColor(Color.White)
    }
    .width('100%')
  }
  build() {
    Column({space:20}) {
      this.Intop()
      List({space:20}){
        this.CenterBegintoEnd()
        carmessage({
          ifshow:false,
          task:this.task
        })
        luxian({
          ifshow:false,
          task:this.task,
          index:2
        })
        wupin({
          ifshow:false,
          task:this.task
        })
        tihuoInTwo({
          ifshow:false,
          task:this.task,
          Huo:this.Huo,
          ifcando:this.ifcando
        })
      }
      .height('80%')
      .alignListItem(ListItemAlign.Center)
      .scrollBar(BarState.Off)

      Row(){
        Button('上报异常')
          .backgroundColor(Color.Black)
          .fontColor('##747474')
          .width('30%')
          .height(40)
          .onClick(()=>{
            if (this.task != null) {
              router.pushUrl({
                url:'mainpage/ErrorMessage',
                params:{
                  transportTaskId:this.task?.transportTaskId
                }
              })
            }
          })
        Button('交付')
          .backgroundColor(this.ifcando?$r('app.color.Brand_Color'):'#f9dcd8')
          .fontColor(Color.White)
          .width('45%')
          .height(40)
          .onClick(()=>{
            if (this.ifcando) {
              this.Huo.id=this.task?.id as string
              JiaoFu(this.Huo)
                .then((value)=>{
                  if (value) {
                    promptAction.showToast({
                      message:'交付成功'
                    })
                    router.back()
                    emitter.emit({eventId:2})
                  }else {
                    promptAction.showToast({
                      message:'交付失败'
                    })
                    router.back()
                    emitter.emit({eventId:2})
                  }
                })

            }
          })
      }
      .padding(20)
      .width('100%')
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
    .height('100%')
    .width('100%')
  }
}