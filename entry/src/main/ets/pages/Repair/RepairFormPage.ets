import { getRepTypeListAPI, getRepTypes, getTypeListAPI, getTypes, repTypeItem, typeItem } from '../../api/getTypeAPI';
import { prompt, promptAction } from '@kit.ArkUI';

@Entry
@Component
struct RepairFormPage {
  @State message: string = 'Hello World';
  @State applyAddress:string= '提瓦特大陆';
  @State applyContent:string= '提瓦特大陆里面玩不了原神搞得积极洋洋的';
/*  @State typeList:getTypes={}
  @State repTypeList:getRepTypes={}*/
  @State typeList:typeItem[]=[]
/*  @State typeList: typeItem[] = [
    { repairTypeId: 1, repairType: '换新' },
    { repairTypeId: 2, repairType: '换配件' },
    { repairTypeId: 3, repairType: '维修' }
  ];*/
  @State repTypeList:repTypeItem[]=[]
  @State select: number = 0
  private selectedTypeIndex: number | number[] = -1;
  private selectedRepTypeIndex:number | number[] = -1;
  @State isShowTypeSheet: boolean = false;
  @State isShowRepTypeSheet: boolean = false;


  //获取报修类型
  async getTypeList(){
    try {
      const res = await getTypeListAPI();
      if (res.data && Array.isArray(res.data.rows)) {
        this.typeList = res.data.rows as typeItem[]
        /*AlertDialog.show({message:JSON.stringify(this.typeList,null,2)})*/
        this.typeList.forEach((item, index) => {
          console.log(`getTypeListItem is${index}:`, JSON.stringify(item));
        });
      } else {
        console.error('Invalid response format for typeList');
      }
    } catch (error) {
      console.error('Failed to fetch typeList:', error);
    }
   /* const res =await getTypeListAPI()

    this.typeList=res.data.rows*/
/*
    AlertDialog.show({message:JSON.stringify(this.typeList.length,null,2)})*/

  }
  async getRepTypeList(){

    try {
      const res = await getRepTypeListAPI();
      if (res.data && Array.isArray(res.data.rows)) {
        this.repTypeList = res.data.rows as repTypeItem[];
        /*this.typeList.forEach((item, index) => {
          console.log(`getRepTypeList is${index}:`, JSON.stringify(item));
        });*/
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
/*    AlertDialog.show({message:'typeList的参数是'+JSON.stringify(this.typeList.length,null,2)+',repTypeList的参数是'
    +JSON.stringify(this.repTypeList.length,null,2)})*/

  }


  build() {

    Navigation() {
      Column({space:20}){
        Text('原神')
              TextInput({
                placeholder:'报修地点',
                text:this.applyAddress
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
                text:this.applyContent
              })
                .height(150)
                .fontSize(14)
                .backgroundColor(Color.Transparent)
                .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
                .padding(0)
                .onChange((value) => {
                  this.applyAddress = value
                })





              if (this.typeList.length > 0) {
                TextPicker({

                  range: this.typeList.map(item => item.repairType),
                  selected: this.selectedTypeIndex,
                })
                  .onChange((value, index) => {
                    this.selectedTypeIndex = index;
                    promptAction.showToast({ message: '当前维修类型索引是' + this.selectedTypeIndex + '选择的是' + value });
                  })
              } else {
                Text('loading....')
              }


              if (this.repTypeList.length > 0) {
                TextPicker({
                  range: this.repTypeList.map(item => item.repexpectType),
                  selected: this.selectedRepTypeIndex,
                })
                  .onChange((value, index) => {
                    this.selectedTypeIndex = index;
                    promptAction.showToast({ message: '当前期待维修的索引是' + this.selectedTypeIndex + '选择的是' + value });
                  })
              } else {
                Text('loading....')
              }

          }
        }


    .title('填写报修单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)

  }

}