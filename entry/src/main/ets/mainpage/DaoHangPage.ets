import { router } from '@kit.ArkUI'
import { TaskDatil } from '../model/TaskDo'
import { common, Permissions, Want } from '@kit.AbilityKit';
import { checkPermissions } from '../utils/PermissionUtil';
import { geoLocationManager } from '@kit.LocationKit';
import { MapComponent, mapCommon, map, navi } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
class pageinfo{
  task:TaskDatil=new TaskDatil()
}
const permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION'];
const permissionst: Array<Permissions> = ['ohos.permission.LOCATION'];
const context = getContext(this) as common.UIAbilityContext
@Entry
@Component
struct DaoHangPage {
  @State task:TaskDatil=new TaskDatil()
  @State Location:geoLocationManager.Location|null=null
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;
  @State latitude:number=39.9
  @State longitude:number=116.4
  // 页面每次显示时触发一次，包括路由过程、应用进入前台等场景，仅@Entry装饰的自定义组件生效
  onPageShow(): void {
    // 绘制地图页面的生命周期onPageShow，将地图切换到前台
    if (this.mapController !== undefined) {
      this.mapController.show();

    }
  }

  // 页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景，仅@Entry装饰的自定义组件生效。
  onPageHide(): void {
    // 绘制地图页面的生命周期onPageHide，将地图切换到后台
    if (this.mapController !== undefined) {
      this.mapController.hide();
    }}
  getpostation(){
    try {
      this.Location= geoLocationManager.getLastLocation()
      this.latitude=this.Location.latitude
      this.longitude=this.Location.longitude
      console.info(`===location:${this.Location.latitude}`)
    } catch (err) {
      console.error("errCode:" + JSON.stringify(err));
    }
  }

   aboutToAppear(): void {
    this.task= (router.getParams() as pageinfo).task

    this.mapOptions = {
      position: {
        target: {
          latitude: this.latitude,
          longitude:this.longitude
        },
        zoom: 10
      }
    }


      // 地图初始化的回调
      this.callback = async (err, mapController) => {
        if (!err) {
          // 获取地图的控制器类，用来操作地图
          this.mapController = mapController;
          this.mapEventManager = this.mapController.getEventManager();


          checkPermissions(permissions,context)
            .then((value)=>{
              if (value){
                this.getpostation()
                // 启用我的位置图层，mapController为地图操作类对象，获取方式详见显示地图章节
                this.mapController?.setMyLocationEnabled(true);
                // 启用我的位置按钮
                this.mapController?.setMyLocationControlsEnabled(true);
                // this.mapController?.setMyLocation(this.Location);

                let target: mapCommon.LatLng = {
                  latitude: this.latitude,
                  longitude:this.longitude
                };
                let cameraPosition: mapCommon.CameraPosition = {
                  target: target,
                  zoom: 10
                };
                // 新建CameraUpdate对象
                let cameraUpdate: map.CameraUpdate = map.newCameraPosition(cameraPosition);
                this.mapController?.animateCamera(cameraUpdate, 1000);







                let markerOptions: mapCommon.MarkerOptions = {
                  position: {
                    latitude: this.latitude,
                    longitude: this.longitude
                  },
                  rotation: 0,
                  visible: true,
                  zIndex: 0,
                  alpha: 1,  //透明度，取值范围[0, 1]，0代表完全透明，1表示完全不透明，默认值为1，异常值按默认值处理。
                  anchorU: 0.5,
                  anchorV: 1,
                  clickable: true,
                  draggable: true,
                  flat: false
                };
                // 创建Marker
                this.mapController?.addMarker(markerOptions);






              }
            })


          let callback = () => {
            // this.mapController?.setMyLocation(this.Location);
          }
          this.mapEventManager.on("mapLoad", callback);
        }
      }




  }
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
      Text('导航')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  @Builder
  InCenter(){
    Column(){
      Column(){
        Row({space:10}){
          Column(){
            Text('起')
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .fontSize($r('app.string.TextThreeFontSize'))
              .width(20)
              .height(20)
              .borderRadius(50)
              .backgroundColor($r('app.color.Neutral_Colors_MainFont'))
            Text('|')
              .fontSize($r('app.string.TextThreeFontSize'))
              .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            Text('|')
              .fontSize($r('app.string.TextThreeFontSize'))
              .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
            Text('|')
              .fontSize($r('app.string.TextThreeFontSize'))
              .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
          }
          .alignItems(HorizontalAlign.Center)
          Text(this.task.startAddress)
            .textAlign(TextAlign.Start)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('80%')
            .maxLines(2)
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        }
        .alignItems(VerticalAlign.Top)
        Row({space:10}){
          Text('止')
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .fontSize($r('app.string.TextThreeFontSize'))
            .width(20)
            .height(20)
            .borderRadius(50)
            .backgroundColor($r('app.color.Auxiliary_Color_Error'))
          Text(this.task.endAddress)
            .textAlign(TextAlign.Start)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('80%')
            .maxLines(2)
            .fontColor($r('app.color.Neutral_Colors_SecondaryText'))
        }
      }
      .margin({
        top:20
      })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      top:10,
      left:20,
      bottom:20
    })
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
  build() {
    Column() {
      this.Intop()
      Stack({alignContent:Alignment.Top}){

        Column(){
          MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback }).width('100%').height('100%');
        }
          .width('100%')
          .height('100%')

      Column(){
          this.InCenter()
      }
      .margin({top:20})

      }
      .width('100%')
      .height('80%')
      Row(){
        // 开启地图导航


        Button('开始导航')
          .width('70%')
          .height(60)
          .backgroundColor(Color.Red)
          .onClick(async ()=>{
            let petalMapWant: Want = {
              bundleName: 'com.huawei.hmos.maps.app',
              uri: 'maps://routes',
              parameters: {
                linkSource: 'com.other.app',
                destinationLatitude: this.latitude,
                destinationLongitude: this.longitude
                // originLatitude: this.latitude,
                // originLongitude: this.longitude,
                // destinationName:this.task.endAddress
              }
            }

            let context = getContext(this) as common.UIAbilityContext;
            context.startAbility(petalMapWant);


            // let params: navi.DrivingRouteParams = {
            //   origins: [{
            //     "latitude": this.latitude,
            //     "longitude":this.longitude
            //   }],
            //   destination: {
            //     "latitude": 31.9821213545843,
            //     "longitude": 120.277557768591
            //   },
            //   language: "zh_CN"
            // };
            // const result = await navi.getDrivingRoutes(getContext(), params);
            // console.info("driving routes."+JSON.stringify(result));

          })

      }
      .padding({top:20})
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .backgroundColor(Color.White)
    }
    .height('100%')
    .width('100%')
  }
}