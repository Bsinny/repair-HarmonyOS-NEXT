import { router } from '@kit.ArkUI'
import { LoginResponseInfo, loginTestInfo, LOGIN_TOKEN } from '../../api/userInfoAPI'
import { CellRowArrowComp, DividerComp } from '../../common/components'
import { LOGIN_INFO, LoginInfoResponse } from '../../common/constants'

@Entry
@Component
struct SettingsIndexPage {
  // 用户信息持久化
  @StorageLink(LOGIN_INFO) loginInfo: LoginInfoResponse = {}
  @StorageLink(LOGIN_TOKEN) loginToken: LoginResponseInfo = {
  }
  @State isWifiNotification: boolean = true
  @State userExperienceImprovementPlan: boolean = true
  logout(){
    this.loginInfo={}
    this.loginToken={}
    router.back()
  }
  build() {
    Navigation() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          CellRowArrowComp({ title: '个人信息' })
            .onClick(() => {
              router.pushUrl({ url: 'pages/User/UserInfoPage' })
            })
          CellRowArrowComp({ title: '权限管理' })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Settings/SettingsPermissionPage' })
            })
          DividerComp()
        }
        .height('100%')

        Column({ space: 10 }) {
          Button('退出登录')
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.brand'))
            .borderRadius(10)
            .width('100%')
            .onClick(() => {
              this.logout()
              // TODO: 退出登录
            })
          Button('测试页面入口')
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.brand'))
            .borderRadius(10)
            .width('100%')
            .onClick(() => {
              router.pushUrl({ url: 'pages/Test/TestIndexPage' })
            })
        }
        .padding({ left: 20, right: 20, bottom: 30 })
      }
    }
    .title('设置')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
  }
}