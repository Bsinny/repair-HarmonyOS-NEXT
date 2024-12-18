import { getRepTypeListAPI, getRepTypes, getTypeListAPI, getTypes, repTypeItem, typeItem } from '../../api/getTypeAPI';
import { prompt, promptAction } from '@kit.ArkUI';
import { values } from '@wolfx/lodash';
import dayjs from 'dayjs';
import { systemDateTime } from '@kit.BasicServicesKit';

@Entry
@Component
struct RepairFormPage {
  @State applyAddress:string= '提瓦特大陆';
  @State applyContent:string= '提瓦特大陆里面玩不了原神搞得积极洋洋的';
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


  //获取报修类型
  async getTypeList(){
    try {
      const res = await getTypeListAPI();
      if (res.data && Array.isArray(res.data.rows)) {
        this.typeList = res.data.rows as typeItem[]
/*        this.typeList.forEach((item, index) => {
          console.log(`getTypeListItem is${index}:`, JSON.stringify(item));
        });*/
      } else {
        console.error('Invalid response format for typeList');
      }
    } catch (error) {
      console.error('Failed to fetch typeList:', error);
    }

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
  @Builder
  TypeSheetBuilder() {
    Column({ space: 20 }) {
      Text('选择维修类型')
        .fontSize(16)
        .fontColor($r('app.color.font'))
        .margin({ top: 20, bottom: 50 })
      TextPicker({
        range: this.typeList.map(item => item.repairType),
        selected: this.selectedTypeIndex,
      })
        .onChange((value, index) => {
          /*this.selectedTypeIndex = index;*/
          this.selectedTypeText =value as string;
          promptAction.showToast({ message: '当前维修类型索引是' + this.selectedTypeIndex + '选择的是' + value });
        })

      Button("提交")
        .height(42)
        .backgroundColor($r('app.color.brand'))
        .width('100%')
        .onClick(() => {
          this.isShowTypeSheet=false

        })
    }
    .padding({ left: 30, right: 30 })
    .width('100%')
    .height('100%')
  }
  @Builder
  RepTypeSheetBuilder() {
    Column({ space: 20 }) {
      Text('选择期望维修类型')
        .fontSize(16)
        .fontColor($r('app.color.font'))
        .margin({ top: 20, bottom: 50 })

      TextPicker({
        range: this.repTypeList.map(item => item.repexpectType),
        selected: this.selectedRepTypeIndex,
      })
        .onChange((value, index) => {
          /*this.selectedRepTypeIndex = index;*/
          this.selectedRepTypeText =value as string;
          promptAction.showToast({ message: '当前期待维修的索引是' + this.selectedRepTypeIndex + '选择的是' + value });
        })
      Button("提交")
        .height(42)
        .backgroundColor($r('app.color.brand'))
        .width('100%')
        .onClick(() => {
          this.isShowRepTypeSheet=false

        })
    }
    .padding({ left: 30, right: 30 })
    .width('100%')
    .height('100%')
  }

  build() {

    Navigation() {
      Column({space:20}){
        Text('原神')
              TextInput({
                placeholder:'报修地点',
              })
                .type(InputType.Normal)
                .fontSize(14)
                .height(50)
                .backgroundColor(Color.Transparent)
                .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
                .padding(0)
                .onChange((value) => {
                  this.applyAddress = value
                })


              TextArea({
                placeholder:'报修内容',
              })
                .height(150)
                .fontSize(14)
                .backgroundColor(Color.Transparent)
                .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
                .padding(0)
                .onChange((value) => {
                  this.applyContent = value
                })
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
                        //索引值
                        this.selectedTypeIndex=values.index
                        //文字值
                        this.selectedTypeText=values.value as string
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
                      selected: this.selectedTypeIndex,
                      disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
                      textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
                      selectedTextStyle: {color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}},
                      onAccept:(values:TextPickerResult)=>{
                        //索引值
                        this.selectedRepTypeIndex=values.index
                        //文字值
                        this.selectedRepTypeText=values.value as string
                      },
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


          }
        }
    .title('填写报修单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)

  }

}