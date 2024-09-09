import { router } from '@kit.ArkUI'

@Entry
@Component
struct ErrorMessagePostation {
  @State postation:Array<viewmodel>=view
  @State postationindex:Array<viewmodel>=view
  @State nowindex:number=0
  @State inpvalue:string=''
  @State ifshowList:boolean=false
  @State nowpostation:string=''
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
      Text('当前位置')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  @Builder
  InrowSelect(view:viewmodel){
   Row(){
     Text(view.postation)
     Text(view.mil.toString())
   }
   .justifyContent(FlexAlign.SpaceBetween)
   .width('100%')
   .padding(20)

  }
  @Builder
  Inrow(view:viewmodel){
    Row(){
      Row({space:5}){
        if (this.nowindex==view.id){
          Image($r('app.media.ic_btn_ok'))
            .width(30)
            .height(30)
        }
        Text(view.postation)
      }
      Text(view.mil.toString())
    }
    .onClick(()=>{
      this.nowpostation=view.postation
      this.nowindex=view.id
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding(20)

  }
  build() {
    Column() {
      this.Intop()
      Row({space:10}){
        Search({placeholder:'小区/写字楼/学校等'})
          .height(30)
          .width(this.ifshowList?'85%':'95%')
          .onChange((value: string) => {
            this.inpvalue = value
          })
          .onClick(()=>{
            this.ifshowList=true
          })
        if (this.ifshowList){
          Text('取消')
            .width('10%')
            .onClick(()=>{
              this.ifshowList=false
            })
        }
      }
      .width('100%')
      .padding(10)
      if (this.ifshowList){
        List(){
          ForEach(this.postation,
            (item:viewmodel)=>{
              ListItem(){
                this.InrowSelect(item)
              }
            })
        }
        .height('80%')
        .backgroundColor(Color.Yellow)
      }else {
        Stack({alignContent:Alignment.Bottom}){
          Image($r('app.media.start'))
            .width('100%')
            .height('80%')
          Column(){
            Row(){
              List(){
                ForEach(this.postationindex,
                  (item:viewmodel)=>{
                    ListItem(){
                      this.Inrow(item)
                    }
                  })
              }
              .align(Alignment.Top)
              .height(200)
              .backgroundColor(Color.Yellow)
            }
          }
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}



class viewmodel{
  id:number=0
  postation:string=''
  mil:number=0

  constructor(id:number,postation: string, mil: number) {
    this.id=id
    this.postation = postation
    this.mil = mil
  }

}

const view:Array<viewmodel>=[
  new viewmodel(1,'育新花园',100),
  new viewmodel(2,'育新大厦',200),
  new viewmodel(3,'育新花园',300),
  new viewmodel(4,'育新街',400)

]