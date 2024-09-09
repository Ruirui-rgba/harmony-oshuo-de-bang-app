import { UrlImg } from './TaskDo'

export class ErrorModel{
  transportTaskId:string=''
  exceptionTime:string=''
  exceptionPlace:string=''
  exceptionType:string=''
  exceptionDescribe:string=''
  exceptionImagesList:Array<UrlImg>=[]

  constructor(transportTaskId: string, exceptionTime: string, exceptionPlace: string, exceptionType: string,
    exceptionDescribe: string, exceptionImagesList: Array<UrlImg>) {
    this.transportTaskId = transportTaskId
    this.exceptionTime = exceptionTime
    this.exceptionPlace = exceptionPlace
    this.exceptionType = exceptionType
    this.exceptionDescribe = exceptionDescribe
    this.exceptionImagesList = exceptionImagesList
  }

}

export const ErrorView:ErrorModel=new ErrorModel('','','','','',[])