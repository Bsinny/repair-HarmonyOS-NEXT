import { FormData } from '@ohos/axios';
import { axiosInstanceDemo, AxiosResponseData } from '../common/utils/http';


/** 上传结果 */
export interface postUploadFormDataResponse {
  /** 上传图片地址 */
  url: string;
}

/* 文件上传 */
export function postUploadFormData(data: FormData) {
  return axiosInstanceDemo.post
  <null, AxiosResponseData<postUploadFormDataResponse>, FormData>
  (
    '/upload',
    data,
    {
      headers: { 'Content-Type': 'multipart/form-data' },
      context: getContext(),
    })
}
