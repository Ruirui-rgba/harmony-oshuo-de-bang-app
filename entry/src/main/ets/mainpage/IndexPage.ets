import { tabonepage } from './IndexPageStruct/TabsPage';
import { promptAction, router } from '@kit.ArkUI';
import { GetAllTaskList } from '../api/LoginDoApi';
import { TasKDataModel } from '../model/TaskDo';
import { IndexMessage } from '../MessagePages/MessIndexPage';
import { Mypage } from '../mypage/MyPage';
import { emitter } from '@kit.BasicServicesKit';

@Entry
@Component
struct IndexPage {
  @State message: string = 'Hello World';
  @State nowtopindex:number=1
  @State @Watch('tochange') currentIndex:number=0
  @State TasKDatas:Array<TasKDataModel>=[]
  @State pages:number=0
  @State page:number=1
  private  tabsController:TabsController=new TabsController()

  aboutToAppear(): void {
    emitter.on({eventId:1},()=>{
      this.changemessage()
    })
    emitter.on({eventId:2},()=>{
      this.intwo()
    })
    router.clear()
    GetAllTaskList('1','10','1')
      .then((value)=>{
        if (value.items.length>=1) {
          this.page=value.page
          this.pages=value.pages
          this.TasKDatas=value.items
          console.info(`===taskdatas${this.TasKDatas[0].id}`)
        }
      })

  }
  intwo(){
    GetAllTaskList('1','10','2')
      .then((value)=>{
        if (value.items.length>=1) {
          this.page=value.page
          this.pages=value.pages
          this.TasKDatas=value.items
          console.info(`===taskdatas${this.TasKDatas[0].id}`)
        }
      })
  }
  changemessage(){
    GetAllTaskList('1','10','1')
      .then((value)=>{
        if (value.items.length>=1) {
          this.page=value.page
          this.pages=value.pages
          this.TasKDatas=value.items
          console.info(`===taskdatas${this.TasKDatas[0].id}`)
        }
      })
  }
  GetTaskList(){
    GetAllTaskList('1','10', this.nowtopindex.toString())
      .then((value)=>{
        console.info(`=====${JSON.stringify(value)}`)
        this.page=value.page
        this.pages=value.pages
        this.TasKDatas=value.items
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
        this.GetTaskList()
      }
    })

  }
  tochange(){
    this.tabsController.changeIndex(this.currentIndex)
  }
  @Builder
  intop(){
    Row({space:20}){
      this.intopsmallmodel('待提货',1)
      this.intopsmallmodel('在途',2)
      this.intopsmallmodel('已完成',3)
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .padding({
      top:10,
      left:30
    })
    .height('6%')
  }
  @Builder
  tableinbottom(icon:Resource,title:string,index:number){
    Column(){
      Image(icon)
        .width(25)
        .height(25)
        .fillColor(index==this.currentIndex?$r('app.color.Auxiliary_Color_Error'):$r('app.color.Neutral_Colors_PlaceholdingFont'))
      Text(title)
        .fontSize($r('app.string.TextThreeFontSize'))
    }
  }
  build() {
    Column() {
      // this.intop()
      Tabs({barPosition:BarPosition.End,controller:this.tabsController}){
        TabContent(){
          tabonepage({
            TasKDatas:this.TasKDatas,
            page:this.page,
            pages:this.pages
          })
        }
        .tabBar(this.tableinbottom($r('app.media.ic_tab_btn_task'),'任务',0))
        TabContent(){
          IndexMessage()
        }
        .tabBar(this.tableinbottom($r('app.media.ic_tab_btn_mess_nor'),'消息',1))
        TabContent(){
          Mypage()
        }
        .tabBar(this.tableinbottom($r('app.media.ic_tab_btn_mine_nor'),'我的',2))
      }
      .onChange((value:number)=>{
        this.currentIndex=value
      })
      .height('100%')
    }
    .height('100%')
    .width('100%')
  }
}