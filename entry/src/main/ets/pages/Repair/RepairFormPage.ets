import { getRepTypeListAPI, getRepTypes, getTypeListAPI, getTypes,
  postApplyForm,
  repTypeItem, typeItem } from '../../api/getTypeAPI';
import {  promptAction } from '@kit.ArkUI';
import { values } from '@wolfx/lodash';
import dayjs from 'dayjs';
import { systemDateTime } from '@kit.BasicServicesKit';
import { permissionManager } from '../../manager/PermissionManager';
import { UserInfo, USER_INFO } from '../../api/userInfoAPI';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

@Entry
@Component
struct RepairFormPage {
  @StorageLink(USER_INFO) userInfo: UserInfo = {}  as UserInfo;
  @State applyAddress:string= '提瓦特大陆';
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
    const res=await postApplyForm(this.isOrder,{
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

  build() {

    Navigation() {
      Column({space:20}){
        Row(){
          Text('报修地点:')
            .fontSize(14)
            .fontColor($r('app.color.font'));

          TextInput({
            placeholder:'请输入报修地点',
          })
            .type(InputType.Normal)
            .fontSize(14)
            .height(50)
            .backgroundColor($r('app.color.background2'))
            .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 8 })
            .padding({ left: 16, right: 16 })
            .onChange((value) => {
              this.applyAddress = value
            })
        }


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
        }

              Row({ space: 10 }) {
                Text('维修类型:')
                  .fontSize(14)
                  .fontColor($r('app.color.font'));
                Text(this.selectedTypeText)
                  .margin(20)
                  .onClick(()=>{
                    TextPickerDialog.show({
                      range:this.typeList.map(item => item.repairType),
                      selected: this.selectedTypeIndex,
                      disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
                      textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
                      selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
                      onAccept:(values:TextPickerResult)=>{
                        const selectedType = this.typeList.find((item, index) => index === values.index);
                        if (selectedType) {
                          this.applyType=selectedType.repairTypeId as number
                          this.selectedTypeText=selectedType.repairType as string
                          /*AlertDialog.show({ message: `选择的是 ${this.selectedTypeText} id值是 ${this.applyType}` });*/
                        }

                      },
                      onCancel: () => {
                        console.info("TextPickerDialog:onCancel()")
                      },

                    })

                  })
              }
              Row({ space: 10 }) {
                Text('期望维修类型:')
                  .fontSize(14)
                  .fontColor($r('app.color.font'));
                Text(this.selectedRepTypeText)
                  .margin(20)
                  .onClick(()=>{
                    TextPickerDialog.show({
                      range:this.repTypeList.map(item => item.repexpectType),
                      selected: this.selectedRepTypeIndex,
                      disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
                      textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
                      selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
                      onAccept:(values:TextPickerResult)=>{
                        const selectedRep = this.repTypeList.find((item, index) => index === values.index);
                        if (selectedRep) {
                          this.applyExpectType=selectedRep.repexpectTypeId as number
                          this.selectedRepTypeText=selectedRep.repexpectType as string
                          /*AlertDialog.show({ message: `选择的是 ${this.selectedRepTypeText} id值是 ${this.applyExpectType}` });*/
                      }},
                      onCancel: () => {
                        console.info("TextPickerDialog:onCancel()")
                      },

                    })

            })
        }
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
        }




        //TODO:这个系统的调用上传图片逻辑是两个
        //TODO:将前面一个请求返回的信息拿到，再传入一次后端，虽然不知道这个逻辑为什么做两遍，小程序端是这样的，照着做就行

        Button('获取当前用户填写信息')
          .onClick(()=>{
            AlertDialog.show({message:'当前用户是'+this.userInfo.nickName as string+ //报修用户姓名
              '报修内容'+this.applyContent+//报修内容
              '报修地点'+this.applyAddress+ //报修地点
              '报修类型'+this.applyType+ //报修类型
              '期望维修类型'+this.applyExpectType+ //期望维修类型
              '期望维修时间'+this.applyExpectTime+ //期望维修时间
              '是否自己接单'+this.isOrder,})
        })
        Button('使用picker选择照片')
          .onClick(()=>{
            let uris: Array<string> = [];
            const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
            photoViewPicker.select()
              .then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
                uris = photoSelectResult.photoUris;

                AlertDialog.show({message:JSON.stringify(photoSelectResult,null,2)})
                console.info('photoViewPicker.select to file succeed and uris are:' + uris);
              })

          })

          }
        }
    .title('填写报修单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)

  }

}