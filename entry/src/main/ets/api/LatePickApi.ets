import { AxiosResponse } from '@ohos/axios'
import { axiosInstance, Message } from '../http/Axois'
import { LatePiceModel } from '../model/LatePickDo'
import { RegisterModel } from '../model/LoginDo'
import { JSON } from '@kit.ArkTS'

export async function LateToPick(late:LatePiceModel){
  return  axiosInstance.put<null,AxiosResponse<Message,null>,LatePiceModel>('/driver/tasks/delay',late)
    .then((value)=>{
      if (value.data.code == 200) {
        return true
      }else {
        return false
      }
    })
    .catch((error:Error)=>{
      console.info(`err`)
    })
}