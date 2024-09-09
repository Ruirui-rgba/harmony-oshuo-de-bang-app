import { AxiosResponse } from '@ohos/axios'
import { axiosInstance, Message } from '../http/Axois'
import { UserCar, UserModel, UserTaskModel } from '../model/UserDo'

export async function GetUserInfo(){
  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/users')
    .then((value)=>{
        return value.data.data as UserModel
    })
}


export async function GetUserTask(){
  const now = new Date();
  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/users/taskReport',{
    params:{
      month:now.getMonth() + 1<10?'0'+(now.getMonth() + 1):(now.getMonth() + 1).toString(),
      year:now.getFullYear().toString()
    }
  })
    .then((value)=>{
      return value.data.data as UserTaskModel
    })
}

export async function GetUserCar(){
  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/users/truck')
    .then((value)=>{
      return value.data.data as UserCar
    })
}


export async function GetUserTaskInfo(month:string,year:string){

  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/users/taskReport',{
    params:{
      month:month,
      year:year
    }
  })
    .then((value)=>{
      return value.data.data as UserTaskModel
    })
}