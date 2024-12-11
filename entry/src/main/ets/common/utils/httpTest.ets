import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';
import {  TEST_URL } from '../constants';
import { promptAction, router } from '@kit.ArkUI';
import { LoginResponseInfo, LOGIN_TOKEN } from '../../api/userTestAPI';




export interface LoginResponseTestData<T>{
  code: number;
  msg: string;
  deptName?:string;
  token:string;
  /*permissions:string[]*/
  user: T;//当登录时是user，当获取列表的时候他是rows
  rows:T;

}
                                                  /*AxiosResponse<TestResponseInfo,null>  这个可以拿到   this.userDetail=res.data?.user   */
                                                  //res是axios封装的data就是axios的data，这个data应该是什么类型通过上面传的TestResponseInfo告诉他
export type AxiosTestResponseData<T = null > = AxiosResponse<LoginResponseTestData<T>,null>
                                                  //要将参数赋值给他res.data.user
                                                  /*AxiosTestResponseData<TestResponseInfo>  这个拿不到  */
                                                  //这个的解析就是AxiosResponse<LoginResponseTestData<TestResponseInfo>,null>
                                                  //res.data.result传入一个值让他知道这个接口是什么样的
                                                  //这个res.data的形式就是LoginResponseTestData,res.data.result就对了
  // 创建实例
export const axiosTestInstance = axios.create({
  baseURL: TEST_URL, // 请求基地址
  timeout: 1000 * 3 // 请求超时时间
})

// 添加请求拦截器
axiosTestInstance.interceptors.request.use((config:InternalAxiosRequestConfig) => {

  const loginToken=AppStorage.get<string>(LOGIN_TOKEN)
  if (loginToken){
    config.headers.Authorization=loginToken
  }
  console.log('interceptors request',JSON.stringify(config))

  return config;
}, (error:AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});


// 添加响应拦截器
axiosTestInstance.interceptors.response.use((response:AxiosTestResponseData/*AxiosResponse<LoginResponseInfo,null>*/)=> {
  /*AlertDialog.show({message:JSON.stringify(response,null,2)})*/
  if (response.data.code !== 200) {
    promptAction.showToast({ message: response.data.msg})
    return Promise.reject()
  }
/*  if (response.status !== 200) {
    // 把后端响应的错误信息，通过轻提示，提醒用户
    *//*promptAction.showToast({ message: response})*//*
    // 主动返回错误，避免 await 后续代码执行
    return Promise.reject()
  }*/
  promptAction.showToast({ message: '密码正确登录成功' })

  return response;


}, (error:AxiosError)=> {
  console.log('Axios Error',JSON.stringify(error))
  AlertDialog.show({message:JSON.stringify(error,null,2)})
  /*if (error.message.includes('401')){
    promptAction.showToast({message:'登录信息无效，请重新登录'})
    router.pushUrl({url:'pages/User/UserLoginPage'})
  }else if (error.message.includes('404')){
    promptAction.showToast({message:'路径错误，请检查路径是否正确'})
  }else {
    promptAction.showToast({message:'未知网络请求错误'})
  }*/
  // 对响应错误做点什么
  return Promise.reject(error);
});
