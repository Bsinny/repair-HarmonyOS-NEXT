import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import {UploadImages} from '../../pages/models/commonModels'
let context =getContext(this) as common.UIAbilityContext
let cacheDir =context.cacheDir

export async function copyImgToCache(photoImgPath:string){
  const file =fs.openSync(photoImgPath,fs.OpenMode.READ_ONLY)
  let fileFD=file.fd
  let destPath=context.cacheDir
  let fileName=Date.now().toString()
  const ext='jpg'
  let fullPath=cacheDir+fileName+'.'+ext
  fs.copyFileSync(fileFD,fullPath)
  //返回值第一个是文件的路径，第二个是文件的名字
  return [`internal://cache/${fileName+'.'+ext}`,fileName+'.'+ext]

}


export async function photoPickerUtil(){
  //打开系统图库
  const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
  photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 过滤选择媒体文件类型为IMAGE
  photoSelectOptions.maxSelectNumber = 3; // 选择媒体文件的最大数目
  const pickerView=new photoAccessHelper.PhotoViewPicker
  let uris= await pickerView.select(photoSelectOptions)
  if (uris.photoUris.length <= 0) {
    return
  }
  let imgUri = uris.photoUris[0]
  console.log(`你选中的图片是${imgUri}`);
  return imgUri
  /*
  这个是官方api
  * let uris: Array<string> = [];
  const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
  photoViewPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
    uris = photoSelectResult.photoUris;
    console.info('photoViewPicker.select to file succeed and uris are:' + uris);
  }).catch((err: BusinessError) => {
    console.error(`Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
  })*/


}


