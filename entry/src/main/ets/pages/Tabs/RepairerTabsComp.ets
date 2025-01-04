
import { LOGIN_TOKEN,UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI'
import { getMyRepairListAPI, RepairItem, repImgItem } from '../../api/myRepairListAPI'
import dayjs from 'dayjs';
import { API_BASE_URL } from '../../common/constants';
import { getOrdersByConditionListAPI } from '../../api/myOrdersAPI';


@Component
export struct RepairerTabsComp {
  // 用户信息持久化
  @StorageLink(USER_INFO) userInfo: UserInfo = {} as UserInfo;
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_ROLE) role:string =''
  // @Provide 装饰器和 @Consume 装饰器：与后代组件双向同步
  @Consume @Watch('onTabsChange') currentRepairerIndex: number
  @State repairIsDelete:number=0;
  @State curWork:number=1;
  @State listLength:number=1000
  @State repairingOrdersList:RepairItem[]=[]
  @State testList:string[]=['哈哈','喜喜','露露']
  @State isVisible: boolean = false;
  @State selectedRepairItem: RepairItem | null = null;
  scroller: Scroller = new Scroller();
  //当tabs发生变化的时候
  async onTabsChange(){
    if (this.currentRepairerIndex == 0) {
      //正在维修
      this.GetRepairingOrdersList()

    }else if (this.currentRepairerIndex == 1){

    }else if (this.currentRepairerIndex == 2){

    }else if (this.currentRepairerIndex == 3){

    }

  }

  async aboutToAppear() :Promise<void>{
    this.GetRepairingOrdersList()

  }
  async showRepairDetail(item: RepairItem) {
    this.selectedRepairItem = item;
    this.isVisible = true;

  }
//获取正在维修
  async GetRepairingOrdersList(){
    const res=await getOrdersByConditionListAPI({
      repairIsDelete:0,
      repairDestory:0,
      repairTransfer:0
    })
    this.repairingOrdersList=res.data.rows




  }
  // 半模态转场
  @Builder
  SheetBuilder() {
    Column({space:10}){
      Text('报修详情')
        .align(Alignment.Center)
        .fontSize(16)
        .margin(10)

      Swiper() {
        ForEach(this.selectedRepairItem?.appImgList,(item:repImgItem)=>{
          Image(`${API_BASE_URL}/api/repair/repimg/loadImg/${item.appimgId}`)
            .width('90%')
            .height('100%')


        })

      }
      .margin(10)
      .width('95%')
      .height(200)
      .loop(true)
      .autoPlay(true)
      .interval(1000)

      Text(`报修单号:  ${this.selectedRepairItem?.repairNo}`).align(Alignment.Start)
      Text(`报修用户:  ${this.selectedRepairItem?.repairName}`).align(Alignment.Start)
      Text(`报修内容:  ${this.selectedRepairItem?.repairContent}`).align(Alignment.Start)
      Text(`报修地点:  ${this.selectedRepairItem?.repairAddress}`).align(Alignment.Start)
      Text(`报修类型:  ${this.selectedRepairItem?.repType.repairType}`).align(Alignment.Start)
      Button('确定')
        .onClick(()=>{
          this.isVisible=false
        })


    }}


  build() {
    Scroll(this.scroller) {
      Column(){        /*Text(`当前数据长度: ${this.listLength}`)*/
        ForEach(this.repairingOrdersList,(item:RepairItem)=>{
          Column({space:10}){
            Row({space:10}){
              Text('报修类型:')
              Text(item.repType?.repairType|| '未知类型')
            }.margin(10)
            Divider().strokeWidth(3).color('#F1F3F5')
            Row({space:10}){
              Text('报修地点:')
                .fontSize(16)
                .fontWeight(500)
              Text(item.repairAddress)
                .fontSize(16)
                .fontWeight(500)

            }.margin(5)
            Row({space:10}){
              Text('报修时间:')
                .fontSize(16)
                .fontWeight(500)
              Text(dayjs(item.repairExpectTime).format('YYYY-MM-DD'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)
            Row({space:10}){
              Text('报修单价:')
                .fontSize(16)
                .fontWeight(500)
              Text(`${item?.repairMoney}￥`)
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)
            Row({space:10}){
              Text('操作:')
                .fontSize(16)
                .fontWeight(500)
              Button('转单')
              Button('销单').backgroundColor(0xF55A42)



            }.margin(5)
            .height(30)
          }
          .onClick(()=>{
            this.showRepairDetail(item)

          })

          .margin(5)
          .width('95%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor($r('app.color.background'))
          .borderStyle(BorderStyle.Solid).borderWidth(2).borderColor(0xAFEEEE).borderRadius(10)
          .align(Alignment.Center)

        })}

    }
    .bindSheet($$this.isVisible, this.SheetBuilder(), {
      // 半模态转场,屏幕高度一半，无法修改关闭图标样式
      detents: [SheetSize.MEDIUM],
      backgroundColor: $r('app.color.white')
    })
    .width('100%')
    .backgroundColor(0xDCDCDC)
    .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
    .scrollBar(BarState.On) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹

  }}