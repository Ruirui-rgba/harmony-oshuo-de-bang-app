import { GetUserInfo, GetUserTask } from '../api/UserApi'
import { UserModel, UserTaskModel } from '../model/UserDo'
import { router } from '@kit.ArkUI'
// @Concurrent
// async function Taskone(): Promise<void>{
//   await GetUserInfo()
//     .then((value)=>{
//       return value
//     })
// }
@Component
export struct Mypage{
  @State userinfo:UserModel=new UserModel('','','','')
  @State Usertask:UserTaskModel=new UserTaskModel(1,[],1,1)
  @State isRefreshing: boolean = false
  @State NowPone:string=''
  @Builder
  refresh(){
    Image($r('app.media.layered_image'))
  }
  aboutToAppear(): void {
    GetUserInfo()
      .then((value)=>{
        this.userinfo=value
        this.NowPone= this.userinfo.phone
      })
    GetUserTask()
      .then((value)=>{
        this.Usertask=value
      })
  }
  build() {
    Column(){
      Stack({alignContent:Alignment.Top}){
        Image($r('app.media.bg_page_my'))
          .width('100%')
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]) // 图片组件的绘制区域扩展至状态栏和导航条


      Refresh({ refreshing: $$this.isRefreshing}){
        Column({space:20}){
          Image(this.userinfo.avatar==''?$r('app.media.ic_avatar_driver'):this.userinfo.avatar)
            .width(70)
            .height(70)
            .borderRadius(50)
          Text(this.userinfo.name)
            .fontSize($r('app.string.TitleFontSize'))
            .fontColor(Color.White)
          Text('司机编号: '+this.userinfo.number)
            .fontColor(Color.White)
          Text('手机号: '+this.userinfo.phone)
            .fontColor(Color.White)
          Column(){
            Text(`-本月任务-`)
            Row({space:30}){
              Column({space:20}){
                Text(this.Usertask.taskAmounts.toString())
                  .Textinnumber()
                Text('任务总量')
                  .Textinfont()
              }
              .width(60)
              Column({space:20}){
                Text(this.Usertask.completedAmounts.toString())
                  .Textinnumber()
                Text('完成任务量')
                  .Textinfont()
              }
              .width(60)
              Column({space:20}){
                Text(this.Usertask.transportMileage.toString())
                  .Textinnumber()
                Text('运输里程(km)')
                  .Textinfont()

              }
              .width(80)
            }
            .width('100%')
            .padding(20)
          }
          .padding(20)
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius(10)


          Column(){
            Row(){
              Text('车辆信息')
                .titlefont()
              Image($r('app.media.ic_btn_more'))
                .wAh()
            }
            .onClick(()=>{
              router.pushUrl({
                url:'mypage/MyCarPage'
              })
            })
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            Line()
              .width('95%')
              .height(1)
              .backgroundColor($r('app.color.Neutral_Colors_Divided'))
              .margin({top:20,bottom:20})


            Row(){
              Text('任务数据')
                .titlefont()
              Image($r('app.media.ic_btn_more'))
                .wAh()
            }
            .onClick(()=>{
              router.pushUrl({
                url:'mypage/MyTaskInfo',
                params:{
                  usertask:this.Usertask
                }
              })
            })


            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            Line()
              .width('95%')
              .height(1)
              .backgroundColor($r('app.color.Neutral_Colors_Divided'))
              .margin({top:20,bottom:20})
            Row(){
              Text('系统设置')
                .titlefont()
              Image($r('app.media.ic_btn_more'))
                .wAh()
            }
            .onClick(()=>{
              router.pushUrl({
                url:'mypage/XiTongPage',
                params:{
                  phonenumber:this.NowPone
                }
              })
            })
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .padding(20)
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .padding(20)
        .width('100%')
      }
      .height('100%')
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 2000)
        console.log('onRefreshing test')
      })
        // Column({space:20}){
        //   Image(this.userinfo.avatar==''?$r('app.media.ic_avatar_driver'):this.userinfo.avatar)
        //     .width(70)
        //     .height(70)
        //     .borderRadius(50)
        //   Text(this.userinfo.name)
        //     .fontSize($r('app.string.TitleFontSize'))
        //     .fontColor(Color.White)
        //   Text('司机编号: '+this.userinfo.number)
        //     .fontColor(Color.White)
        //   Text('手机号: '+this.userinfo.phone)
        //     .fontColor(Color.White)
        //   Column(){
        //     Text(`-本月任务-`)
        //     Row({space:30}){
        //       Column({space:20}){
        //         Text(this.Usertask.taskAmounts.toString())
        //           .Textinnumber()
        //         Text('任务总量')
        //           .Textinfont()
        //       }
        //       .width(60)
        //       Column({space:20}){
        //         Text(this.Usertask.completedAmounts.toString())
        //           .Textinnumber()
        //         Text('完成任务量')
        //           .Textinfont()
        //       }
        //       .width(60)
        //       Column({space:20}){
        //         Text(this.Usertask.transportMileage.toString())
        //           .Textinnumber()
        //         Text('运输里程(km)')
        //           .Textinfont()
        //
        //       }
        //       .width(80)
        //     }
        //     .width('100%')
        //     .padding(20)
        //   }
        //   .padding(20)
        //   .width('95%')
        //   .backgroundColor(Color.White)
        //   .borderRadius(10)
        //
        //
        //   Column(){
        //       Row(){
        //         Text('车辆信息')
        //           .titlefont()
        //         Image($r('app.media.ic_btn_more'))
        //           .wAh()
        //       }
        //       .onClick(()=>{
        //         router.pushUrl({
        //           url:'mypage/MyCarPage'
        //         })
        //       })
        //       .width('100%')
        //       .justifyContent(FlexAlign.SpaceBetween)
        //     Line()
        //       .width('95%')
        //       .height(1)
        //       .backgroundColor($r('app.color.Neutral_Colors_Divided'))
        //       .margin({top:20,bottom:20})
        //     Row(){
        //       Text('任务数据')
        //         .titlefont()
        //       Image($r('app.media.ic_btn_more'))
        //         .wAh()
        //     }
        //
        //     .width('100%')
        //     .justifyContent(FlexAlign.SpaceBetween)
        //     Line()
        //       .width('95%')
        //       .height(1)
        //       .backgroundColor($r('app.color.Neutral_Colors_Divided'))
        //       .margin({top:20,bottom:20})
        //     Row(){
        //       Text('系统设置')
        //         .titlefont()
        //       Image($r('app.media.ic_btn_more'))
        //         .wAh()
        //     }
        //     .onClick(()=>{
        //       router.pushUrl({
        //         url:'mypage/XiTongPage',
        //         params:{
        //           phonenumber:this.NowPone
        //         }
        //       })
        //     })
        //     .width('100%')
        //     .justifyContent(FlexAlign.SpaceBetween)
        //   }
        //   .padding(20)
        //   .width('95%')
        //   .backgroundColor(Color.White)
        //   .borderRadius(10)
        // }
        // .padding(20)
        // .width('100%')



      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}

@Extend(Text)
function  Textinfont(){
  .fontSize($r('app.string.TextThreeFontSize'))
}

@Extend(Text)
function  Textinnumber(){
  .fontSize($r('app.string.TextOneFontSize'))
  .fontWeight(FontWeight.Bold)
}

@Extend(Image)
function  wAh(){
  .width(20)
  .height(20)
}

@Extend(Text)
function titlefont(){
  .fontSize($r('app.string.TitleFontSize'))
}