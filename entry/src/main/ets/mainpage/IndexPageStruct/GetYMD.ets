//得到年月日的弹窗
@CustomDialog
@Component
export  struct  GetYMD{
  private controller:CustomDialogController
  @State generateYearMonth: TextCascadePickerRangeContent [] = []
  @State year:string=''
  @State mounth:string=''
  @State day:string=''
  @Link endtime:string|null
  generateYearMonthRange(startYear: number, endYear: number): TextCascadePickerRangeContent[] {
    const range: TextCascadePickerRangeContent[] = [];

    for (let year = startYear; year <= endYear; year++) {
      const months: TextCascadePickerRangeContent[] = [];
      for (let month = 1; month <= 12; month++) {

        const days: TextCascadePickerRangeContent[] = [];
        let daysInMonth = new Date(year, month, 0).getDate();
        for (let day = 1; day <= daysInMonth; day++) {
          days.push({
            text: `${day.toString().padStart(2, '0')}日` // 确保天数是两位数
          });
        }

        months.push({
          text: `${month.toString().padStart(2, '0')}月`, // 确保月份是两位数
          children:days
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

  aboutToAppear(): void {
    let date=new Date()
    date.getFullYear()
    this.generateYearMonth = this.generateYearMonthRange(2000, date.getFullYear());
  }
  @Builder
  Intop(){
    Stack({alignContent:Alignment.Center}){
      Row(){
        Text('取消')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          .onClick(()=>{
            this.controller.close()
          })
        Text('完成')
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          .onClick(()=>{
            this.endtime=this.year+'-'+this.mounth+'-'+this.day
            this.controller.close()
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(10)
      Text('选择日期')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  build() {
    Column(){
      Row(){
        this.Intop()

      }
      TextPicker({ range: this.generateYearMonth })
        .onChange((value, index: number | number[]) => {
          let a =value as string[]
          this.year=a[0].replace("年", "")
          this.mounth=a[1].replace("月", "")
          this.day=a[2].replace("日", "")
        })
    }
    .backgroundColor(Color.White)
  }
}