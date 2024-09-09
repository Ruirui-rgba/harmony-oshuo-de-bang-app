import { CellStatus, CJCalendar, CJCalendarControl, CJCalStatusParams,
  CJCellStyle,
  CJDateItem, OptMode,
  SelectedStyle } from 'cjcalendar';
import { UserTaskDay } from '../../model/UserDo';

@Component
export  struct RiLi{
  @Prop dailyMileage:Array<UserTaskDay>=[]
  private swiperController: SwiperController = new SwiperController()
  @Prop date:string='2001-01-01'
  @Prop @Watch('changedate')cjDataItem: CJDateItem = new CJDateItem(new Date('2000-01-01'))
  controller: CJCalendarControl = new CJCalendarControl()

  thisdayifhave(dayly:string){
    if (this.dailyMileage.length > 0) {
      for (let i = 0; i < this.dailyMileage.length; i++) {
        let day=new Date(this.dailyMileage[i].dateTime)
        // now.getDate()<10?'0'+(now.getDate()):(now.getDate()).toString()
        let nowday=day.getDate()<10?'0'+(day.getDate()):(day.getDate()).toString()
        if (dayly===nowday) {
          return this.dailyMileage[i].mileage.toString()
        }
      }
    }
    return '0'
  }
  changedate(){
    this.controller.skipToDate(this.date)
  }
  @Builder
  BuildCellBody() {
    Column() {

      Text('-')
        .fontColor(Color.Red)
      Text(this.cjDataItem.date + '')
        .fontColor(this.cjDataItem.isPre || this.cjDataItem.isNext ? "#CCCCCC" : "#323232")
    }
    .alignItems(HorizontalAlign.Center)

  }

  @Builder
  ToolbarLayout(){

  }

  build() {
    Column() {
      CJCalendar({
        controller:this.controller,
        startDate:new Date(2000, 1, 1),
        // buildCellBody: this.BuildCellBody(this.thisdayifhave(this.cjDataItem.date.toString())),
        buildCellBody: this.BuildCellBody,
        toolbarLayout: this.ToolbarLayout,
        swiperController:this.swiperController
      })

    }
    .backgroundColor(Color.White)
    .margin({top:20})
  }
}