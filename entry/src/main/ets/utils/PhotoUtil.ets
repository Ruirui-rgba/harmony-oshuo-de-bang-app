import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { fileIo as fs, ListFileOptions, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { AxiosError, AxiosProgressEvent, AxiosResponse, FormData } from '@ohos/axios';
import { axiosInstance, baseUrl } from '../http/Axois';

export const  chossleImage=():Promise<string[]>=>{
  return new Promise((resolve)=>{
    try {
      //新建一个选择器对象的配置
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      // 文件类型
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      //
      PhotoSelectOptions.maxSelectNumber = 5;
      // 创建一个对象
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions)
        .then(async (PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
          resolve(PhotoSelectResult.photoUris)
        }).catch((err: BusinessError) => {
        console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  })
}

// 文件上传如果需要后端改大小限制
export async function  uploadImg(FilePath:string,Filename:string,UIabilityContext:common.UIAbilityContext){
  let url:string=''
  let formData = new FormData()
  const file =fs.openSync(FilePath, fs.OpenMode.READ_ONLY);
  const photoSize =fs.statSync(file.fd).size;
  console.info('Photo Size: ' + photoSize);
  let buffer = new ArrayBuffer(photoSize);
  let filename=FilePath.split('/')[FilePath.split('/').length-1]
  fs.readSync(file.fd, buffer);
  fs.closeSync(file);
  let cacheDir = UIabilityContext.cacheDir
  let Fil=Filename+'.'+filename.split('.')[filename.split('.').length-1]
  let p = cacheDir +'/'+ Fil
    let file2 = fs.openSync(p, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file2.fd, buffer);
  console.info(`=====${filename}`)
  console.info(`=====${filename.split('.')[filename.split('.').length-1]}`)

  formData.append('file', 'internal://cache/' +Fil)
  await axiosInstance.post<string, AxiosResponse<string>, FormData>('/driver/files/imageUpload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
    context: UIabilityContext
  }).then((res: AxiosResponse) => {
    url=res.data.data
    return url
    console.info("result" + JSON.stringify(res.data.data));
  }).catch((error: AxiosError) => {
    console.error("error:" + JSON.stringify(error));
  })
return url
}


//
// export const uploadImage = async (context: Context, files: request.File[]) => {
//   let config: request.UploadConfig = {
//     url: baseUrl + '/driver/files/imageUpload', // 后端给的接口地址
//     method: 'POST',
//     header: {
//       Authorization: axiosInstance.defaults.headers.common['Authorization'] , // 应用中的token
//       "Content-Type": "multipart/form-data" // 上传文件的参数类型
//     },
//     files,
//     data: [] // 批量上传需要携带的参数 用不上
//   }
//   return new Promise<ImageList[]>(async (resolve, reject) => {
//     try {
//       let arr: ImageList[] = []
//       const task = await request.uploadFile(context, config) // 成功执行并不意味着 上传成功 只是任务创建成功
//       task.on("fail", () => {
//         // 上传失败
//         AlertDialog.show({
//           message: "上传失败"
//         })
//         reject(new Error("上传失败"))
//       })
//       // 每上传成功一次就会进来
//       task.on("headerReceive", (headers: object) => {
//         if (headers["body"]) {
//           const result = JSON.parse(headers["body"]) as ResponseData<string>
//           if (result.code === 200) {
//             arr.push({
//               url: result.data as string
//             })
//           }
//         }
//       })
//       task.on("complete", () => {
//         // 上传完成
//         // 也不能拿到上传成功的地址
//         // 走到这里认为 要返回的结构已经ok了
//         resolve(arr)
//       })
//       // 4.0 上传完成之后 用文件的一个标识 又去后台查了一下  当时是最优方案
//     }catch(error) {
//       AlertDialog.show({
//         message: error.message // 提示错误消息
//       })
//       reject(error)
//     }
//   })
//
// }