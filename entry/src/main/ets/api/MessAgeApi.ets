import { AxiosResponse } from '@ohos/axios'
import { axiosInstance, Message } from '../http/Axois'
import { MessageModel } from '../model/MessageDo'

export async function GetMessageIndex(contentType:number,page:number,pageSize:number){
  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/messages/page',{
    params:{
      contentType:contentType,
      page:page,
      pageSize:pageSize
    }
  })
    .then((value)=>{
      let c=new MessageModel(0,[],0,0,0)
      if (value.data.code == 200) {
       c=value.data.data as MessageModel
        return c
      }else {
        return c
      }
    })
}


export async function ReadOneMessage(id:string){
  return  axiosInstance.put<null,AxiosResponse<Message,null>,string>('/driver/messages/'+id)
    .then((value)=>{

    })
}