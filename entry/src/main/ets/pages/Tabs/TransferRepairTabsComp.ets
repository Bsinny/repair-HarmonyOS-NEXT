
import { LOGIN_TOKEN,UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI'
import { getMyRepairListAPI, RepairItem, repImgItem } from '../../api/myRepairListAPI'
import dayjs from 'dayjs';
import { API_BASE_URL } from '../../common/constants';
import { getTransferOrdersDetailListAPI, repTransferItem } from '../../api/myOrdersAPI';


@Component
  //所有报修组件
export struct TransferRepairTabsComp {

  // 用户信息持久化
  @StorageLink(USER_INFO) userInfo: UserInfo = {} as UserInfo;
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_ROLE) role:string =''
  // @Provide 装饰器和 @Consume 装饰器：与后代组件双向同步
  @Consume @Watch('onTabsChange') currentRepairerIndex: number
  @State transferOrdersDetailList:repTransferItem[]=[]

  @State selectedRepairItem: RepairItem | null = null;
  @State repairDestory:number|null=null
  scroller: Scroller = new Scroller();
  //当tabs发生变化的时候
  async onTabsChange(){
    if (this.currentRepairerIndex == 2) {
      this.getTransferOrdersDetailList()


    }
  }

  async aboutToAppear() :Promise<void>{
  this.getTransferOrdersDetailList()
  }
  async showRepairDetail(item: RepairItem) {
    this.selectedRepairItem = item;

  }
  async getTransferOrdersDetailList(){
    const res=await getTransferOrdersDetailListAPI()
    this.transferOrdersDetailList=res.data.rows
  }

  build() {
    Scroll(this.scroller) {
      Column(){
        ForEach(this.transferOrdersDetailList,(item:repTransferItem)=>{

          Column({space:10}){
            Row({space:10}){
              Text('报修类型:')
              if (item.apply_type === '1') {
                Text('网络设备')
              }else if (item.apply_type === '2'){
                Text('水电类')
              }else if (item.apply_type === '3'){
                Text('家具类')
              }else if (item.apply_type === '4'){
                Text('办公室设备')
              }else if (item.apply_type === '5'){
                Text('教学电子')
              }else if (item.apply_type === '6'){
                Text('教学电子')
              }else if (item.apply_type === '7'){
                Text('电器类')
              }else if (item.apply_type === '8'){
                Text('木材类')
              }else {
                Text('未知类型')
              }

            }.margin(10)
            Divider().strokeWidth(3).color('#F1F3F5')
            Row({space:10}){
              Text('报修地点:')
                .fontSize(16)
                .fontWeight(500)
              Text(item.apply_address)
                .fontSize(16)
                .fontWeight(500)

            }.margin(5)
            Row({space:10}){
              Text('报修地点:')
                .fontSize(16)
                .fontWeight(500)
              Text(item.apply_content)
                .fontSize(16)
                .fontWeight(500)

            }.margin(5)
            Row({space:10}){
              Text('转单时间:')
                .fontSize(16)
                .fontWeight(500)
              Text(dayjs(item.reptransfeTime).format('YYYY-MM-DD-HH-SS'))
                .fontSize(16)
                .fontWeight(500)


            }.margin(5)

            Row({space:10}){
              Text('被转单人姓名')
                .fontSize(16)
                .fontWeight(500)
              Button(item.to_nick_name)
                .border({color:$r('app.color.success'),width:1})
                .backgroundColor($r('app.color.white'))
                .borderColor($r('app.color.success'))
                .fontColor($r('app.color.success'))
                .fontWeight(500)

            }
            .margin(5)
            .height(30)

            Row({space:10}){
              Text('被转单部门')
                .fontSize(16)
                .fontWeight(500)
              Button(item.dept_name)
                .border({color:$r('app.color.brand_light'),width:1})
                .backgroundColor($r('app.color.white'))
                .borderColor($r('app.color.brand_light'))
                .fontColor($r('app.color.brand_light'))
                .fontWeight(500)

            }
            .margin(5)
            .height(30)

          }
/*          .onClick(()=>{
            this.showRepairDetail(item)

          })*/

          .margin(5)
          .width('95%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor($r('app.color.background'))
          .borderStyle(BorderStyle.Solid).borderWidth(2).borderColor(0xAFEEEE).borderRadius(10)
          .align(Alignment.Center)

        })}

    }

    .width('100%')
    .backgroundColor(0xDCDCDC)
    .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
    .scrollBar(BarState.Auto) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(8) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹

  }}