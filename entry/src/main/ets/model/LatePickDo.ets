export class LatePiceModel{
  id:string
  delayTime:string
  delayReason:string

  constructor(id: string, delayTime: string, delayReason: string) {
    this.id = id
    this.delayTime = delayTime
    this.delayReason = delayReason
  }

}