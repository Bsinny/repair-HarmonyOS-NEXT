import { getRepTypeListAPI, getTypeListAPI,
  postApplyForm,
  postApplyPhotoAPI,
  repTypeItem, typeItem } from '../../api/getTypeAPI';
import dayjs from 'dayjs';
import { systemDateTime } from '@kit.BasicServicesKit';
import { UserInfo, USER_INFO } from '../../api/userInfoAPI';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import SelectImage from '../Test';
import { common } from '@kit.AbilityKit';
import { FormData } from '@ohos/axios';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct RepairFormPage {
  @StorageLink(USER_INFO) userInfo: UserInfo = {}  as UserInfo;
  @State applyAddress:string= '请填写报修地址';
  @State applyContent:string= '提瓦特大陆里面玩不了原神搞得积极洋洋的';
  @State applyExpectType:number=-1
  @State typeList:typeItem[]=[]
  @State repTypeList:repTypeItem[]=[]
  @State select: number = 0
  private selectedTypeIndex: number |number[]= -1;
  private selectedRepTypeIndex:number |number[]= -1;
  @State isShowTypeSheet: boolean = false;
  @State isShowRepTypeSheet: boolean = false;
  @State selectedTypeText: string  = '请选择';
  @State selectedRepTypeText: string = '请选择';
  @State applyExpectTime: Date= new Date('2024-8-8');
  @State applyType:number=-1
  @State isOrder:number=-1
  @State applyId:number=-1
  @State repairId:number=-1
  @State images: string[] = []; // 存储图片路径的状态
  // 添加图片的方法
  addImage(imgPath: string) {
    this.images.push(imgPath);
  }

  removeImage(imgPath: string) {
    this.images = this.images.filter((img) => img !== imgPath);
  }

  //获取报修类型
  async getTypeList(){
    try {
      const res = await getTypeListAPI();
      if (res.data && Array.isArray(res.data.rows)) {
        this.typeList = res.data.rows as typeItem[]

      } else {
        console.error('Invalid response format for typeList');
      }
    } catch (error) {
      console.error('Failed to fetch typeList:', error);
    }

  }

  async submitForm(){
    const res=await postApplyForm({
      applyUser: this.userInfo.nickName as string, //报修用户姓名
      applyContent: this.applyContent, //报修内容
      applyAddress: this.applyAddress, //报修地点
      applyType: this.applyType, //报修类型
      applyExpectType: this.applyExpectType, //期望维修类型
      applyExpectTime: this.applyExpectTime, //期望维修时间
      isOrder: this.isOrder,
    })
    this.repairId=res.data.repairId
    this.applyId=res.data.applyId

    let context=getContext() as common.UIAbilityContext;
    for (const item of this.images/*let index = 0; index < this.images.length; index++*/) {
      let formData:FormData=new FormData();
      formData.append('appId', this.applyId.toString());
      formData.append('repairId', this.repairId.toString());
      formData.append('applyExpectType', this.applyExpectType.toString());
      formData.append('imgFile', item); // 确保`item`是文件对象
/*      const element = this.images[index];
      let formData:FormData=new FormData();*/
      const resData = await postApplyPhotoAPI(formData,context);


      
    }
    router.back()
/*    let context=getContext() as common.UIAbilityContext;
    let formData:FormData=new FormData();
    this.images.forEach((item,index)=>{
      formData.append('appId', this.applyId.toString())
      formData.append('repairId', this.repairId.toString())
      formData.append('applyExpectType', this.applyExpectType.toString())
      formData.append('imgFile',item)


    })

    const resData=await postApplyPhotoAPI(formData,context)
    router.back()
    AlertDialog.show({message:'applyId'+this.applyId.toString()+'repairId'+this.repairId.toString()
      +JSON.stringify(resData.data.msg,null,2)})*/


  }




  async getRepTypeList(){

    try {
      const res = await getRepTypeListAPI();
      if (res.data && Array.isArray(res.data.rows)) {
        this.repTypeList = res.data.rows as repTypeItem[];
      } else {
        console.error('Invalid response format for repTypeList');
      }
    } catch (error) {
      console.error('Failed to fetch repTypeList:', error);
    }
  }

  async aboutToAppear(): Promise<void> {
    await this.getTypeList();
    await this.getRepTypeList();
  }
  private updateSelectedType(index: number): void {
    if (index >= 0 && index < this.typeList.length) {
      const selectedType = this.typeList[index];
      this.applyType = selectedType.repairTypeId as number; // 更新为实际的类型ID
      this.selectedTypeText = selectedType.repairType as string; // 更新为实际的类型名称
      this.selectedTypeIndex = index; // 更新为实际的索引
      // 可选：显示选择确认对话框
      // AlertDialog.show({
      //   message: `选择的是 ${this.selectedTypeText} ID值是 ${this.applyType}`
      // });
    } else {
      console.error('Invalid index provided');
    }
  }
  // 更新选中的预期类型信息
  private updateSelectedRepType(index: number): void {
    if (index >= 0 && index < this.repTypeList.length) {
      const selectedRep = this.repTypeList[index];
      this.applyExpectType = selectedRep.repexpectTypeId as number; // 更新为实际的预期类型ID
      this.selectedRepTypeText = selectedRep.repexpectType as string; // 更新为实际的预期类型名称
      this.selectedRepTypeIndex = index; // 更新为实际的索引

    } else {
      console.error('Invalid index provided');
    }
  }








  build() {

    Navigation() {
      Column({space:20}){
        Row(){
          Text('报修地点:')
            .fontSize(14)
            .fontColor($r('app.color.font'))
            .layoutWeight(2)

          TextInput({
            placeholder:'请输入报修地点',
            text:this.applyAddress
          })
            .layoutWeight(6)

            .type(InputType.Normal)
            .fontSize(14)
            .height(50)
            .backgroundColor($r('app.color.background2'))
            .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 8 })
            .padding({ left: 16, right: 16 })
            .onChange((value) => {
              this.applyAddress = value
            })
          Column(){
            Image($r('app.media.location_4'))
              .onClick(()=>{
                this.applyAddress='广西梧州市万秀区富民三路82号学府新城A12'
              })
            Text('获取地址').fontSize(10)
          }
          .height(40)
          .layoutWeight(1)


        }.width('100%')


        Row(){
          Text('报修内容:')
            .fontSize(14)
            .fontColor($r('app.color.font'));
          TextArea({
            placeholder:'请输入报修内容',
          })
            .height(150)
            .fontSize(14)
            .backgroundColor(Color.Transparent)
            .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
            .padding({ left: 16, right: 16 })
            .onChange((value) => {
              this.applyContent = value
            })
        }.width('100%')

              Row({ space: 10 }) {
                Text('维修类型:')
                  .fontSize(14)
                  .fontColor($r('app.color.font'));
                Text(this.selectedTypeText)
                  .margin(20)
                  .onClick(() => {
                    TextPickerDialog.show({
                      range: this.typeList.map(item => item.repairType),
                      selected: this.selectedTypeIndex, // 直接使用当前选中的索引
                      disappearTextStyle: { color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } },
                      textStyle: { color: Color.Black, font: { size: 20, weight: FontWeight.Normal } },
                      selectedTextStyle: { color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } },
                      onAccept: (values: TextPickerResult) => {
                        this.updateSelectedType(values.index as number);
                      },
                      onCancel: () => {
                        console.info("TextPickerDialog:onCancel()");
                      },
                    });
                  });
              }.width('100%')
              Row({ space: 10 }) {
                Text('期望维修类型:')
                  .fontSize(14)
                  .fontColor($r('app.color.font'));
                Text(this.selectedRepTypeText)
                  .margin(20)
                  .onClick(() => {
                    TextPickerDialog.show({
                      range: this.repTypeList.map(item => item.repexpectType),
                      selected: this.selectedRepTypeIndex, // 直接使用当前选中的索引
                      disappearTextStyle: { color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } },
                      textStyle: { color: Color.Black, font: { size: 20, weight: FontWeight.Normal } },
                      selectedTextStyle: { color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } },
                      onAccept: (values: TextPickerResult) => {
                        this.updateSelectedRepType(values.index as number);
                      },
                      onCancel: () => {
                        console.info("TextPickerDialog:onCancel()");
                      },
                    });
                  });
        }.width('100%')
        Row({ space: 10 }) {
          Text('期待维修时间:')
            .fontSize(14)
            .fontColor($r('app.color.font'));
          Text(dayjs(this.applyExpectTime).format('YYYY-MM-DD'))
            .margin(20)
            .onClick(()=>{
              DatePickerDialog.show({
                start: new Date(dayjs(systemDateTime.getTime(false)).format('YYYY-MM-DD')),
                end: new Date("2100-12-31"),
                selected: this.applyExpectTime,
                showTime:false,
                useMilitaryTime:false,
                disappearTextStyle: {color: Color.Pink, font: {size: '22fp', weight: FontWeight.Bold}},
                textStyle: {color: '#ff00ff00', font: {size: '18fp', weight: FontWeight.Normal}},
                selectedTextStyle: {color: '#ff182431', font: {size: '14fp', weight: FontWeight.Regular}},
                onDateAccept:(value:Date)=>{
                  this.applyExpectTime=value
                  console.log('applyExpectTime'+dayjs(value).format('YYYY-MM-DD'))
                }

              })
            })
        }.width('100%')


        SelectImage({
          fileList: this.images, // 传递图片路径数组
          limit: 3, // 设置最大图片数量限制
          title: '选择图片', // 设置标题
          flexAlign: FlexAlign.Center, // 设置对齐方式
          deleteImg:  (imgPath: string): void => this.removeImage(imgPath),// 传递删除图片的方法
        });
        Button('查看图片列表')
          .onClick(async ()=>{
            AlertDialog.show({message:JSON.stringify(this.images,null,2)})

          })

        Button('提交')
          .onClick(async ()=>{
            await this.submitForm()

          })
          }
        }
    .title('填写报修单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)

  }

}