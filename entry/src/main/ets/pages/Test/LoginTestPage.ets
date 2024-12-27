import { BizType, postCodeGraphicCheckAPI, postCodeSmsSendAPI, postUserLoginVerifyCodeAPI } from '../../api'
import {  LOGIN_INFO, LoginInfoResponse } from '../../common/constants'
import { promptAction, router } from '@kit.ArkUI'
import { getTestUserInfoAPI, LoginResponseInfo, LOGIN_TOKEN, postTestUserLoginPasswdAPI,
  TestResponseInfo,
  UserInfo,
  USER_INFO } from '../../api/userInfoAPI'


@Entry
@Component
struct LoginTestPage {
  // 用户信息持久化
  @StorageLink(LOGIN_INFO) loginInfo: LoginInfoResponse = {}
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_INFO) userDetail:UserInfo = {} as UserInfo;

  // 手机号
  @State phoneNumber: string = '131234567890'
  @State username: string ='201809512626'
  @State password:string='123456'
  // 短信验证码
  @State verifyCode: string = ''
  // 显示半模态转场结构
  @State isShowSheet: boolean = false
  // 用于更新验证码的时间戳
  @State timestamp: number = Date.now()
  // 图形验证码
  @State graphicCode: string = ''
  // 倒计时数值
  @State count: number = 0
  // 倒计时定时器
  private intervalID: number = -1

  async getUserDetail(){
    const res=await getTestUserInfoAPI()
   /* AlertDialog.show({message:JSON.stringify(res,null,2)})*/
    //原来没有修改过的返回参数
    /*this.userDetail=res.data.result*/
    //修改后的返回参数
    //返回体传user就行了，再改一下这个userDetail的类型就可以了
    /*this.userDetail=res.data?.user*//*res.data?.result*/
    this.userDetail=res.data.user
    // AlertDialog.show({message:JSON.stringify(this.userDetail.dept?.deptId,null,2)})
    const role=this.userDetail?.roles[0].roleKey
    /*AlertDialog.show({message:JSON.stringify(this.userDetail.roles?.length,null,2)})*/


/*    console.log('jibada',JSON.stringify(res ,null,2))
    AlertDialog.show({message:JSON.stringify(this.userDetail,null,2)})*/

    /*AlertDialog.show({message:JSON.stringify(res.data.user,null,2)})*/
    /*AlertDialog.show({message:'欢迎你'+this.userDetail.user?.nickName+'登录时间为:'+this.userDetail.user?.loginDate})*/

  }
  clearToken(){
    this.loginToken=''
    promptAction.showToast({ message: '退出登录成功' })
  }
  async onTestLoginSubmit(){
    const res = await postTestUserLoginPasswdAPI({
      username:this.username,
      password:this.password
    })
    /*AlertDialog.show({message:res.data.msg})*/
    this.loginToken=res.data.token
    console.log('tokenValue',JSON.stringify(res.data,null,2))
    this.getUserDetail()
    router.back()
    /*AlertDialog.show({message:JSON.stringify(res,null,2)})*/
  }

  async onLoginSubmit(){
    const res=await postUserLoginVerifyCodeAPI({
      phone:this.phoneNumber,
      verifyCode:this.verifyCode
    })
    this.loginInfo=res.data.result
    router.back()
    promptAction.showToast({ message: '登录成功' })
  }

  async onSendSmsCode() {
    // 1. 发送短信验证码
    await postCodeSmsSendAPI({
      bizType: BizType.PhoneLogin,
      phone: this.phoneNumber,
    })
    // 2. 界面更新倒计时
    this.startCountDown()
    // 3. 用户轻提示
    promptAction.showToast({ message: `短信已发送到${this.phoneNumber}上，请注意查收` })
  }
  startCountDown() {
    // 初始化倒计时秒数
    this.count = 120
    // 关闭旧的定时器，开启新的定时器
    clearInterval(this.intervalID)
    this.intervalID = setInterval(() => {
      this.count--
      // 倒计时结束，清理定时器
      if (this.count <= 0) {
        clearInterval(this.intervalID)
      }
    }, 1000)
  }// 页面销毁，停止倒计时，释放资源
  aboutToDisappear() {
    clearInterval(this.intervalID)
  }
  async onGraphicCodeSubmit(){
    try {
      //把手机号，图形验证码发给后端
      await postCodeGraphicCheckAPI({
        bizType:BizType.PhoneLogin,
        phone:this.phoneNumber,
        verifyCode:this.graphicCode
      })
      this.isShowSheet=false
      this.graphicCode=''
      /*this.onSendCode()*/
      this.onSendSmsCode()


    } catch (error) {
      this.timestamp = Date.now()
    }
  }
  build() {
    Navigation() {
      Column() {
        Row({ space: 30 }) {
          Text('账号密码登录')
            .fontSize(22)
            .fontWeight(500)
            .fontColor($r('app.color.font'))
        }
        .width('100%')

        Column({ space: 10 }) {
          TextInput({ placeholder: '请输入帐号', text: this.username })
            .type(InputType.Normal)
            .maxLength(12)
            .fontSize(14)
            .height(50)
            .backgroundColor(Color.Transparent)
            .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
            .padding(0)
            .onChange((value) => {
              this.username = value
            })
          TextInput({ placeholder: '请输入密码', text: this.password })
            .type(InputType.Password)
            .maxLength(12)
            .fontSize(14)
            .height(50)
            .backgroundColor(Color.Transparent)
            .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
            .padding(0)
            .onChange((value) => {
              this.password = value
            })

        }
        .margin({ top: 40, bottom: 40 })

        Column({ space: 20 }) {
          Button('登录')
            .backgroundColor($r('app.color.brand'))
            .height(42)
            .width('100%')
            .enabled(this.username.length > 0 && this.password.length > 0)
            .onClick(() => {
              // TODO:登录表单提交
              this.onTestLoginSubmit()
            })
          Button('跳转注册')
            .onClick(()=>{
              router.pushUrl({ url: 'pages/User/UserRegisterPage' })
          })
          /*Button('退出登录')
            .backgroundColor($r('app.color.brand'))
            .height(42)
            .width('100%')
            .enabled(this.username.length > 0 && this.password.length > 0)
            .onClick(() => {
              this.clearToken()
            })
          Button('获取用户信息')
            .backgroundColor($r('app.color.brand'))
            .height(42)
            .width('100%')
            .enabled(this.username.length > 0 && this.password.length > 0)
            .onClick(() => {
              this.getUserDetail()
            })*/
        }
      }
      .padding({ left: 30, right: 30, top: 30 })
      .width('100%')
      .height('100%')
    }
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)

  }
}

