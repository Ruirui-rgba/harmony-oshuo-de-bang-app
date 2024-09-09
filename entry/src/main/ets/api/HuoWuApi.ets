import { AxiosResponse } from '@ohos/axios'
import { axiosInstance, Message } from '../http/Axois'
import { HuiCheModel, HuoModer, HuoTwoModel } from '../model/HuoWuDo'
import { promptAction } from '@kit.ArkUI'

export async function SubMit(Huo:HuoModer){
  return  axiosInstance.post<null,AxiosResponse<Message,null>,HuoModer>('/driver/tasks/takeDelivery',Huo)
    .then((value)=>{

    })
}

export async function JiaoFu(Huo:HuoTwoModel){
  return  axiosInstance.post<null,AxiosResponse<Message,null>,HuoTwoModel>('/driver/tasks/deliver',Huo)
    .then((value)=>{
      if (value.data.code == 200) {
        return true
      }else {
        return false
      }
    })
}

export async function HuiCheDengJi(Huo:HuiCheModel){
  return  axiosInstance.post<null,AxiosResponse<Message,null>,HuiCheModel>('/driver/tasks/truckRegistration',Huo)
    .then((value)=>{

      console.info(`==value${JSON.stringify(value.data)}`)
      if (value.data.code == 200) {
        return true
      }else {
        return false
      }
    })
    .catch((error:Error)=>{
      console.info(`==valueerror:${error}`)
    })
}

