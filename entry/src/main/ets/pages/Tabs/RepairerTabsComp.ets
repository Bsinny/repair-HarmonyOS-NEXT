
import { Dept, findAllDeptAPI, LOGIN_TOKEN,UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI'
import { getMyRepairListAPI, RepairItem, repImgItem } from '../../api/myRepairListAPI'
import dayjs from 'dayjs';
import { API_BASE_URL } from '../../common/constants';
import { getOrdersByConditionListAPI } from '../../api/myOrdersAPI';
import { promptAction } from '@kit.ArkUI';
import { getByDeptIdUserIdForUserAPI, getDestroyRepairAPI, getTransferRepairAPI, usersList } from '../../api/ordersAPI';

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
  @State allDeptList:Dept[]=[];
  @State selectedDeptName:string='请选择'
  @State TrDescribe:string=''//转单描述
  @State selectedRepairerUsername:string=''
  @State selectedDeptId:number|number[]=-1;
  @State testList:string[]=['哈哈','喜喜','露露']
  @State isVisible: boolean = false;
  @State selectedRepairItem: RepairItem | null = null;
  @State repairDestory:number=0
  @State selectedRepStateText:string='请选择'
  @State processDescribe:string=''
  @State selectedRepairId:number=0
  RepStateList:string[]=['已修复','已换新','无法修复','未修复']
  @State selectedRepStateIndex:number=0
  @State usersList:UserInfo[]=[]
  @State selectedRepairer:string='请选择'
  @State selectedRepairerId:number=0
  @State sheetState:number=0//当为1的时候半模态显示详细信息，当为2时，显示转单，当为3时显示销单页面
  scroller: Scroller = new Scroller();

  //当tabs发生变化的时候
  async onTabsChange(){
    if (this.currentRepairerIndex == 0) {
      //正在维修
      this.repairDestory=0
      this.getAllDeptList()

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
  this.getAllDeptList()

}
  // 更新选中的部门信息
  private updateSelectedDepartment(index: number): void {
    if (index >= 0 && index < this.allDeptList.length) {
      const selectedDept = this.allDeptList[index];
      this.selectedDeptId = selectedDept.deptId; // 更新为实际的部门ID
      this.selectedDeptName = selectedDept.deptName; // 更新为实际的部门名称

    } else {
      console.error('Invalid index provided');
    }
  }
  private updateSelectedRepairer(index:number):void{
    if (index >= 0 && index < this.usersList.length) {
      const selectedRepairerInfo = this.usersList[index];
      this.selectedRepairId = selectedRepairerInfo.userId as number;
      this.selectedRepairer = selectedRepairerInfo.nickName as string;
      this.selectedRepairerUsername=selectedRepairerInfo.userName as string
      promptAction.showToast({ message: `当前选中的人是${this.selectedRepairer},id为${this.selectedRepairId}` })

    } else {
      console.error('Invalid index provided');
    }
  }

  async getAllDeptList() {
    try {
      const res = await findAllDeptAPI();
      if (res.data && Array.isArray(res.data.data)) {
        this.allDeptList = res.data.data as Dept[];
      } else {
        console.error('Invalid response format for allDeptList');
      }
    } catch (error) {
      console.error('Failed to fetch allDeptList:', error);
    }
  }
  async showRepairDetail(item: RepairItem) {
    this.selectedRepairItem = item;
    this.sheetState=1
    this.isVisible = true;

  }
  async showProcessDescribe(item: RepairItem){
    this.selectedRepairId=item.repairId
    this.sheetState=3
    this.isVisible = true;
    promptAction.showToast({ message: `当前id为：${this.selectedRepairId}` })


  }
  //显示转单瓣膜太
  async showTransferRepairer(item:RepairItem){
    this.selectedRepairItem = item;
    this.sheetState=2
    this.isVisible = true;
  }
  async getByDeptIdUserIdForUserList(){
    const res=await getByDeptIdUserIdForUserAPI({
      deptId:this.selectedDeptId as number
    })
    this.usersList=res.data.data
  }
  async getTransferRepairer(item:RepairItem){
    const res=await getTransferRepairAPI({
      TrDescribe: this.TrDescribe,
      repairId: item.repairId,
      repairNo: item.repairNo,
      repairType: item.repairType,
      applyId: item.applyId,
      userId: this.selectedRepairId,
      deptId: this.selectedDeptId as number,
      userName: this.selectedRepairer,//用户账号
      repairDep: item.repairDep,
    })
    if (res.data.code === 200) {
      promptAction.showToast({ message: '转单成功' })


    }else {
      promptAction.showToast({ message: '转单失败' })
    }
    this.GetRepairingOrdersList()
    this.isVisible=false
  }
  async getProcessDescribe(){
    const res=await getDestroyRepairAPI(this.selectedRepairId,this.selectedRepStateIndex,{
      processDescribe:this.processDescribe

    })
    if (res.data.code===200){
      promptAction.showToast({ message: '销单成功' })
      this.selectedRepStateText='请选择'
      this.selectedRepairId=0
      this.selectedRepStateIndex=-1
      this.processDescribe=''

    }else {
      promptAction.showToast({ message: '销单失败' })
    }
    this.GetRepairingOrdersList()
    this.isVisible=false
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
    if (this.sheetState===1){
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


      }
    }else if (this.sheetState===2 ){
      Column({space:10}){
      //转单页面
      Text('转单')
        .align(Alignment.Center)
        .fontSize(16)
        .margin(10)
      Row({ space: 10 }) {
        Text('转单部门:')
          .fontSize(14)
          .fontColor($r('app.color.font'));
        Text(this.selectedDeptName)
          .margin(20)
          .onClick(()=>{
            TextPickerDialog.show({
              range:this.allDeptList.map(item => item.deptName),
              selected: this.selectedDeptId,
              disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
              textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
              selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
              onAccept:(values:TextPickerResult)=>{
                this.updateSelectedDepartment(values.index as number);
                this.getByDeptIdUserIdForUserList()


              },
              onCancel: () => {
                console.info("TextPickerDialog:onCancel()")
              },

            })

          })
      }
      Row({ space: 10 }) {
        Text('被转单人:')
          .fontSize(14)
          .fontColor($r('app.color.font'));
        Text(this.selectedRepairer)
          .margin(20)
          .onClick(()=>{
            TextPickerDialog.show({
              range:this.usersList.map(item => item.nickName as string),
              selected: this.selectedRepairId,
              disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
              textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
              selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
              onAccept:(values:TextPickerResult)=>{
                /*this.updateSelectedDepartment(values.index as number);*/
                  this.updateSelectedRepairer(values.index as number)
              },
              onCancel: () => {
                console.info("TextPickerDialog:onCancel()")
              },

            })

          })

      }
        Row({space:10}){
          Text('转单描述：')
          TextArea({
            placeholder:'请输入维修情况',
          })
            .height(100)
            .fontSize(14)
            .backgroundColor($r('app.color.divider'))
            .border({ width: { bottom: 1 }, color: $r('app.color.font_sub'), radius: 0 })
            .padding({ left: 16, right: 16 })
            .onChange((value) => {
              this.TrDescribe = value
            })
        }
      Button('转单')
          .onClick(()=> {
            this.getTransferRepairer(this.selectedRepairItem as RepairItem)
          })}
    }else if (this.sheetState===3){
      //销单半模态
      Column({space:10}){
        Text('销单')
          .align(Alignment.Center)
          .fontSize(16)
          .margin(10)
        Row(){
          Text('维修状态：')
          Text(this.selectedRepStateText)
            .margin(20)
            .onClick(() => {
              TextPickerDialog.show({
                range: this.RepStateList.map(item => item),
                selected: this.selectedRepStateIndex, // 直接使用当前选中的索引
                disappearTextStyle: { color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } },
                textStyle: { color: Color.Black, font: { size: 20, weight: FontWeight.Normal } },
                selectedTextStyle: { color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } },
                onAccept: (values: TextPickerResult) => {
                  this.selectedRepStateText=values.value as string
                  this.selectedRepStateIndex=values.index as number
                  promptAction.showToast({ message: `当前的值是${this.selectedRepStateText},id是${this.selectedRepStateIndex}` })

                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()");
                },
              });
            })


        }
        Row({space:10}){
          Text('维修情况：')
          TextArea({
            placeholder:'请输入维修情况',
          })
            .height(100)
            .fontSize(14)
            .backgroundColor($r('app.color.divider'))
            .border({ width: { bottom: 1 }, color: $r('app.color.font_sub'), radius: 0 })
            .padding({ left: 16, right: 16 })
            .onChange((value) => {
              this.processDescribe = value
            })
        }
        Button('确认销单')
          .enabled(this.processDescribe!='')
          .onClick(()=>{
              this.getProcessDescribe()

          })

      }
    }

  }


  build() {
    Scroll(this.scroller) {
      Column(){
        ForEach(this.repairingOrdersList,(item:RepairItem,index:number)=> {
          Badge({
            count:index+1,
            position:BadgePosition.RightTop,
            style: {fontSize:20, badgeSize: 25, badgeColor: '#FA2A2D' }
          }) {
          Column({ space: 10 }) {
            Row({ space: 10 }) {
              Text('报修类型:')
              Text(item.repType?.repairType || '未知类型')
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
              Text('报修时间:')
                .fontSize(16)
                .fontWeight(500)
              Text(dayjs(item.repairExpectTime).format('YYYY-MM-DD'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)

            Row({ space: 10 }) {
              Text('报修单价:')
                .fontSize(16)
                .fontWeight(500)
              Text(`${item?.repairMoney}￥`)
                .fontColor($r('app.color.danger'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)

            if (item.repairDestory === 1) {
              //已销单
              Row({ space: 10 }) {
                Text('评论状态:')
                  .fontSize(16)
                  .fontWeight(500)
                if (item.repairComment === 0) {
                  //未评论
                  Button('未评论')
                    .border({ color: $r('app.color.warning'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                } else {
                  Button('已评论')
                    .border({ color: $r('app.color.success'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                }
              }.margin(5)

              Row({ space: 10 }) {
                Text('维修状态:')
                  .fontSize(16)
                  .fontWeight(500)
                //0.已修复、1.已换新、2.无法修复 3.未修复、4.等待修复
                if (item.repairedState === 0) {
                  //未评论
                  Button('已修复')
                    .border({ color: $r('app.color.success'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)
                } else if (item.repairedState === 1) {
                  Button('已换新')
                    .border({ color: $r('app.color.success'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                } else if (item.repairedState === 2) {
                  Button('无法修复')
                    .border({ color: $r('app.color.danger'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.danger'))
                    .fontColor($r('app.color.danger'))
                    .fontWeight(500)
                } else if (item.repairedState === 3) {
                  Button('未修复')
                    .border({ color: $r('app.color.warning'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                } else {
                  Button('等待修复')
                    .border({ color: $r('app.color.font'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.font'))
                    .fontColor($r('app.color.font'))
                    .fontWeight(500)
                }
              }.margin(5)

              //已销单显示评论状态和维修状态
            } else {

              Row({ space: 10 }) {
                Text('操作:')
                  .fontSize(16)
                  .fontWeight(500)
                Button('转单')
                  .border({ color: $r('app.color.success'), width: 2 })
                  .backgroundColor($r('app.color.white'))
                  .borderColor($r('app.color.success'))
                  .fontColor($r('app.color.success'))
                  .fontWeight(500)
                  .onClick(() => {
                    this.showTransferRepairer(item)
                  })
                Button('销单')
                  .border({ color: $r('app.color.brand_light'), width: 2 })
                  .backgroundColor($r('app.color.white'))
                  .borderColor($r('app.color.brand_light'))
                  .fontColor($r('app.color.brand_light'))
                  .fontWeight(500)
                  .onClick(() => {
                    this.showProcessDescribe(item)
                    /*this.sheetState=3
                    this.isVisible=true*/
                    /*                      promptAction.showDialog({
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
                                          })*/
                  })
              }.margin(5)
              .height(30)

            }

          }
          .onClick(() => {
            this.showRepairDetail(item)

          })

          .margin(5)
          .width('95%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor($r('app.color.background'))
          .borderStyle(BorderStyle.Solid)
          .borderWidth(2)
          .borderColor(0xAFEEEE)
          .borderRadius(10)
          .align(Alignment.Center)
        }
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
        ForEach(this.repairOverOrdersList,(item:RepairItem,index:number)=> {
          Badge({
            count:index+1,
            position:BadgePosition.RightTop,
            style: {fontSize:20, badgeSize: 25, badgeColor: '#FA2A2D' }
          }) {
          Column({ space: 10 }) {
            Row({ space: 10 }) {
              Text('报修类型:')
              Text(item.repType?.repairType || '未知类型')
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
              Text('报修时间:')
                .fontSize(16)
                .fontWeight(500)
              Text(dayjs(item.repairExpectTime).format('YYYY-MM-DD'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)

            Row({ space: 10 }) {
              Text('报修单价:')
                .fontSize(16)
                .fontWeight(500)
              Text(`${item?.repairMoney}￥`)
                .fontColor($r('app.color.danger'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)

            if (item.repairDestory === 1) {
              //已销单
              Row({ space: 10 }) {
                Text('评论状态:')
                  .fontSize(16)
                  .fontWeight(500)
                if (item.repairComment === 0) {
                  //未评论
                  Button('未评论')
                    .border({ color: $r('app.color.warning'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                } else {
                  Button('已评论')
                    .border({ color: $r('app.color.success'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                }
              }.margin(5)

              Row({ space: 10 }) {
                Text('维修状态:')
                  .fontSize(16)
                  .fontWeight(500)
                //0.已修复、1.已换新、2.无法修复 3.未修复、4.等待修复
                if (item.repairedState === 0) {
                  //未评论
                  Button('已修复')
                    .border({ color: $r('app.color.success'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)
                } else if (item.repairedState === 1) {
                  Button('已换新')
                    .border({ color: $r('app.color.success'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.success'))
                    .fontColor($r('app.color.success'))
                    .fontWeight(500)

                } else if (item.repairedState === 2) {
                  Button('无法修复')
                    .border({ color: $r('app.color.danger'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.danger'))
                    .fontColor($r('app.color.danger'))
                    .fontWeight(500)
                } else if (item.repairedState === 3) {
                  Button('未修复')
                    .border({ color: $r('app.color.warning'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.warning'))
                    .fontColor($r('app.color.warning'))
                    .fontWeight(500)
                } else {
                  Button('等待修复')
                    .border({ color: $r('app.color.font'), width: 1 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.font'))
                    .fontColor($r('app.color.font'))
                    .fontWeight(500)
                }
              }.margin(5)

              //已销单显示评论状态和维修状态
            } else {

              Row({ space: 10 }) {
                Text('操作:')
                  .fontSize(16)
                  .fontWeight(500)
                Button('转单')
                  .border({ color: $r('app.color.success'), width: 2 })
                  .backgroundColor($r('app.color.white'))
                  .borderColor($r('app.color.success'))
                  .fontColor($r('app.color.success'))
                  .fontWeight(500)
                  .onClick(() => {
                    promptAction.showDialog({
                      alignment: DialogAlignment.Center,
                      title: '选择转单部门',
                      message: '选择转单部门',
                      buttons: [
                        { text: '取消', color: $r('app.color.danger'), },
                        { text: '确定', color: $r('app.color.success') }
                      ]
                    }).then((res) => {
                      if (res.index === 1) {


                      }
                    })
                  })
                Button('销单')
                  .border({ color: $r('app.color.brand_light'), width: 2 })
                  .backgroundColor($r('app.color.white'))
                  .borderColor($r('app.color.brand_light'))
                  .fontColor($r('app.color.brand_light'))
                  .fontWeight(500)
                  .onClick(() => {
                    promptAction.showDialog({
                      alignment: DialogAlignment.Center,
                      title: '选择派单人员',
                      message: '选择派单人员',
                      buttons: [
                        { text: '取消', color: $r('app.color.danger'), },
                        { text: '确定', color: $r('app.color.success') }
                      ]
                    }).then((res) => {
                      if (res.index === 1) {


                      }
                    })
                  })
              }.margin(5)
              .height(30)

            }

          }
          .onClick(() => {
            this.showRepairDetail(item)

          })

          .margin(5)
          .width('95%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor($r('app.color.background'))
          .borderStyle(BorderStyle.Solid)
          .borderWidth(2)
          .borderColor(0xAFEEEE)
          .borderRadius(10)
          .align(Alignment.Center)
        }
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