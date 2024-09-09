import { TasKDataModel } from '../../model/TaskDo'
import { promptAction, router } from '@kit.ArkUI'
import { GetAllTaskList, GetTaskByTime } from '../../api/LoginDoApi'
import { GetYMD } from './GetYMD'

@Component
export struct  tabonepage{
  @Prop TasKDatas:Array<TasKDataModel>|null=[]
  @Prop page:number
  @Prop pages:number
  @State nowtopindex:number=1
  @State inpvalue:string|null=null
  @State isRefreshing: boolean = false
  @State begintime:string|null=null
  @State endtime:string|null=null
  dialogController:CustomDialogController=new CustomDialogController({
    builder:GetYMD({
      endtime:this.begintime
    }),
    customStyle:true,
    alignment:DialogAlignment.Bottom
  })
  dialogControllerT:CustomDialogController=new CustomDialogController({
    builder:GetYMD({
      endtime:this.endtime
    }),
    customStyle:true,
    alignment:DialogAlignment.Bottom
  })
  GetTaskList(status:string){
      GetAllTaskList(this.page.toString(),'10',status)
        .then((value)=>{
          if (value.items.length>=1) {
            for (const element of value.items) {
              this.TasKDatas?.push(element)
            }
          }
        })
  }

  GetTaskBysearch(){
    GetTaskByTime('1','10',this.nowtopindex.toString(),this.begintime,this.endtime,this.inpvalue)
      .then((value)=>{
        console.info(`=====${JSON.stringify(value)}`)
        this.page=value.page
        this.pages=value.pages
        this.TasKDatas=value.items
      })
  }
  @Builder
  InOneTask(task:TasKDataModel){
    Column(){
      Row(){
        Text('任务编号:'+task.transportTaskId)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .width('50%')
          .fontWeight(FontWeight.Bold)
          .fontSize($r('app.string.TitleFontSize'))
          .fontColor($r('app.color.Neutral_Colors_MainFont'))
      }
      .width('100%')
      // 起始地到目的地
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
          Text(task.startAddress)
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
          Text(task.endAddress)
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
        Column(){
          Text('提货时间')
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          // 计划到达时间  bug  无提货时间
          Text(task.planArrivalTime)
        }
        .alignItems(HorizontalAlign.Start)
        if (this.nowtopindex==1){
          Button('提货')
            .backgroundColor(task.enablePickUp?$r('app.color.Brand_Color'):'#f9dcd8')
            .width(70)
            .height(30)
            .fontSize($r('app.string.TextTwoFontSize'))
        }
        if (this.nowtopindex==2){
          Button((task.status as number)==1?'待提货':
                  // 在途
                  (task.status as number)==2?'在途':
                    // 改派
                    (task.status as number)==3?'改派':
                      // 已交付
                      (task.status as number)==4?'回车登记':
                        // 已作废
                        (task.status as number)==5?'已作废':'未知'
                )
            .backgroundColor($r('app.color.Brand_Color'))
            .width(80)
            .height(30)
            .fontSize((task.status as number)==4?10:$r('app.string.TextTwoFontSize'))
        }
      }
      .margin({top:20})
      .width('95%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding({
      top:10,
      left:20,
      right:10,
      bottom:20
    })
    .alignItems(HorizontalAlign.Start)
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({
      top:20
    })
    .onClick(()=>{
      if (this.nowtopindex==1){
        if(task.enablePickUp){
          router.pushUrl({
            url:'mainpage/TaskInfoPage',
            params:{
              jobId:task.id
            }
          })
        }else {
          promptAction.showToast({
            message:'暂不可提货'
          })
        }
      }
      if (this.nowtopindex==2){


        if ((task.status as number) == 4) {
          // 回车登记页面
          router.pushUrl({
            url:'mainpage/HuiChePage',
            params:{
              jobId:task.transportTaskId,
              gotime:task.actualDepartureTime
            }
          })
        }
        if ((task.status as number) == 2) {
          //   在途页面  ----
          router.pushUrl({
            url:'mainpage/ZaiTuPage',
            params:{
              jobId:task.id
            }
          })
        }
      }

      if (this.nowtopindex==6){
        router.pushUrl({
          url:'mainpage/TaskEndPage',
          params:{
            jobId:task.id
          }
        })
      }
    })
  }
  @Builder
  intopsmallmodel(title:string,num:number){
    Column(){
      Text(title)
        .fontSize($r('app.string.TextOneFontSize'))
        .fontWeight(FontWeight.Bold)
        .fontColor(num===this.nowtopindex?$r('app.color.Neutral_Colors_MainFont'):$r('app.color.Neutral_Colors_SecondaryText'))
      if (num===this.nowtopindex){
        Line()
          .height(4)
          .width(24)
          .borderRadius(4)
          .backgroundColor($r('app.color.Auxiliary_Color_Error'))
          .margin({top:4})
      }

    }
    .onClick(()=>{
      if (num!=this.nowtopindex){
        this.nowtopindex=num
        this.GetTaskListT()
      }
    })

  }
  GetTaskListT(){
    GetAllTaskList('1','10', this.nowtopindex.toString())
      .then((value)=>{
        console.info(`=====${JSON.stringify(value)}`)
        this.page=value.page
        this.pages=value.pages
        this.TasKDatas=value.items
      })
  }
  @Builder
  intop(){
    Row({space:20}){
      this.intopsmallmodel('待提货',1)
      this.intopsmallmodel('在途',2)
      this.intopsmallmodel('已完成',6)
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .padding({
      top:10,
      left:30
    })
    .height('7%')
    .backgroundColor(Color.White)
  }
  build() {
    Column(){
      this.intop()
      if (this.nowtopindex==6){
        Column(){
          Search({placeholder:'请输入任务编号'})
            .height(30)
            .width('95%')
            .searchButton('搜索')
            .onSubmit((value: string) => {
              this.inpvalue = value
            })
            .onChange((value: string) => {
              this.inpvalue = value
            })

          Row(){
            Text(this.begintime==null?'开始时间':this.begintime)
              .textdo()
              .onClick(()=>{
                this.dialogController.open()
              })
            Text('至')
              .fontColor(Color.Black)
            Text(this.endtime==null?'结束时间':this.endtime)
              .textdo()
              .onClick(()=>{
                this.dialogControllerT.open()
              })
            Button('筛选')
              .height(30)
              .backgroundColor(this.begintime!=null&&this.endtime!=null?$r('app.color.Brand_Color'):'#f9dcd8')
              .fontColor(Color.White)
              .onClick(()=>{
                if (this.begintime!=null&&this.endtime!=null) {
                  this.GetTaskBysearch()
                }
              })
          }
          .width('95%')
          .padding(10)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .height('12%')
        .width('100%')
      }
      if (this.TasKDatas?.length as number>=1){

        Refresh({refreshing: $$this.isRefreshing}){
          Scroll(){
            List(){
              ForEach(this.TasKDatas,
                (item:TasKDataModel)=>{
                  ListItem(){
                    this.InOneTask(item)
                  }
                })
            }
            .scrollBar(BarState.Off)
            .alignListItem(ListItemAlign.Center)
          }
          .align(Alignment.Top)
          .height(this.nowtopindex==6?'80%':'93%')
          .scrollBar(BarState.Off)
          .onScrollEdge((size)=>{
            if (size==Edge.Bottom) {
              if (this.page <= this.pages) {
                this.page++
                this.GetTaskList('1')
              }
            }
          })
        }
        .onRefreshing(() => {
          setTimeout(() => {
            this.isRefreshing = false
          }, 2000)
          console.log('onRefreshing test')
        })

      }
      else {
        Column(){
          Image($r('app.media.ic_not_found'))
            .width('100%')
            .height('30%')
          Text('无待提货物')
            .fontSize($r('app.string.TextTwoFontSize'))
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        }
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}

@Extend(Text)
function textdo(){
  .width(100)
  .height(30)
  .backgroundColor($r('app.color.Neutral_Colors_PlaceholdingFont'))
  .fontColor($r('app.color.Neutral_Colors_MainFont'))
  .borderRadius(30)
  .textAlign(TextAlign.Center)
}