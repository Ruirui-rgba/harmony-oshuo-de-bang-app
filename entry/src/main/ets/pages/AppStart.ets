@CustomDialog
@Component
export  struct Appstart{
  private controller:CustomDialogController
  build() {
    Column() {
      Image($r('app.media.start'))
        .width('100%')
        .height('100%')
    }
    .height('100%')
    .width('100%')
  }
}