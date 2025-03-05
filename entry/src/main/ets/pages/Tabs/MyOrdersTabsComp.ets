import { router } from '@kit.ArkUI'

@Component
export struct MiddleTabsComp {
  @StorageLink('topHeight') topHeight: number = 0
  @State navigationOpacity: number = 0
  private scroller: Scroller = new Scroller()

  build() {
    // 堆叠布局
    Stack({ alignContent: Alignment.Top }) {
      // 顶部标题
      Text('报修')
        .width('100%')
        .height(56 + this.topHeight)
        .textAlign(TextAlign.Center)
        .fontSize(18)
        .backgroundColor($r('app.color.white'))
        .fontWeight(500)
        .position({ x: 0, y: 0 })
        .zIndex(1)
        .opacity(this.navigationOpacity)
        .padding({ top: this.topHeight })
      Stack({ alignContent: Alignment.BottomEnd }) {
        // 滚动容器
        Scroll(this.scroller) {
          Column({space:20}){
            Text('报修')
            Column({space:10}){
              Image($r('app.media.ic_home_shortcut_sjss'))
                .margin(30)
                .width(200)
                .height(200)
                .onClick(()=>{
                  router.pushUrl({url:'pages/Repair/RepairFormPage'})
                })
              Text('我要报修')
                .fontSize(18)
            }
            Column({space:10}){
              Image($r('app.media.ic_home_shortcut_srlj'))
                .margin(30)
                .width(200)
                .height(200)
                .onClick(()=>{
                  router.pushUrl({url:'pages/Repair/RepairListTestPage'})
                })
              Text('我的报修')
                .fontSize(18)
            }


          }





        }
        .scrollBarWidth(0)
        .align(Alignment.Top)
        .scrollable(ScrollDirection.Vertical)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .height('100%')
        .onWillScroll(() => {
          // 获取当前的滚动偏移量
          const scrollTop = this.scroller.currentOffset()
            .yOffset
          // 0 和 1 是透明度的临界点
          this.navigationOpacity = Math.max(0, Math.min(1, scrollTop / 100))
        })

        // 紧急联系人
        Image($r('app.media.ic_guard_contact'))
          .width(94)
          .aspectRatio(1)
          .margin({ bottom: 80 })
          .onClick(() => {
            // 跳转到紧急联系人页
            router.pushUrl({ url: 'pages/Guard/EmergencyContactPage' })
          })
      }
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.white'))
  }
}