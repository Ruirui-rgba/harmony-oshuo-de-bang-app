import { UserTaskModel } from '../model/UserDo'
import { router } from '@kit.ArkUI'
import { DateYAMDiag } from './DateYAMDiag'
import { RiLi } from './struct/RiLiDo'
import { CJDateItem} from 'cjcalendar';
import { GetUserTask, GetUserTaskInfo } from '../api/UserApi'

class Myinfo{
  usertask:UserTaskModel

  constructor(usertask: UserTaskModel) {
    this.usertask = usertask
  }

}
@Entry
@Component
struct MyTaskInfo {
  @State @Watch('yearormounthchange') year:string=new Date().getFullYear().toString()
  @State @Watch('yearormounthchange') mounth:string=new Date().getMonth() + 1<10?'0'+(new Date().getMonth()  + 1):(new Date().getMonth() +1).toString()
  @State Usertask:UserTaskModel=new UserTaskModel(1,[],1,1)
  @State day:string=''
  @State generateYearMonth: TextCascadePickerRangeContent [] = []
  @State cjDataItem: CJDateItem = new CJDateItem(new Date('2000-01-01'))
  @State date:string='2001-1-1'
  generateYearMonthRange(startYear: number, endYear: number): TextCascadePickerRangeContent[] {
    const range: TextCascadePickerRangeContent[] = [];

    for (let year = startYear; year <= endYear; year++) {
      const months: TextCascadePickerRangeContent[] = [];
      for (let month = 1; month <= 12; month++) {
        months.push({
          text: `${month.toString().padStart(2, '0')}月` // 确保月份是两位数
        });
      }
      // 只有当月份数组不为空时，才添加到range中
      if (months.length > 0) {
        range.push({
          text: `${year}年`, // 使用年份作为文本
          children: months // 只有当月份不为空时，才设置children属性
        });
      }
    }

    return range; // 返回一维数组
  }
  dialogController:CustomDialogController=new CustomDialogController({
    builder:DateYAMDiag({
      generateYearMonth:this.generateYearMonth,
      yearreal:this.year,
      mounthreal:this.mounth
    }),
    customStyle:true,
    alignment:DialogAlignment.Bottom
  })
  aboutToAppear(): void {
    const now = new Date();
    this.Usertask=(router.getParams() as Myinfo).usertask
    this.day=now.getDate()<10?'0'+(now.getDate()):(now.getDate()).toString()

    let datess=new Date()
    datess.getFullYear()
    this.generateYearMonth = this.generateYearMonthRange(2000, datess.getFullYear());
  }

  // 月份或年份发生变化时  重新查询
  yearormounthchange(){
    GetUserTaskInfo(this.mounth,this.year)
      .then((value)=>{
        this.Usertask=value
      })
    this.date=this.year+'-'+this.mounth+'-'+this.day
    this.cjDataItem=new CJDateItem(new Date(this.date))
  }
  @Builder
  InTop(){
    Column({space:10}){
      Stack({alignContent:Alignment.Start}){
        Row(){
          Text('任务数据')
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
    .padding(20)
    .width('100%')
    .backgroundColor(Color.White)
  }
  build() {
    Column() {
      this.InTop()
      Row(){
        Image($r('app.media.ic_date_left'))
          .img()
        Text(this.year+'年'+this.mounth+'月')
        Image($r('app.media.ic_date_right'))
          .img()
      }
      .onClick(()=>{
        this.dialogController.open()
      })
      .height(60)

      Column(){
        Row({space:50}){
          Column({space:20}){
            Text(this.Usertask.taskAmounts.toString())
              .Textinnumber()
            Text('任务总量')
              .Textinfont()
          }
          Column({space:20}){
            Text(this.Usertask.completedAmounts.toString())
              .Textinnumber()
            Text('完成任务量')
              .Textinfont()
          }
          Column({space:20}){
            Text(this.Usertask.transportMileage.toString())
              .Textinnumber()
            Text('运输里程(km)')
              .Textinfont()

          }
        }
        .padding(20)
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .backgroundColor(Color.White)

      Column(){
        RiLi({
          date:this.date,
          cjDataItem:this.cjDataItem,
          dailyMileage:this.Usertask.dailyMileage
        })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.Neutral_Colors_BackgroundColor'))
  }
}

@Extend(Image)
function img(){
  .width(20)
  .height(20)
  .fillColor($r('app.color.Neutral_Colors_SecondaryText'))
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