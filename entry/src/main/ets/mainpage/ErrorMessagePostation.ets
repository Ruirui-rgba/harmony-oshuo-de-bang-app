import { router } from '@kit.ArkUI'
import { geoLocationManager } from '@kit.LocationKit'
import { map, mapCommon, MapComponent, site } from '@kit.MapKit'
import { AsyncCallback } from '@kit.BasicServicesKit'
import { common, Permissions } from '@kit.AbilityKit'
import { checkPermissions } from '../utils/PermissionUtil'
import { JSON } from '@kit.ArkTS'


class stiemodel{
  siteId:string=''
  name:string=''
  formatAddress:string=''
  distance:number=0
  location:mapCommon.LatLng={
    latitude:123,
    longitude:39.9
  }
}

const permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION'];
const permissionst: Array<Permissions> = ['ohos.permission.LOCATION'];
const context = getContext(this) as common.UIAbilityContext
@Entry
@Component
struct ErrorMessagePostation {
  @StorageLink('errorpostation') Postation:string='北京市 北京市 海淀区'
  @State postation:Array<viewmodel>=view
  @State postationindex:Array<viewmodel>=view
  @State searchsite:Array<stiemodel>=[]
  @State nowindex:number=0
  @State inpvalue:string=''
  @State ifshowList:boolean=false
  @State nowpostation:string=''
  @State Location:geoLocationManager.Location|null=null
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;
  @State latitude:number=39.9
  @State longitude:number=116.4

  nearsearchinsart(){
    let params: site.NearbySearchParams = {
      location: {
        latitude: this.latitude,
        longitude: this.longitude
      },
      radius: 5000,
      poiTypes: ["NATIONAL_RAILWAY_STATION"],
      language: "zh_CN",
      pageIndex: 1,
      pageSize: 1
    };
    site.nearbySearch(params)
      .then((value)=>{
        let id=value.sites as site.Site[]
        if (id.length>0)   {
          this.Postation=id[0].formatAddress as string
          console.info("searching nearby"+JSON.stringify(id[0].formatAddress));
        }
      })



  }



  nearsearchall(){
    let params: site.SearchByTextParams = {
      query:this.inpvalue,
      location: {
        latitude: this.latitude,
        longitude: this.longitude
      },
      radius: 10000,
      language: "zh_CN"
    };
    site.searchByText(params)
      .then((value)=>{
        this.searchsite=value.sites as Array<stiemodel>
      })



  }

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
              this.nearsearchinsart()

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
      Text('当前位置')
        .fontColor($r('app.color.Neutral_Colors_MainFont'))
        .fontSize($r('app.string.TitleFontSize'))
        .fontWeight(FontWeight.Bold)
    }
    .backgroundColor(Color.White)
    .width('100%')
  }
  // @Builder
  // InrowSelect(view:viewmodel){
  //  Row(){
  //    Text(view.postation)
  //    Text(view.mil.toString())
  //  }
  //  .justifyContent(FlexAlign.SpaceBetween)
  //  .width('100%')
  //  .padding(20)
  //
  // }
  @Builder
  InrowSelect(view:stiemodel){
    Row(){
      Text(view.formatAddress+view.name)
        .width('70%')
      Text(view.distance>=1000?(view.distance/1000).toFixed(2)+'km':view.distance.toString()+'m')
        .width('20%')
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding(20)
    .onClick(()=>{
      this.Postation=view.formatAddress+view.name
      this.inpvalue=''
      router.back()
    })

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
        Search({placeholder:'小区/写字楼/学校等',value:this.inpvalue})
          .height(30)
          .width(this.ifshowList?'85%':'95%')
          .onChange((value: string) => {
            if (value != '') {
              this.inpvalue = value
              this.nearsearchall()
            }
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
          ForEach(this.searchsite,
            (item:stiemodel)=>{
              ListItem(){
                this.InrowSelect(item)
              }
            })
        }
        .height('80%')

      }else {
        Stack({alignContent:Alignment.Bottom}){
          MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback })
            .width('100%')
            .height('80%')
          Column(){
            // Row(){
            //   List(){
            //     ForEach(this.postationindex,
            //       (item:viewmodel)=>{
            //         ListItem(){
            //           this.Inrow(item)
            //         }
            //       })
            //   }
            //   .align(Alignment.Top)
            //   .height(200)
            //   .backgroundColor(Color.Yellow)
            // }
            // Button('确定')
            //   .onClick(()=>{
            //     router.back()
            //   })
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