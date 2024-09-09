
@CustomDialog
@Component
export  struct  imgialog{
  @State scaleValue: number = 1
  @State pinchValue: number = 1
  @State offsetX:number=0
  @State offsetY:number=0
  @State positionX: number = 0
  @State positionY: number = 0
  @Link imgpath:string
  @State imgwid:number=390
  private controller:CustomDialogController
  build() {
    Column(){
      Image(this.imgpath)
        .width(this.imgwid)
        .height(this.imgwid)
        .translate({ x: this.pinchValue<1?0:this.offsetX, y:  this.pinchValue<1?0:this.offsetY })
        .scale({
          x:this.pinchValue>2?2:(this.pinchValue<0.5 ? 0.5:this.pinchValue),
          y:this.pinchValue>2?2:(this.pinchValue<0.5 ? 0.5:this.pinchValue)
        })
        .defaultFocus(true)
        .gesture(
          PanGesture()
            .onActionStart((event: GestureEvent) => {
            })
            .onActionUpdate((event: GestureEvent) => {
              if (event) {
                this.offsetX = this.positionX + event.offsetX
                this.offsetY = this.positionY + event.offsetY
              }
            })
            .onActionEnd((event: GestureEvent) => {
              this.positionX = this.offsetX
              this.positionY = this.offsetY
            })
        )
    }
    .onClick(()=>{
      this.controller.close()
    })
    .gesture(
      PinchGesture({ fingers: 2 })
        .onActionStart((event: GestureEvent) => {
          console.info('Pinch start')
        })
        .onActionUpdate((event: GestureEvent) => {
          if (event) {
            this.scaleValue = this.pinchValue * event.scale
            this.pinchValue = this.scaleValue
          }
        })
        .onActionEnd((event: GestureEvent) => {

        })
    )
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}