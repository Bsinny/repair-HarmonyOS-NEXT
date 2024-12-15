import { typeItem } from '../../api/getTypeAPI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct NewTestPage {
  @State message: string = 'Hello World';
  @State typeList: typeItem[] = [
    { repairTypeId: 1, repairType: '换新' },
    { repairTypeId: 2, repairType: '换配件' },
    { repairTypeId: 3, repairType: '维修' }
  ];
  @State select: number = 0
  private selectedTypeIndex: number | number[] = -1;

  build() {
    RelativeContainer() {
/*      Text(this.message)
        .id('NewTestPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })*/
      if (this.typeList.length > 0) {
        TextPicker({
          range: this.typeList.map(item => item.repairType),
          selected: this.selectedTypeIndex,
        })
          .onChange((value, index) => {
            this.selectedTypeIndex = index;
            promptAction.showToast({ message: '当前索引是' + this.selectedTypeIndex + '选择的是' + value });
          })
      } else {
        Text('loading....')
      }
    }
    .height('100%')
    .width('100%')
  }
}