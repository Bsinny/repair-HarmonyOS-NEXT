import {  getMoneyTotalAPI, getOrdersByConditionListAPI, getTransferOrdersDetailListAPI } from '../../api/myOrdersAPI';
import { getMyRepairListAPI } from '../../api/myRepairListAPI';
import { AllRepairTabsComp } from '../Tabs/AllRepairTabsComp';
import { OverRepairTabsComp } from '../Tabs/OverRepairTabsComp';
import { RepairerTabsComp } from '../Tabs/RepairerTabsComp';
import { WaitingRepairTabsComp } from '../Tabs/WaitingRepairTabsComp';

@Entry
@Component
//维修人员接单页面
struct RepairListTestPage {
  @StorageLink('bottomHeight') bottomHeight: number = 0
  @State repairIsDelete:number=0;
  @State curWork:number=1;
  @State repairDestory:number=1
  @State repairTransfer:number=0
  @State repairMonth:number=4
  @Provide currentRepairerIndex:number=0

  async aboutToAppear(): Promise<void> {


  }

  async GetMoneyTotalList(){
    const res=await getMoneyTotalAPI({
      repairMonth:this.repairMonth
    })
    /*AlertDialog.show({message:JSON.stringify(res,null,2)})*/
  }
  //已销单
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

  @Builder
  TabBuilder(title: string, targetIndex: number, /*selectedImg: Resource, normalImg: Resource*/) {
    Column() {
      Text(title)
        .fontSize(15)
        .fontWeight(500)
        .fontColor(this.currentRepairerIndex === targetIndex ? $r('app.color.brand') : $r('app.color.font'))
        .margin({ top: 4 })
    }
    .width('100%')
    .height(56)
    .border({ width: { top: 1 }, color: '#eee' })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentRepairerIndex = targetIndex;
    })
  }
  build() {
    Navigation() {

      Tabs({index: this.currentRepairerIndex, barPosition: BarPosition.Start }) {

        TabContent() {
          RepairerTabsComp()
        }
        .tabBar(this.TabBuilder('正在维修',0))

        TabContent() {
          //组件
          RepairerTabsComp()
        }
        .tabBar(this.TabBuilder('已销单',1))

        TabContent() {
          RepairerTabsComp()
        }
        .tabBar(this.TabBuilder('已转单',2))
        TabContent() {
          RepairerTabsComp()
        }
        .tabBar(this.TabBuilder('月维修单',3))

      }
      .barMode(BarMode.Fixed) // 默认值 Fixed
      .scrollable(false) // 限制滑动

    }
    .title('我的接单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .height('100%')
    .width('100%')
  }
}