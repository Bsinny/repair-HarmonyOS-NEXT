import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import { BASE_URL, LoginInfoResponse, LOGIN_INFO } from '../constants';
import { promptAction, router } from '@kit.ArkUI';


/**
 * 后端响应基本类型«result»
 */
export interface ServiceResponse<T> {
  /** 请求码，200为成功，300及300以上为请求失败 */
  code: number;
  msg: string;
  resTime: Date;
  result: T;
  tips: string;
}
export type AxiosResponseData<Result = null> = AxiosResponse<ServiceResponse<Result>, null>

// 创建实例
export const axiosInstanceDemo = axios.create({
  baseURL: BASE_URL, // 请求基地址
  timeout: 1000 * 20 // 请求超时时间
})

// 添加请求拦截器
axiosInstanceDemo.interceptors.request.use((config:InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
 /* config.headers.Authorization = 'token_dajiba'*/
  const loginInfo=AppStorage.get<LoginInfoResponse>(LOGIN_INFO)
  if (loginInfo?.accessToken) {
    config.headers.Authorization = loginInfo?.accessToken

  }



  console.log('interceptors request',JSON.stringify(config))

  return config;
}, (error:AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});


// 添加响应拦截器
axiosInstanceDemo.interceptors.response.use((response:AxiosResponseData)=> {

  if (response.data.code !== 200) {
    // 把后端响应的错误信息，通过轻提示，提醒用户
    promptAction.showToast({ message: response.data.msg })
    // 主动返回错误，避免 await 后续代码执行
    return Promise.reject(response.data.msg)
  }

  return response;


}, (error:AxiosError)=> {
  console.log('errorMessage',error.message)
  AlertDialog.show({message:JSON.stringify(error,null,2)})
  if (error.message.includes('401')){
    promptAction.showToast({message:'登录信息无效，请重新登录'})
    router.pushUrl({url:'pages/User/UserLoginPage'})
  }else if (error.message.includes('404')){
    promptAction.showToast({message:'路径错误，请检查路径是否正确'})
  }else {
    promptAction.showToast({message:'未知网络请求错误'})
  }
  // 对响应错误做点什么
  return Promise.reject(error);
});
