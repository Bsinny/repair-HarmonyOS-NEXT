import axios, { AxiosError, AxiosProgressEvent, AxiosResponse } from '@ohos/axios'
import { FormData } from '@ohos/axios'
import fs from '@ohos.file.fs';

/*// ArrayBuffer
let formData = new FormData()
let cacheDir = getContext(this).cacheDir
try {
  // 写入
  let path = cacheDir + '/hello.txt';
  let file = fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
  fs.writeSync(file.fd, "hello, world"); // 以同步方法将数据写入文件
  fs.fsyncSync(file.fd); // 以同步方法同步文件数据。
  fs.closeSync(file.fd);

  // 读取
  let file2 = fs.openSync(path, 0o2);
  let stat = fs.lstatSync(path);
  let buf2 = new ArrayBuffer(stat.size);
  fs.readSync(file2.fd, buf2); // 以同步方法从流文件读取数据。
  fs.fsyncSync(file2.fd);
  fs.closeSync(file2.fd);

  formData.append('file', buf2);
  // formData.append('file', buf2, { filename: 'text.txt', type: 'text/plain'}); 设置多部分表单数据的数据名称和数据类型类型
} catch (err) {
  console.info('err:' + JSON.stringify(err));
}
// 发送请求
axios.post<string, AxiosResponse<string>, FormData>(this.uploadUrl, formData, {
  headers: { 'Content-Type': 'multipart/form-data' },
  context: getContext(this),
  onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
    console.info(progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) + '%' : '0%');
  },
}).then((res: AxiosResponse) => {
  console.info("result" + JSON.stringify(res.data));
}).catch((error: AxiosError) => {
  console.error("error:" + JSON.stringify(error));
})*/

import { UploadImages } from '../../pages/models/commonModels';
import { postApplyPhoto } from '../../api/getTypeAPI';

async function uploadImages(uploadImages: UploadImages) {
  try {
    const formData = new FormData();

    for (let i = 0; i < uploadImages.fileList.length; i++) {
      const filePath = uploadImages.fileList[i];

      // 直接添加 URI 到 FormData
      formData.append(`file${i}`, filePath);
    }

    // 发送请求
    const response = await postApplyPhoto(formData);
    console.info("Upload result: " + JSON.stringify(response.data));
    return response.data;
  } catch (error) {
    console.error("Upload error: " + JSON.stringify(error));
    // throw error;
    return
  }
}