
import { LOGIN_TOKEN,UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI'
import { getMyRepairListAPI, RepairItem } from '../../api/myRepairListAPI'
import dayjs from 'dayjs';


@Component
export struct OverRepairTabsComp {
  // 用户信息持久化
  @StorageLink(USER_INFO) userInfo: UserInfo = {} as UserInfo;
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_ROLE) role:string =''
  // @Provide 装饰器和 @Consume 装饰器：与后代组件双向同步
  @Consume @Watch('onTabsChange') currentMyRepairIndex: number
  @State repairIsDelete:number=0;
  @State curWork:number=1;
  @State repairDestory:number=0
  @State listLength:number=1000
  @State AllRepairList:RepairItem[]=[]
  @State testList:string[]=['哈哈','喜喜','露露']

  scroller: Scroller = new Scroller();
  //当tabs发生变化的时候
  async onTabsChange(){
     if (this.currentMyRepairIndex === 1) {
       /*AlertDialog.show({message:'哈哈哈哈'})*/
       await this.GetWaitingRepairList()


     }


  }

  async aboutToAppear() :Promise<void>{
    await this.GetWaitingRepairList()

  }

  async GetWaitingRepairList(){

    const res=await getMyRepairListAPI({
      repairIsDelete: this.repairIsDelete,
      curWork: this.curWork,
      repairDestory:this.repairDestory

    })
    if (res.data.rows && Array.isArray(res.data.rows)) {
      this.AllRepairList = res.data.rows as RepairItem[];
    } else {
      console.error('Invalid response format for repTypeList');
    }
    this.listLength=res.data.rows.length
    this.AllRepairList=res.data.rows

  }

  build() {
    Scroll(this.scroller) {
      Column(){        /*Text(`当前数据长度: ${this.listLength}`)*/
        ForEach(this.AllRepairList,(item:RepairItem)=>{
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
    .scrollBar(BarState.On) // 滚动条常驻显示
    .scrollBarColor(Color.Gray) // 滚动条颜色
    .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹

  }}