import dayjs from 'dayjs';
import { RepairItem, repImgItem } from '../../api/myRepairListAPI';
import {
  getArrangeAPI,
  getByDeptIdUserIdForUserAPI,
  getRepListAPI, getTransferFromDepAPI, getTransferRepairAPI, postReceiveRepAPI } from '../../api/ordersAPI';
import { Dept, findAllDeptAPI, LOGIN_TOKEN, UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI';
import { API_BASE_URL } from '../../common/constants';
import { font, promptAction } from '@kit.ArkUI';

@Entry
@Component
//维修单
struct RepairOrdersPage {
  scroller: Scroller = new Scroller();
  @StorageLink(USER_INFO) userInfo: UserInfo = {} as UserInfo;
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_ROLE) role:string =''
  @State repairDep:number=0
  @State repairIsDelete:number= 0
  @State repairState:number= 1
  @State curWork:number= 1
  @State repairDestory:number= 0
  @State AllOrdersList:RepairItem[]=[]
  @State isVisible: boolean = false;
  @State selectedRepairItem: RepairItem | null = null;
  @State sheetState:number=0
  @State allDeptList:Dept[]=[]
  @State selectedDeptName:string='请选择'
  @State selectedDeptId:number=0
  @State usersList:UserInfo[]=[]
  @State selectedRepairer:string='请选择派单人员'
  @State selectedRepairId:number=0
  @State selectedRepairerUsername:string=''


  async aboutToAppear(): Promise<void> {
     this.repairDep=await this.userInfo.deptId as number
     this.GetRepList()
     this.getAllDeptList()
  }
  async getArrange(){
    const res=await getArrangeAPI({
      userName: this.selectedRepairerUsername,
      userId: this.selectedRepairId,
      repairNo: this.selectedRepairItem?.repairNo as string,
      repairType: this.selectedRepairItem?.repairType as number,
      repairId: this.selectedRepairItem?.repairId as number,
      applyId: this.selectedRepairItem?.applyId as number,

    })
    if (res.data.code===200) {
      promptAction.showToast({message:'派单成功'})
      //刷新页面
      this.GetRepList()
      this.isVisible=false
    }else {
      promptAction.showToast({message:'派单失败请重试'})
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
  async showTransferRepairer(item:RepairItem){
    this.selectedRepairItem = item;
    this.sheetState=2
    this.isVisible = true;
  }
  async showShareOrders(item:RepairItem){
    this.getByDeptIdUserIdForUserList()
    this.selectedRepairItem = item;
    this.sheetState=3
    this.isVisible = true;
  }
  async getByDeptIdUserIdForUserList(){
    const res=await getByDeptIdUserIdForUserAPI({
      deptId:this.repairDep
    })
    this.usersList=res.data.data
  }

  async GetRepList(){
    const res=await getRepListAPI(
      {
        repairIsDelete: this.repairIsDelete,
        repairState: this.repairState,
        curWork: this.curWork,
        repairDestory: this.repairDestory,
        repairDep: this.repairDep
      }
    )
    this.AllOrdersList=res.data.rows

  }
  async showRepairDetail(item: RepairItem) {
    this.sheetState=1
    this.selectedRepairItem = item;
    this.isVisible = true;

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
  async getTransferRepairer(item:RepairItem){
    const res=await getTransferFromDepAPI({
      repairNo: item.repairNo,
      repairType: item.repairType,
      repairId: item.repairId,
      applyId: item.applyId,
      deptId: this.selectedDeptId,

    })
    if (res.data.code === 200) {
      promptAction.showToast({ message: '转单成功' })


    }else {
      promptAction.showToast({ message: '转单失败' })
    }
    this.GetRepList()
    /*this.GetRepairingOrdersList()*/
    this.isVisible=false
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
  async receiveRep(){
    const res=await postReceiveRepAPI({
      applyId:this.selectedRepairItem?.applyId as number,
      repairDep:this.repairDep,
      repairId:this.selectedRepairItem?.repairId as number,
      repairNo:this.selectedRepairItem?.repairNo as string

    })
    if (res.data.code===200) {
      promptAction.showToast({message:'接单成功'})
      //刷新页面
      this.GetRepList()
      this.isVisible=false
    }else {
      promptAction.showToast({message:'接单失败请重试'})
    }

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
        Button('接单')
          .onClick(()=>{
            promptAction.showDialog({
              alignment:DialogAlignment.Center,
              title:'温馨提示',
              message:'确认接下该订单吗',
              buttons:[
                {text:'取消',color:$r('app.color.danger'),},
                {text:'确定',color:$r('app.color.success')}
              ]
            }).then((res)=>{
              if (res.index === 1) {
                this.receiveRep()


              }
            })

          })


      }
    }else if (this.sheetState===2){
      //维修专员转单
      Column({space:10}){
        //转单页面
        Text('转单给其他部门')
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

                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()")
                },

              })

            })
        }


        Button('派单')
          .onClick(()=> {
            this.getTransferRepairer(this.selectedRepairItem as RepairItem)

          })}

    }else if (this.sheetState===3){
      //维修专员派单
      Column({space:10}){
        //转单页面
        Text('转单给其他部门')
          .align(Alignment.Center)
          .fontSize(16)
          .margin(10)
        Row({ space: 10 }) {

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

                    this.updateSelectedRepairer(values.index as number)
                  },
                  onCancel: () => {
                    console.info("TextPickerDialog:onCancel()")
                  },

                })

              })

          }
        }


        Button('转单')
          .onClick(()=> {
            this.getArrange()

          })}
    }
}
  build() {
    Navigation(){
      Scroll(this.scroller) {
        Column(){        /*Text(`当前数据长度: ${this.listLength}`)*/
          ForEach(this.AllOrdersList,(item:RepairItem,index:number)=> {
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
                Text('状态:')
                  .fontSize(16)
                  .fontWeight(500)
                Button('待接单')
                  .enabled(false)
                  .onClick(() => {
                    promptAction.showDialog({
                      alignment: DialogAlignment.Center,
                      title: '温馨提示',
                      message: '确认接下该订单吗',
                      buttons: [
                        { text: '取消', color: $r('app.color.danger'), },
                        { text: '确定', color: $r('app.color.success') }
                      ]
                    }).then((res) => {
                      if (res.index === 1) {
                        this.receiveRep()

                      }
                    })
                  })
              }.margin(5)
              .height(30)

              if (this.role === 'repairadmin') {
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
                  Button('派单')
                    .border({ color: $r('app.color.brand_light'), width: 2 })
                    .backgroundColor($r('app.color.white'))
                    .borderColor($r('app.color.brand_light'))
                    .fontColor($r('app.color.brand_light'))
                    .fontWeight(500)
                    .onClick(() => {
                        this.showShareOrders(item)
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
    }   
    .title('维修单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .height('100%')
    .width('100%')

}}