export class TaskModel{
  counts:number
  pageSize:number
  pages:number
  page:number
  items:Array<TasKDataModel>

  constructor(counts: number, pageSize: number, pages: number, page: number, items: Array<TasKDataModel>) {
    this.counts = counts
    this.pageSize = pageSize
    this.pages = pages
    this.page = page
    this.items = items
  }

}
export class getJobId{
  jobId:string=''
}
export class TasKDataModel{
  actualArrivalTime:string
  actualDepartureTime:string
  created:string
  driverId:string
  enablePickUp:boolean
  endAddress:string
  endAgencyId:number
  finishHandover:string
  id:string
  planArrivalTime:string
  planDepartureTime:string
  startAddress:string
  startAgencyId:number
  startHandover:string

  // 后端返回实际为number   接口写的string  bug
  status:number
  transportTaskId:string

  constructor(actualArrivalTime: string, actualDepartureTime: string, created: string, driverId: string,
    enablePickUp: boolean, endAddress: string, endAgencyId: number, finishHandover: string, id: string,
    planArrivalTime: string, planDepartureTime: string, startAddress: string, startAgencyId: number,
    startHandover: string, status: number, transportTaskId: string) {
    this.actualArrivalTime = actualArrivalTime
    this.actualDepartureTime = actualDepartureTime
    this.created = created
    this.driverId = driverId
    this.enablePickUp = enablePickUp
    this.endAddress = endAddress
    this.endAgencyId = endAgencyId
    this.finishHandover = finishHandover
    this.id = id
    this.planArrivalTime = planArrivalTime
    this.planDepartureTime = planDepartureTime
    this.startAddress = startAddress
    this.startAgencyId = startAgencyId
    this.startHandover = startHandover
    this.status = status
    this.transportTaskId = transportTaskId
  }

}

export class TaskDatilModer{
  code:number
  msg:string
  data:object

  constructor(code: number, msg: string, data: object) {
    this.code = code
    this.msg = msg
    this.data = data
  }

}

export class TaskDatil{
  id:string=''
  startAgencyId:string=''
  startProvince:string=''
  startCity:string=''
  startAddress:string=''
  endAgencyId:string=''
  endProvince:string=''
  endAddress:string=''
  endCity:string=''
  status:number=0
  driverId:string=''
  transportTaskId:string=''
  startHandoverName:string=''
  startHandoverPhone:string=''
  finishHandoverName:string=''
  finishHandoverPhone:string=''
  planDepartureTime:string=''
  actualDepartureTime:string=''
  planArrivalTime:string=''
  actualArrivalTime:string=''
  licensePlate:string=''
  driverName:string=''
  cargoPickUpPictureList:Array<UrlImg>=[]
  cargoPictureList:Array<UrlImg>=[]
  transportCertificateList:Array<UrlImg>=[]
  deliverPictureList:Array<UrlImg>=[]
  exceptionList:Array<errorintask>=[]

}

export class errorintask{
  exceptionTime:string=''
  exceptionPlace:string=''
  exceptionType:string=''
  exceptionDescribe:string=''
  exceptionImagesList:Array<UrlImg>=[]
  handleResult:string=''
}

export class UrlImg{
  url:string

  constructor(url: string) {
    this.url = url
  }

}