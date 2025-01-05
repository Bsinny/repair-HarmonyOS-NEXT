import {  getMoneyTotalAPI, getOrdersByConditionListAPI, getTransferOrdersDetailListAPI } from '../../api/myOrdersAPI';
import { getMyRepairListAPI, RepairItem } from '../../api/myRepairListAPI';
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
  @State myRepairList:RepairItem[]=[]
  @State myRepairOverList:RepairItem[]=[]
  @State MyRepairingList:RepairItem[]=[]
  @State AllRepairList:RepairItem[]=[]
  @Provide currentMyRepairIndex:number=0


//todo：现在要做复用组件
async aboutToAppear(): Promise<void> {
  await this.getMyRepairList()//获取全部数据进行页面预加载
  await this.getMyRepairOverList()//获取已完成数据
  await this.getMyRepairingList()

}
  //这个是我的接单的方法测试
  async GetMoneyTotalList(){
    const res=await getMoneyTotalAPI({
      repairMonth:this.repairMonth
    })
    /*AlertDialog.show({message:JSON.stringify(res,null,2)})*/
  }
  async GetDestroyOrdersList(){
//这个是我的接单的方法测试
    const res=await getOrdersByConditionListAPI({
      repairIsDelete:0,
      repairDestory:1,
      repairTransfer:0
    })
    /*this.destroyOrdersList=res.data.rows*/

  }

async  getMyRepairingList(){
  const res=await getMyRepairListAPI({
    repairIsDelete: 0,
    curWork: 1,
    repairDestory:0

  })
  this.MyRepairingList=res.data.rows

}
//获取已完成的报修单
async getMyRepairOverList(){
  const res=await getMyRepairListAPI({
    repairIsDelete: 0,
    curWork: 1,
    repairDestory:1

  })
  this.myRepairOverList=res.data.rows

}
async getMyRepairList(){
  const res=await getMyRepairListAPI({
    repairIsDelete: 0,
    curWork: 1,

  })
  this.myRepairList=res.data.rows

}
  @Builder
  TabBuilder(title: string, targetIndex: number,listData:RepairItem[] ) {
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
      this.AllRepairList=listData
    })
  }
  build() {
    Navigation() {

      Tabs({index: this.currentMyRepairIndex, barPosition: BarPosition.Start }) {

        TabContent() {
          AllRepairTabsComp()
        }
        .tabBar(this.TabBuilder('全部报修',0,this.myRepairList))

        TabContent() {
          AllRepairTabsComp()
          /*WaitingRepairTabsComp()*/
        }
        .tabBar(this.TabBuilder('待维修',1,this.MyRepairingList))

        TabContent() {
          AllRepairTabsComp()
          /*OverRepairTabsComp()*/
        }
        .tabBar(this.TabBuilder('已维修',2,this.myRepairOverList))


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