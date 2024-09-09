import { AxiosResponse } from '@ohos/axios'
import { axiosInstance, Message } from '../http/Axois'
import { LoginModel, RegisterModel } from '../model/LoginDo'
import { TasKDataModel, TaskDatil, TaskModel } from '../model/TaskDo'
import preferencesUtil from '../utils/PreferencesUtil'

// export async function LoginByPhone(key:string){
//   axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/register/captcha', {
//     params:{
//       key:key
//     }
//   })
//     .then((value)=>{
//       console.info(`message data=${JSON.stringify(value)}`)
//     })
// }


export async function Register(register:RegisterModel){
  return  axiosInstance.post<null,AxiosResponse<Message,null>,RegisterModel>('/driver/register/account',register)
    .then((value)=>{
      if (value.data.code==2) {
        return true
      }else {
        return false
      }
    })
}

export async function LoginByAcount(acount:LoginModel){
  return  axiosInstance.post<null,AxiosResponse<Message,null>,LoginModel>('/driver/login/account',acount)
    .then((value)=>{
      if (value.data.code === 200) {
        let AUTH_TOKEN=value.data.data
        preferencesUtil.putValue('Authorization',AUTH_TOKEN as string)
        axiosInstance.defaults.headers.common['Authorization'] = AUTH_TOKEN as string
        return true
      }else {
        return false
      }
    })
}

export async function GetAllTaskList(page:string,pageSize:string,status:string){
  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/tasks/list',{
    params:{
      page:page,
      pageSize:pageSize,
      status:status
    }
  })
    .then((value)=>{
      let TasKDatas:TaskModel=new TaskModel(0,0,0,0,[])
      if (value.data.code === 200) {
        let a=value.data.data as TaskModel
        console.info(`aitem===${JSON.stringify(a)}`)
        TasKDatas=a
      }
      return TasKDatas
    })
}


export async function GetTaskByTime(page:string,pageSize:string,status:string,startTime:string|null,endTime:string|null,transportTaskId:string|null){
  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/tasks/list',{
    params:{
      startTime:startTime,
      endTime:endTime,
      transportTaskId:transportTaskId,
      page:page,
      pageSize:pageSize,
      status:status
    }
  })
    .then((value)=>{
      let TasKDatas:TaskModel=new TaskModel(0,0,0,0,[])
      if (value.data.code === 200) {
        let a=value.data.data as TaskModel
        console.info(`aitem===${JSON.stringify(a)}`)
        TasKDatas=a
      }
      return TasKDatas
    })
}


export async function GetOneTaskListInfo(jobId:string){
  return axiosInstance.get<null,AxiosResponse<Message,null>,string>('/driver/tasks/details/'+jobId,{
    params:{
      jobId:jobId,
    }
  })
    .then((value)=>{
      let taskinfo:TaskDatil=value.data.data as TaskDatil
      return taskinfo
    })
}

