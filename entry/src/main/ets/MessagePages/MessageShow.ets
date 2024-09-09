import { GetMessageIndex, ReadOneMessage } from '../api/MessAgeApi'
import { MessageInModel } from '../model/MessageDo'
import { router } from '@kit.ArkUI'

@Component
export struct MessageShow{
  @Link Message:Array<MessageInModel>
  @Prop page:number=1
  // @Prop pages:number=1
  // @Builder
  // InRow(item:MessageInModel){
  //   Row({space:5}){
  //     Row(){
  //       if (item.isRead==0){
  //         Image($r('app.media.ic_radio_false'))
  //           .fillColor($r('app.color.Brand_Color'))
  //           .width(10)
  //           .height(10)
  //       }
  //     }
  //     .width('5%')
  //     Row(){
  //       Text(item.title)
  //         .maxLines(1)
  //         .textOverflow({ overflow:TextOverflow.Ellipsis})
  //         .width('60%')
  //       Text(item.updated)
  //         .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
  //         .maxLines(1)
  //         .textOverflow({ overflow:TextOverflow.Ellipsis})
  //         .width('40%')
  //     }
  //     .justifyContent(FlexAlign.SpaceBetween)
  //     .width('94%')
  //   }
  //   .onClick(()=>{
  //     if (item.isRead == 0) {
  //       ReadOneMessage(item.id.toString())
  //     }
  //     router.pushUrl({
  //       url:'MessagePages/MessageToTalk',
  //       params:{
  //         item:item
  //       }
  //     })
  //   })
  //   .width('95%')
  //   .backgroundColor(Color.White)
  //   .padding(20)
  // }
  build() {
    Column(){
      Scroll(){
        Column(){
          List(){
            ForEach(this.Message,
              (item:MessageInModel)=>{
                ListItem(){
                  InRow({
                    item:item
                  })
                }
              })
          }
          .scrollBar(BarState.Off)
          .alignListItem(ListItemAlign.Center)
          // if (this.page<=this.pages){
          //   Button('加载更多')
          //     .onClick((event: ClickEvent) => {
          //       console.info(`page===${this.page}`)
          //       console.info(`pages===${this.pages}`)
          //       if (this.page <= this.pages) {
          //         this.page++
          //         GetMessageIndex(200,this.page,10)
          //           .then((value)=>{
          //             if (value.items.length>=1) {
          //               for (const element of value.items) {
          //                 this.Message.push(element)
          //               }
          //             }
          //           })
          //       }
          //     })
          // }
        }
      }
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct InRow{
  @Prop item:MessageInModel
  @Consume @Watch('readall')allread:boolean
  readall(){
    if (this.item.isRead == 0) {
      ReadOneMessage(this.item.id.toString())
      this.item.isRead=1
    }
  }
  build() {
    Row({space:5}){
      Row(){
        if (this.item.isRead==0){
          Image($r('app.media.ic_radio_false'))
            .fillColor($r('app.color.Brand_Color'))
            .width(10)
            .height(10)
        }
      }
      .width('5%')
      Row(){
        Text(this.item.title)
          .maxLines(1)
          .textOverflow({ overflow:TextOverflow.Ellipsis})
          .width('60%')
        Text(this.item.updated)
          .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          .maxLines(1)
          .textOverflow({ overflow:TextOverflow.Ellipsis})
          .width('40%')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('94%')
    }
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
    .width('95%')
    .backgroundColor(Color.White)
    .padding(20)
  }
}
