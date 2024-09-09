import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { fileIo as fs, ListFileOptions, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { AxiosError, AxiosProgressEvent, AxiosResponse, FormData } from '@ohos/axios';
import { axiosInstance } from '../http/Axois';

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
    let writeLen = fs.writeSync(file2.fd, buffer);
  console.info(`=====${filename}`)
  console.info(`=====${filename.split('.')[filename.split('.').length-1]}`)

  formData.append('file', 'internal://cache/' +Fil)
  await axiosInstance.post<string, AxiosResponse<string>, FormData>('/driver/files/imageUpload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
    context: UIabilityContext,
    onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
      console.info(progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) + '%' : '0%');
    },
  }).then((res: AxiosResponse) => {
    url=res.data.data
    return url
    console.info("result" + JSON.stringify(res.data.data));
  }).catch((error: AxiosError) => {
    console.error("error:" + JSON.stringify(error));
  })
return url
}
