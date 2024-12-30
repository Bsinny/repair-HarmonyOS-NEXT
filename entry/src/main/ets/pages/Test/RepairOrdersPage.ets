import dayjs from 'dayjs';
import { RepairItem, repImgItem } from '../../api/myRepairListAPI';
import { getRepListAPI } from '../../api/ordersAPI';
import { LOGIN_TOKEN, UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI';
import { API_BASE_URL } from '../../common/constants';

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
  async aboutToAppear(): Promise<void> {
     this.repairDep=await this.userInfo.deptId as number
     this.GetRepList()
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
    AlertDialog.show({message:JSON.stringify(res,null,2)})
    this.AllOrdersList=res.data.rows

  }
  async showRepairDetail(item: RepairItem) {
    this.selectedRepairItem = item;
    this.isVisible = true;

  }
 //维修单/api/repair/tb/receiveRep
  /**
   * 请求体
   * applyId
   :
   3027
   applyNo
   :
   null
   repairDep
   :
   200
   repairId
   :
   532
   repairNo
   :
   "GXUA20241223010346MD1734887026150"
   */
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
    Navigation(){
      Scroll(this.scroller) {
        Column(){        /*Text(`当前数据长度: ${this.listLength}`)*/
          ForEach(this.AllOrdersList,(item:RepairItem)=>{
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
                Text('报修状态:')
                  .fontSize(16)
                  .fontWeight(500)
                Button('丽丽')


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
    }   
    .title('维修单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .height('100%')
    .width('100%')

}}