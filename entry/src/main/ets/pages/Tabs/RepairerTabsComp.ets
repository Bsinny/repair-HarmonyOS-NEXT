
import { LOGIN_TOKEN,UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI'
import { getMyRepairListAPI, RepairItem, repImgItem } from '../../api/myRepairListAPI'
import dayjs from 'dayjs';
import { API_BASE_URL } from '../../common/constants';
import { getOrdersByConditionListAPI } from '../../api/myOrdersAPI';
import { promptAction } from '@kit.ArkUI';

//为了页面渲染的速度决定还是分页比较好
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
  @State repairDestory:number=0
  scroller: Scroller = new Scroller();
  //当tabs发生变化的时候
  async onTabsChange(){
    if (this.currentRepairerIndex == 0) {
      //正在维修
      this.repairDestory=0

    }/*else if (this.currentRepairerIndex == 1){
      //已销单
      this.repairDestory=1
    }*/
    this.GetRepairingOrdersList()
    /*else if (this.currentRepairerIndex == 2){

    }else if (this.currentRepairerIndex == 3){

    }*/

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
      repairDestory:this.repairDestory,
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
                .fontColor($r('app.color.danger'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)

            if (item.repairDestory===1) {
              //已销单
              Row({space:10}){
                Text('评论状态:')
                  .fontSize(16)
                  .fontWeight(500)
                if (item.repairComment === 0) {
                  //未评论
                  Button('未评论')
                    .border({color:$r('app.color.warning'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                }else {
                  Button('已评论')
                    .border({color:$r('app.color.success'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                }
              }.margin(5)
              Row({space:10}){
                Text('维修状态:')
                  .fontSize(16)
                  .fontWeight(500)
                //0.已修复、1.已换新、2.无法修复 3.未修复、4.等待修复
                if (item.repairedState === 0) {
                  //未评论
                  Button('已修复')
                    .border({color:$r('app.color.success'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)
                }else if (item.repairedState === 1){
                  Button('已换新')
                    .border({color:$r('app.color.success'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                }else if (item.repairedState === 2){
                  Button('无法修复')
                    .border({color:$r('app.color.danger'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.danger'))
                    .fontColor($r('app.color.danger'))
                    .fontWeight(500)
                }else if (item.repairedState === 3){
                  Button('未修复')
                    .border({color:$r('app.color.warning'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                }else {
                  Button('等待修复')
                    .border({color:$r('app.color.font'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.font'))
                    .fontColor($r('app.color.font'))
                    .fontWeight(500)
                }
              }.margin(5)

            //已销单显示评论状态和维修状态
            }else {

                Row({space:10}){
                  Text('操作:')
                    .fontSize(16)
                    .fontWeight(500)
                  Button('转单')
                    .border({color:$r('app.color.success'),width:2})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)
                    .onClick(()=>{
                      promptAction.showDialog({
                        alignment:DialogAlignment.Center,
                        title:'选择转单部门',
                        message:'选择转单部门',
                        buttons:[
                          {text:'取消',color:$r('app.color.danger'),},
                          {text:'确定',color:$r('app.color.success')}
                        ]
                      }).then((res)=>{
                        if (res.index === 1) {


                        }
                      })
                    })
                  Button('销单')
                    .border({color:$r('app.color.brand_light'),width:2})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.brand_light'))
                    .fontColor($r('app.color.brand_light'))
                    .fontWeight(500)
                    .onClick(()=>{
                      promptAction.showDialog({
                        alignment:DialogAlignment.Center,
                        title:'选择派单人员',
                        message:'选择派单人员',
                        buttons:[
                          {text:'取消',color:$r('app.color.danger'),},
                          {text:'确定',color:$r('app.color.success')}
                        ]
                      }).then((res)=>{
                        if (res.index === 1) {


                        }
                      })
                    })
                }.margin(5)
                .height(30)

            }

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
    .scrollBar(BarState.Auto) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(8) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹

  }
}
@Component
export struct RepairerOverTabsComp {
  // 用户信息持久化
  @StorageLink(USER_INFO) userInfo: UserInfo = {} as UserInfo;
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_ROLE) role:string =''
  // @Provide 装饰器和 @Consume 装饰器：与后代组件双向同步
  @Consume @Watch('onTabsChange') currentRepairerIndex: number
  @State repairIsDelete:number=0;
  @State curWork:number=1;
  @State listLength:number=1000
  @State repairOverOrdersList:RepairItem[]=[]
  @State testList:string[]=['哈哈','喜喜','露露']
  @State isVisible: boolean = false;
  @State selectedRepairItem: RepairItem | null = null;
  @State repairDestory:number=1
  scroller: Scroller = new Scroller();
  //当tabs发生变化的时候
  async onTabsChange(){
/*    if (this.currentRepairerIndex == 0) {
      //正在维修
      this.repairDestory=0

    }else*/ if (this.currentRepairerIndex == 1){
      //已销单
      this.repairDestory=1
    }
    this.GetRepairOverOrdersList()
    /*else if (this.currentRepairerIndex == 2){

    }else if (this.currentRepairerIndex == 3){

    }*/

  }

  async aboutToAppear() :Promise<void>{
    this.GetRepairOverOrdersList()

  }
  async showRepairDetail(item: RepairItem) {
    this.selectedRepairItem = item;
    this.isVisible = true;

  }
  //获取正在维修
  async GetRepairOverOrdersList(){
    const res=await getOrdersByConditionListAPI({
      repairIsDelete:0,
      repairDestory:this.repairDestory,
      repairTransfer:0
    })
    this.repairOverOrdersList=res.data.rows




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
      Column(){
        ForEach(this.repairOverOrdersList,(item:RepairItem)=>{
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
                .fontColor($r('app.color.danger'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)

            if (item.repairDestory===1) {
              //已销单
              Row({space:10}){
                Text('评论状态:')
                  .fontSize(16)
                  .fontWeight(500)
                if (item.repairComment === 0) {
                  //未评论
                  Button('未评论')
                    .border({color:$r('app.color.warning'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                }else {
                  Button('已评论')
                    .border({color:$r('app.color.success'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                }
              }.margin(5)
              Row({space:10}){
                Text('维修状态:')
                  .fontSize(16)
                  .fontWeight(500)
                //0.已修复、1.已换新、2.无法修复 3.未修复、4.等待修复
                if (item.repairedState === 0) {
                  //未评论
                  Button('已修复')
                    .border({color:$r('app.color.success'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)
                }else if (item.repairedState === 1){
                  Button('已换新')
                    .border({color:$r('app.color.success'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                }else if (item.repairedState === 2){
                  Button('无法修复')
                    .border({color:$r('app.color.danger'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.danger'))
                    .fontColor($r('app.color.danger'))
                    .fontWeight(500)
                }else if (item.repairedState === 3){
                  Button('未修复')
                    .border({color:$r('app.color.warning'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                }else {
                  Button('等待修复')
                    .border({color:$r('app.color.font'),width:1})
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.font'))
                    .fontColor($r('app.color.font'))
                    .fontWeight(500)
                }
              }.margin(5)

              //已销单显示评论状态和维修状态
            }else {

              Row({space:10}){
                Text('操作:')
                  .fontSize(16)
                  .fontWeight(500)
                Button('转单')
                  .border({color:$r('app.color.success'),width:2})
                  .backgroundColor($r('app.color.white'))
                  .borderColor($r('app.color.success'))
                  .fontColor($r('app.color.success'))
                  .fontWeight(500)
                  .onClick(()=>{
                    promptAction.showDialog({
                      alignment:DialogAlignment.Center,
                      title:'选择转单部门',
                      message:'选择转单部门',
                      buttons:[
                        {text:'取消',color:$r('app.color.danger'),},
                        {text:'确定',color:$r('app.color.success')}
                      ]
                    }).then((res)=>{
                      if (res.index === 1) {


                      }
                    })
                  })
                Button('销单')
                  .border({color:$r('app.color.brand_light'),width:2})
                  .backgroundColor($r('app.color.white'))
                  .borderColor($r('app.color.brand_light'))
                  .fontColor($r('app.color.brand_light'))
                  .fontWeight(500)
                  .onClick(()=>{
                    promptAction.showDialog({
                      alignment:DialogAlignment.Center,
                      title:'选择派单人员',
                      message:'选择派单人员',
                      buttons:[
                        {text:'取消',color:$r('app.color.danger'),},
                        {text:'确定',color:$r('app.color.success')}
                      ]
                    }).then((res)=>{
                      if (res.index === 1) {


                      }
                    })
                  })
              }.margin(5)
              .height(30)

            }

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
    .scrollBar(BarState.Auto) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(8) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹

  }
}