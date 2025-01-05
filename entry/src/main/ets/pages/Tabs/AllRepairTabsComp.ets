
import { LOGIN_TOKEN,UserInfo, USER_INFO, USER_ROLE } from '../../api/userInfoAPI'
import { getMyRepairListAPI, RepairItem, repImgItem } from '../../api/myRepairListAPI'
import dayjs from 'dayjs';
import { API_BASE_URL } from '../../common/constants';


// 定义按钮配置的类型
interface ButtonConfig {
  text: string;
  color: Resource; // 使用 Color 类型代替 Resource 类型
}
@Component
//所有报修组件
export struct AllRepairTabsComp {

  // 用户信息持久化
  @StorageLink(USER_INFO) userInfo: UserInfo = {} as UserInfo;
  @StorageLink(LOGIN_TOKEN) loginToken:string =''
  @StorageLink(USER_ROLE) role:string =''
  // @Provide 装饰器和 @Consume 装饰器：与后代组件双向同步
  @Consume @Watch('onTabsChange') currentMyRepairIndex: number
/*  @State repairIsDelete:number=0;
  @State curWork:number=1;*/
  @State listLength:number=1000
  @State AllRepairList:RepairItem[]=[]
  @State testList:string[]=['哈哈','喜喜','露露']
  @State isVisible: boolean = false;
  @State selectedRepairItem: RepairItem | null = null;
  @State repairDestory:number|null=null
  scroller: Scroller = new Scroller();
  //当tabs发生变化的时候
  async onTabsChange(){
     if (this.currentMyRepairIndex === 0) {
       //全部维修
       this.repairDestory=null
     }else if (this.currentMyRepairIndex === 1){
       //待维修repairIsDelete=0&curWork=1&repairDestory=0
       this.repairDestory=0
     }else if (this.currentMyRepairIndex == 2){
       //已维修repairIsDelete=0&curWork=1&repairDestory=1
       this.repairDestory=1
     }
    await this.GetMyRepairList()
  }

  async aboutToAppear() :Promise<void>{
    await this.GetMyRepairList()

  }
  async showRepairDetail(item: RepairItem) {
    this.selectedRepairItem = item;
    this.isVisible = true;

  }

  async GetMyRepairList(){

    const res=await getMyRepairListAPI({
      repairIsDelete: 0,
      curWork: 1,
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
  async GetMyRepairByConditionList(){

    const res=await getMyRepairListAPI({
      repairIsDelete: 0,
      curWork: 1,


    })
    if (res.data.rows && Array.isArray(res.data.rows)) {
      this.AllRepairList = res.data.rows as RepairItem[];
    } else {
      console.error('Invalid response format for repTypeList');
    }
    this.listLength=res.data.rows.length
    this.AllRepairList=res.data.rows

  }

  // 根据 repairState 返回不同的按钮配置
  getButtonConfig(repairState: number): ButtonConfig {
    switch (repairState) {
      case 1:
        return { text: '待接单', color: ($r('app.color.warning')) }; // 转换为 Color 类型
      case 2:
        return { text: '已接单', color: ($r('app.color.brand')) };
      case 3:
        return { text: '转单中', color: ($r('app.color.brand_light')) };
      case 4:
        return { text: '已完成', color: ($r('app.color.success')) };
      default:
        return { text: '未知状态', color: ($r('app.color.danger')) };
    }
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
              if (item.repairState===1) {
                Button('待接单')
                  .backgroundColor($r('app.color.brand'))

              }else if (item.repairState === 2) {
                Button('已接单')
                  .backgroundColor($r('app.color.brand_light'))
              }else if (item.repairState === 3){
                Button('已转单')
                  .backgroundColor($r('app.color.danger'))

              }else if (item.repairState === 4){
                Button('已完成')
                  .backgroundColor($r('app.color.success'))
                  .enabled(false)
              }else {

                Button('状态异常')
                  .backgroundColor($r('app.color.danger'))
              }



            }
            .margin(5)
            .height(30)

            if (item.repairState === 4) {
              Button('评论')
                .margin(5)
                .height(30)
                .border({color:$r('app.color.warning'),width:2})
                .backgroundColor($r('app.color.white'))
                .borderColor($r('app.color.warning'))
                .fontColor($r('app.color.warning'))
                .fontWeight(500)
                .onClick(()=>{
                //todo:跳转评论页
                })
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

  }}