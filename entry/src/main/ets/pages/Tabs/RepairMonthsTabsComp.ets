
import { LOGIN_TOKEN,UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI'
import { getMyRepairListAPI, RepairItem, repImgItem } from '../../api/myRepairListAPI'
import dayjs from 'dayjs';
import { API_BASE_URL } from '../../common/constants';
import {
  getMoneyTotalAPI,
  getRepairTotalAPI,
  getTransferOrdersDetailListAPI, moneyTotalItem, repTransferItem } from '../../api/myOrdersAPI';
import { promptAction } from '@kit.ArkUI';


@Component
  //所有报修组件
export struct RepairMonthsTabsComp {

  // 用户信息持久化
  @StorageLink(USER_INFO) userInfo: UserInfo = {} as UserInfo;
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_ROLE) role:string =''
  // @Provide 装饰器和 @Consume 装饰器：与后代组件双向同步
  @Consume @Watch('onTabsChange') currentRepairerIndex: number
  @State repairTotalList:RepairItem[]=[]
  @State repairMonthsList:string[]=['1','2','3','4','5','6','7','8','9','10','11','12']
  @State selectedMonth:number=0
  @State moneyTotalData:moneyTotalItem|null=null



  scroller: Scroller = new Scroller();
  //当tabs发生变化的时候
  async onTabsChange(){
    if (this.currentRepairerIndex == 3) {



    }
  }

  async aboutToAppear() :Promise<void>{

  }
  async getMoneyTotalList(){
    const res=await getMoneyTotalAPI({
      repairMonth:this.selectedMonth
    })

    this.moneyTotalData=res.data.data[0]
  }
  async getRepairTotalList(){
    const res=await getRepairTotalAPI({
      repairMonth:this.selectedMonth
    })
    this.repairTotalList=res.data.rows
  }

  private updateSelectedMonths(index: number): void {
    if (index >= 0 && index < this.repairMonthsList.length) {

      this.selectedMonth = index+1; // 更新为实际的索引

    } else {
      console.error('Invalid index provided');
    }
  }
  build() {
    Stack(){


      if (this.repairTotalList.length>0){
      Scroll(this.scroller) {
        Column(){
          ForEach(this.repairTotalList,(item:RepairItem,index:number)=> {
            Badge({
              count:index+1,
              position:BadgePosition.RightTop,
              style: {fontSize:20, badgeSize: 25, badgeColor: '#FA2A2D' }
            }) {
            Column({ space: 10 }) {
              Row({ space: 10 }) {
                Text('报修类型:')
                if (item.repairType === 1) {
                  Text('网络设备')
                } else if (item.repairType === 2) {
                  Text('水电类')
                } else if (item.repairType === 3) {
                  Text('家具类')
                } else if (item.repairType === 4) {
                  Text('办公室设备')
                } else if (item.repairType === 5) {
                  Text('教学电子')
                } else if (item.repairType === 6) {
                  Text('教学电子')
                } else if (item.repairType === 7) {
                  Text('电器类')
                } else if (item.repairType === 8) {
                  Text('木材类')
                } else {
                  Text('未知类型')
                }

              }.margin(10)

              Divider().strokeWidth(3).color('#F1F3F5')
              Row({ space: 10 }) {
                Text('报修地点:')
                  .fontSize(16)
                  .fontWeight(500)
                Text(item.repairAddress)
                  .fontSize(16)
                  .fontWeight(500)

              }.margin(5)

              Row({ space: 10 }) {
                Text('报修内容:')
                  .fontSize(16)
                  .fontWeight(500)
                Text(item.repairContent)
                  .fontSize(16)
                  .fontWeight(500)

              }.margin(5)

              Row({ space: 10 }) {
                Text('销单时间:')
                  .fontSize(16)
                  .fontWeight(500)
                Text(dayjs(item.repairDestoryTime).format('YYYY-MM-DD-HH-SS'))
                  .fontSize(16)
                  .fontWeight(500)


              }.margin(5)

              Row({ space: 10 }) {
                Text('报修单价:')
                  .fontSize(16)
                  .fontWeight(500)
                Text(item.repairMoney?.toString() + '￥')
                  .fontSize(16)
                  .fontWeight(500)
                  .fontColor($r('app.color.danger'))

              }.margin(5)

            }
            /*.position({y:'80%'})*/
            .margin(8)
            .width('95%')
            .alignItems(HorizontalAlign.Start)
            .backgroundColor($r('app.color.background'))
            .borderStyle(BorderStyle.Solid)
            .borderWidth(2)
            .borderColor(0xAFEEEE)
            .borderRadius(10)
            .align(Alignment.Center)
          }
          },)}

      }
      .position({y:'15%'})
      .height('90%')
      .zIndex(2)
      .width('100%')
      .backgroundColor(0xFFFAFA)
      .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
      .scrollBar(BarState.Auto) // 滚动条常驻显示
      .scrollBarColor(Color.Gray) // 滚动条颜色
      .scrollBarWidth(8) // 滚动条宽度
      .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
    }else {
      Column(){
        Text('————暂无数据————')
          .fontColor($r('app.color.font_sub'))
      }
      .position({y:'50%'})
        .width('100%')
        .height('80%')




    }
      Column(){

        Row(){
          Text('工作月份:')
            .layoutWeight(1)


          Text(this.selectedMonth.toString()+'月')
            .textAlign(TextAlign.Center)
            .layoutWeight(2)

            .margin(20)
            .onClick(() => {
              TextPickerDialog.show({
                range: this.repairMonthsList.map(item=>item),
                selected: this.selectedMonth, // 直接使用当前选中的索引
                disappearTextStyle: { color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } },
                textStyle: { color: Color.Black, font: { size: 20, weight: FontWeight.Normal } },
                selectedTextStyle: { color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } },
                onAccept: (values: TextPickerResult) => {
                  this.updateSelectedMonths(values.index as number);
                  promptAction.showToast({ message: `当前选择的月份是${this.selectedMonth}` })
                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()");
                },
              });
            })
          Button('搜索')
            .layoutWeight(1)
            .backgroundColor(Color.Green)
            .onClick(()=> {
              this.getMoneyTotalList()
              this.getRepairTotalList()
            })



        }

        if (this.moneyTotalData!=null)
        Column(){
          Text(`亲爱的${this.userInfo.nickName},您在${this.moneyTotalData.repairMonth}月份的总维修金额为：￥${this.moneyTotalData.RepairMoneyTotal}`)
          Text(`亲爱的${this.userInfo.nickName},您在${this.moneyTotalData.repairMonth}月份的总完成订单数为：￥${this.moneyTotalData.RepairOrderTotal}`)
        }

      }
      .width('100%')
      .height('100%')






    }


  }
}