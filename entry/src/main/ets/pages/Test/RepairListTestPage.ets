import {  getMoneyTotalAPI, getOrdersByConditionListAPI, getTransferOrdersDetailListAPI } from '../../api/myOrdersAPI';
import { getMyRepairListAPI } from '../../api/myRepairListAPI';
import { AllRepairTabsComp } from '../Tabs/AllRepairTabsComp';
import { OverRepairTabsComp } from '../Tabs/OverRepairTabsComp';
import { WaitingRepairTabsComp } from '../Tabs/WaitingRepairTabsComp';

@Entry
@Component
//我的报修
struct RepairListTestPage {
  @StorageLink('bottomHeight') bottomHeight: number = 0
  @State repairIsDelete:number=0;
  @State curWork:number=1;
  @State repairDestory:number=1
  @State repairTransfer:number=0
  @State repairMonth:number=4
  @Provide currentMyRepairIndex:number=0
//todo：现在要做复用组件
async aboutToAppear(): Promise<void> {
  await this.GetMyRepairList()

}

  async GetMoneyTotalList(){
    const res=await getMoneyTotalAPI({
      repairMonth:this.repairMonth
    })
    /*AlertDialog.show({message:JSON.stringify(res,null,2)})*/
  }
  async GetDeleteOrdersList(){
    this.repairIsDelete=0
    this.repairDestory=1
    this.repairTransfer=0

    const res=await getOrdersByConditionListAPI({
      repairIsDelete:this.repairIsDelete,
      repairDestory:this.repairDestory,
      repairTransfer:this.repairTransfer
    })

  }
async GetMyRepairList(){
  const res=await getMyRepairListAPI({
    repairIsDelete: this.repairIsDelete,
    curWork: this.curWork,

  })

}
  @Builder
  TabBuilder(title: string, targetIndex: number, /*selectedImg: Resource, normalImg: Resource*/) {
    Column() {
      Text(title)
        .fontSize(15)
        .fontWeight(500)
        .fontColor(this.currentMyRepairIndex === targetIndex ? $r('app.color.brand') : $r('app.color.font'))
        .margin({ top: 4 })
    }
    .width('100%')
    .height(56)
    .border({ width: { top: 1 }, color: '#eee' })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentMyRepairIndex = targetIndex;
    })
  }
  build() {
    Navigation() {

      Tabs({index: this.currentMyRepairIndex, barPosition: BarPosition.Start }) {

        TabContent() {
          AllRepairTabsComp()
        }
        .tabBar(this.TabBuilder('全部报修',0))

        TabContent() {
          AllRepairTabsComp()
          /*WaitingRepairTabsComp()*/
        }
        .tabBar(this.TabBuilder('待报修',1))

        TabContent() {
          AllRepairTabsComp()
          /*OverRepairTabsComp()*/
        }
        .tabBar(this.TabBuilder('已维修',2))


      }
      .barMode(BarMode.Fixed) // 默认值 Fixed
      .scrollable(false) // 限制滑动

    }
    .title('我的报修')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .height('100%')
    .width('100%')
  }
}