export  class  UserModel{
  avatar:string
  name:string
  number:string
  phone:string

  constructor(avatar: string, name: string, number: string, phone: string) {
    this.avatar = avatar
    this.name = name
    this.number = number
    this.phone = phone
  }

}

export class UserTaskModel{
  completedAmounts:number
  dailyMileage:Array<UserTaskDay>
  taskAmounts:number
  transportMileage:number

  constructor(completedAmounts: number, dailyMileage: Array<UserTaskDay>, taskAmounts: number,
    transportMileage: number) {
    this.completedAmounts = completedAmounts
    this.dailyMileage = dailyMileage
    this.taskAmounts = taskAmounts
    this.transportMileage = transportMileage
  }

}

export class UserTaskDay{
  dateTime:string
  mileage:number

  constructor(dateTime: string, mileage: number) {
    this.dateTime = dateTime
    this.mileage = mileage
  }

}

export class UserCar{
  allowableLoad:string
  id:string
  licensePlate:string
  pictureList:Array<Carimage>
  truckType:string
  currentOrganName:string

  constructor(allowableLoad: string, id: string, licensePlate: string, pictureList: Array<Carimage>, truckType: string,
    currentOrganName: string) {
    this.allowableLoad = allowableLoad
    this.id = id
    this.licensePlate = licensePlate
    this.pictureList = pictureList
    this.truckType = truckType
    this.currentOrganName = currentOrganName
  }

}

export class Carimage{
  url:string

  constructor(url: string) {
    this.url = url
  }

}

export class  Mymessage{
  id:number=1
  title:string=''
  value:boolean=false

  constructor(id:number,title: string, value: boolean) {
    this.id=id
    this.title = title
    this.value = value
  }

}

export const someMessage:Array<Mymessage>=[
  new Mymessage(1,'允许给我推送任务通知',false)
]