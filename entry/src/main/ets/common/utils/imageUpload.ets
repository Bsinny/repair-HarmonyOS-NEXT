import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import {UploadImages} from '../../pages/models/commonModels'

//现成的选取图片封装方法并且返回选取图片的地址
export  async function getImagePaths(count: number) : Promise<UploadImages> {

  let uploadImages : UploadImages = { fileList :[], previewImageList : [] }


  const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
  photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 过滤选择媒体文件类型为IMAGE
  photoSelectOptions.maxSelectNumber = count; // 选择媒体文件的最大数目
  let uris: Array<string> = [];
  const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
  await photoViewPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
    uris = photoSelectResult.photoUris;
    console.info('photoViewPicker.select to file succeed and uris are:' + uris);
  }).catch((err: BusinessError) => {
    console.error(`Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
  });

  try {
    // 获取应用文件路径
    let context = getContext() as common.UIAbilityContext;
    let cacheDir = context.cacheDir;


    if (uris.length === 0) {
      console.error('No selected image');
      return Promise.reject('No selected image');
    }

    // 构建文件对象
    let fileObj: string[] = [];
    uris.forEach(item => {
      // 新建一个本地应用文件
      let file = fs.openSync(item, fileIo.OpenMode.READ_ONLY);
      let newDir = `${cacheDir}/${file.name}`;
      fs.copyFileSync(file.fd, newDir);
      let filePath = `internal://cache/${newDir.split('cache/')[1]}`;
      uploadImages.previewImageList.push(item);
      uploadImages.fileList.push(filePath);
      fs.closeSync(file.fd); // 关闭文件描述符

    })

    return uploadImages;
  } catch (e) {
    console.error(`Invoke fileIo.open failed, code is ${e.code}, message is ${e.message}`);
    return Promise.reject(e);
  }
}


