import { AxiosResponse } from '@ohos/axios'
import { axiosInstance, Message } from '../http/Axois'
import { ErrorModel } from '../model/ErrorDo'

export async function ErrorSub(Error:ErrorModel){
  return  axiosInstance.post<null,AxiosResponse<Message,null>,ErrorModel>('/driver/tasks/reportException',Error)
    .then((value)=>{
      if (value.data.code == 200) {
        return true
      }else {
        return false
      }
    })
}