import axios, { AxiosError, AxiosProgressEvent, AxiosResponse } from '@ohos/axios'
import { FormData } from '@ohos/axios'

let formData = new FormData()
formData.append('file', 'internal://cache/blue.jpg')
// formData.append('file', cacheDir + '/hello.txt'); uri支持传入沙箱路径

// 发送请求
axios.post<string, AxiosResponse<string>, FormData>('https://www.xxx.com/upload', formData, {
  headers: { 'Content-Type': 'multipart/form-data' },
  context: getContext(this),
  onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
    console.info(progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) + '%' : '0%');
  },
}).then((res: AxiosResponse<string>) => {
  console.info("result" + JSON.stringify(res.data));
}).catch((err: AxiosError) => {
  console.error("error:" + JSON.stringify(err));
})