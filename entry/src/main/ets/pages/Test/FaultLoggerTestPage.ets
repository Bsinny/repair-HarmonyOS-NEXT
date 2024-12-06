import { FaultLogger } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct FaultLogTestPage {

  build() {
    Navigation() {
      Scroll() {
        Column({ space: 10 }) {
          Button('获取故障日志')
            .onClick(async () => {
              // 获取错误日志
              const list = await FaultLogger.query(FaultLogger.FaultType.JS_CRASH)
              AlertDialog.show({ message: JSON.stringify(list, null, 2) })
            })

          Button('抛出异常错误')
            .onClick(() => {
              // throw 抛出异常错误，会导致程序闪退
              throw new Error('my error')
            })
        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%')
      .height('100%')
    }
    .title('故障日志')
    .titleMode(NavigationTitleMode.Mini)
  }
}