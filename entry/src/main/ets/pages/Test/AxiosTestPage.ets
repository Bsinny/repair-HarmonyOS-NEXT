import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { BASE_URL, LoginInfoResponse, LOGIN_INFO } from '../../common/constants'
import { promptAction } from '@kit.ArkUI';
import { axiosInstance } from '../../common/utils';

/**
 * 账号密码登录模型
 */
export interface PostUserLoginPasswdData {
  /**
   * 用户密码
   */
  passwd?: string;
  /**
   * 用户手机号
   */
  phone?: string;

}

/**
 * 数据响应模型«登录VO»
 */
export interface ServiceResponse<R> {
  /**
   * 请求码，200为成功，300及300以上为请求失败
   */
  code: number;
  /**
   * 响应信息
   */
  msg?: string;
  /**
   * 响应时间
   */
  resTime?: Date;
  result?: R;
  tips?: string;
}

/**
 * 登录VO
 */
export interface LoginInfoResult {
  /**
   * 访问token，有效期1小时
   */
  accessToken?: string;
  /**
   * 头像
   */
  avatar?: string;
  /**
   * 昵称
   */
  nickname?: string;
  /**
   * 续期token，有效期30天
   */
  renewalToken?: string;
}

interface GetUserMeResponse{
  avatar?:string
  nickname?:string
}
//类型别名，方便调用和代码可读性
type AxiosResponseData<T = null> = AxiosResponse<ServiceResponse<T>,null>
@Entry
@Component
struct AxiosTestPage {
  @State avatar:string=''
  @StorageLink(LOGIN_INFO) loginInfo:LoginInfoResponse={}
  build() {
    Navigation() {
      Scroll() {
        Column({ space: 10 }) {
          Button('泛型参数-约束请求参数')
            .onClick(async ()=>{
              //第二个泛型参数是限定后台返回值参数的类型
              //第三个泛型参数是限定请求体(data)参数的类型
              const res=await axios.post<null,AxiosResponseData<LoginInfoResult>,PostUserLoginPasswdData>(BASE_URL+'/user/login/passwd',
                {
                  phone:'120666666666',

                  passwd:'888itcast.CN764%...'
                }

              )
              //promptAction.showToast({message:'登录请求发送成功'})
              //AlertDialog.show({message:JSON.stringify(res,null,2)})
              if (res.data.code===200){

                this.avatar=res.data.result?.avatar as string
                //这行代码中的？代表不确定是否一定不为空时的替补，这样就不会报空值异常undefined
                //可选链操作符允许你安全地访问深层嵌套的对象属性，而不用担心中间的任何层级可能为 undefined 或 null
                //如果 res.data.result 为 undefined 或 null，表达式 res.data.result?.avatar 会直接返回 undefined，而不会抛出错误。
                //as 关键字在这里用于类型断言，告诉 TypeScript 编译器你确信 res.data.result?.avatar 的值是一个字符串。
              }else {
                promptAction.showToast({message:res.data.msg?.toString()})
              }



            })
          Text(JSON.stringify(this.loginInfo))
          Image(this.avatar)
            .width(200)
          Button('创建 axios 实例')
            .onClick(async ()=>{
              //创建axios实例
              const axiosInstance=axios.create({
                baseURL:BASE_URL,
                timeout:20*1000
              })
              // 添加请求拦截器
              axiosInstance.interceptors.request.use((config:InternalAxiosRequestConfig) => {
                // 对请求数据做点什么
                config.headers.Authorization = 'token_dajiba'
                console.log('interceptors request',JSON.stringify(config))

                return config;
              }, (error:AxiosError) => {
                // 对请求错误做些什么
                return Promise.reject(error);
              });


              // 添加响应拦截器
              axiosInstance.interceptors.response.use((response:AxiosResponse)=> {
                // 对响应数据做点什么
                return response;
              }, (error:AxiosError)=> {
                // 对响应错误做点什么
                return Promise.reject(error);
              });
              //-------------------------------
              await axiosInstance.post<null,AxiosResponseData<LoginInfoResult>,PostUserLoginPasswdData>(
                '/user/login/passwd',
              {

                phone:'120666666666',

                passwd:'888itcast.CN764%...'
              }
              )


            })
          Divider()
            .strokeWidth(1)
          Button('请求工具-发送登录请求')
            .onClick(async ()=>{
              const res=await axiosInstance.post <null,AxiosResponseData<LoginInfoResponse>,PostUserLoginPasswdData>(
                '/user/login/passwd',
                {phone:'120666666666',
                 passwd:'888itcast.CN764%...'}
              )
              this.avatar=res.data.result?.avatar as string
              if (res.data.result){
                this.loginInfo=res.data.result
              }


          })
          Button('请求工具-发送获取我的用户信息')
            .onClick(async()=>{

                  const res=await axiosInstance.get<null,AxiosResponseData<GetUserMeResponse>>('/user/me'
)
                  this.avatar=res.data.result?.avatar as string


              }
            )

        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%')
      .height('100%')
    }
    .title('axios进阶用法')
    .titleMode(NavigationTitleMode.Mini)
  }
}