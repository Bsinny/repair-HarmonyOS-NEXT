import { typeItem } from '../../api/getTypeAPI';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct NewTestPage {


  build() {
    Column() {

      Column({space:10}){

        Row({space:10}){
          Text('报修类型:')
          Text('haha')


        }.margin(10)
        Divider().strokeWidth(3).color('#F1F3F5')
        Row({space:10}){
          Text('报修地点:')
            .fontSize(16)
            .fontWeight(500)
          Text('haha')
            .fontSize(16)
            .fontWeight(500)

        }.margin(5)
        Row({space:10}){
          Text('报修时间:')
            .fontSize(16)
            .fontWeight(500)
          Text('haha')
            .fontSize(16)
            .fontWeight(500)

        }.margin(5)
        Row({space:10}){
          Text('报修状态:')
            .fontSize(16)
            .fontWeight(500)
          Button('丽丽')
          Button('丽丽')

        }.margin(5)
        .height(30)
      }.width('90%')
      .alignItems(HorizontalAlign.Start)
      .backgroundColor($r('app.color.background'))
      .borderStyle(BorderStyle.Solid).borderWidth(2).borderColor(0xAFEEEE).borderRadius(10)
      .align(Alignment.Center)



    }

    }
    }
