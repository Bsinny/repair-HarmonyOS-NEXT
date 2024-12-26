import {  getMoneyTotalAPI, getOrdersByConditionListAPI, getTransferOrdersDetailListAPI } from '../../api/myOrdersAPI';
import { getMyRepairListAPI } from '../../api/myRepairListAPI';

@Entry
@Component
struct RepairListTestPage {
  @State message: string = 'Hello World';
  @State repairIsDelete:number=0;
  @State curWork:number=1;
  @State repairDestory:number=1
  @State repairTransfer:number=0
  @State repairMonth:number=4
async aboutToAppear(): Promise<void> {







}
//todo:这个请求路径有问题
  async GetMoneyTotalList(){
    const res=await getMoneyTotalAPI({
      repairMonth:this.repairMonth
    })
    AlertDialog.show({message:JSON.stringify(res,null,2)})
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
    AlertDialog.show({message:JSON.stringify(res,null,2)})
  }
async GetMyRepairList(){
  const res=await getMyRepairListAPI({
    repairIsDelete: this.repairIsDelete,
    curWork: this.curWork,
    repairDestory: this.repairDestory
  })
  AlertDialog.show({message:JSON.stringify(res,null,2)})
}

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('RepairListTestPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      Button('获取数据').onClick(async ()=>{
        const res=await getTransferOrdersDetailListAPI()
        AlertDialog.show({message:JSON.stringify(res,null,2)})

      })
    }
    .height('100%')
    .width('100%')
  }
}