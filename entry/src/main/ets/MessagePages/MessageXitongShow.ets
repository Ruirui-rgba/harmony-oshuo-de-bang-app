import { MessageInModel } from '../model/MessageDo'
import { router } from '@kit.ArkUI'
import { GetMessageIndex, ReadOneMessage } from '../api/MessAgeApi'

@Component
export struct MessageXitong{
  @Prop Message:Array<MessageInModel>
  @Prop page:number=1
  @Prop pages:number=1


  GetMessage(){
    GetMessageIndex(201, this.page,10)
      .then((value)=>{
          this.pages=value.pages
        if (value.items.length>=1) {
          for (const element of value.items) {
            this.Message.push(element)
          }
        }
      })
  }
  build() {
    Column(){
      Scroll(){
        List(){
          ForEach(this.Message,
          (item:MessageInModel,index:number)=>{
            ListItem(){
              InRow({
                item:item
              })
            }
          })
        }
        .scrollBar(BarState.Off)
        .alignListItem(ListItemAlign.Center)
      }
      .onScrollEdge((size)=>{
        if (size==Edge.Bottom) {

          if (this.page <= this.pages) {
            this.page++
            this.GetMessage()
          }
          console.info(`====message${this.Message.length}`)
        }
      })
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct InRow {
  @Prop item:MessageInModel
  @Consume @Watch('readall')allreadxitong:boolean
  readall(){
    if (this.item.isRead == 0) {
      ReadOneMessage(this.item.id.toString())
      this.item.isRead=1
    }
  }
  build() {
    Column(){
      Row(){
        Text(this.item.title)
        if (this.item.isRead==0){
          Image($r('app.media.ic_radio_false'))
            .fillColor($r('app.color.Brand_Color'))
            .width(10)
            .height(10)
        }
      }
      .alignSelf(ItemAlign.Start)
      .width('100%')
      Line()
        .width('95%')
        .height(1)
        .backgroundColor($r('app.color.Neutral_Colors_Divided'))
        .margin({top:20,bottom:20})
      Row(){
        Text(this.item.content)
          .fontSize($r('app.string.TextOneFontSize'))
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          .width('95%')
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
      }
      .width('100%')
      Row(){
        Text(this.item.updated)
          .fontSize($r('app.string.TextOneFontSize'))
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        Button('查看详情')
          .fontColor($r('app.color.Brand_Color'))
          .backgroundColor(Color.White)
          .border({
            width:2,
            color:$r('app.color.Brand_Color')
          })
          .height(20)
          .width(100)
          .onClick(()=>{
            if (this.item.isRead == 0) {
              ReadOneMessage(this.item.id.toString())
              this.item.isRead=1
            }
            router.pushUrl({
              url:'MessagePages/MessageToTalk',
              params:{
                item: this.item
              }
            })
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
    .padding(20)
    .width('95%')
    .margin({bottom:20})
  }
}