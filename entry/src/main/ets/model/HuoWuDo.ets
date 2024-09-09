import { UrlImg } from './TaskDo'


export class HuoModer{
  cargoPickUpPictureList:Array<UrlImg>=[]
  id:string=''
  cargoPictureList:Array<UrlImg>=[]

  constructor(cargoPickUpPictureList: Array<UrlImg>, id: string, cargoPictureList: Array<UrlImg>) {
    this.cargoPickUpPictureList = cargoPickUpPictureList
    this.id = id
    this.cargoPictureList = cargoPictureList
  }

}

export class HuoTwoModel{
  deliverPictureList:Array<UrlImg>=[]
  id:string=''
  certificatePictureList:Array<UrlImg>=[]

  constructor(deliverPictureList: Array<UrlImg>, id: string, certificatePictureList: Array<UrlImg>) {
    this.deliverPictureList = deliverPictureList
    this.id = id
    this.certificatePictureList = certificatePictureList
  }

}

// 回车登记
export class HuiCheModel{
  id:string=''
  startTime:string=''
  endTime:string=''
  accidentDescription:string|null=null
  accidentImagesList:Array<UrlImg>|null=null
  accidentType:string|null=null
  breakRulesDescription:string|null=null
  breakRulesType:string|null=null
  deductPoints:number|null=null
  faultDescription:string|null=null
  faultImagesList:Array<UrlImg>|null=null
  faultType:string|null=null
  isAccident:boolean|null=null
  isAvailable:boolean|null=null
  isBreakRules:boolean|null=null
  isFault:boolean|null=null
  penaltyAmount:string |null=null




}

export const HuiCheViewModel:HuiCheModel=new HuiCheModel()