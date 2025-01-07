import { LengthMetrics } from '@kit.ArkUI'
import { getImagePaths } from '../../common/utils/imageUpload'
import { UploadImages } from '../models/commonModels'



@Component
export default struct SelectImage {
  aboutToAppear(): void {
    this.previewImageList = [...this.fileList] // 渲染
  }

  @Link fileList: string []
  @State previewImageList: string [] = [] // 子组件内部维护预览图片列表
  @Prop limit: number = 1
  @State uploadImages: UploadImages = { fileList: [], previewImageList: [] }
  @State imageSize: number = 100
  @Prop flexAlign: FlexAlign = FlexAlign.Start
  /*@Link deleteImage: string*/
  @Prop deleteImage?: (imgPath: string) => void;

  @Prop title: string = ''
  deleteImg = () => {}


  build() {
    Column() {
      if (this.title != '') {
        Row() {
          Text(this.title)
            .fontSize(18)
            .fontWeight(500).fontColor('#333')
          Text(`${this.fileList.length} / ${this.limit}`).fontColor('#999')
        }.width('100%').justifyContent(FlexAlign.SpaceBetween).margin({ bottom: 10 })
      }

      Flex({
        wrap: FlexWrap.Wrap,
        space: { main: LengthMetrics.px(50), cross: LengthMetrics.px(50) },
        justifyContent: this.flexAlign
      }) {
        ForEach(this.previewImageList, (item: string, index: number) => {
          RelativeContainer() {
            Image(item).width('100%').height('100%').borderRadius(5)
            Image($r("app.media.delete_img")).width(30).height(30)
              .alignRules({
                top: { anchor: "__container__", align: VerticalAlign.Top },
                right: { anchor: "__container__", align: HorizontalAlign.End }
              })
              .onClick(() => {
                this.fileList.splice(index, 1);
                this.previewImageList.splice(index, 1);
                if (this.deleteImg) this.deleteImg();
                // 调用父组件的删除方法
                /*
                 this.deleteImage = item
                                // 根据索引删除
                                this.fileList.splice(index, 1)
                                this.previewImageList.splice(index, 1)

                                this.deleteImg() // 父组件删除图片操作*/

              })
          }
          .width(this.imageSize)
          .height(this.imageSize)
        }, (item: string) => item)
        if (this.previewImageList.length < this.limit) {
          Image($r('app.media.add_img')).width(this.imageSize).height(this.imageSize).borderRadius(5)
            .onClick(async () => {
              this.uploadImages = await getImagePaths(this.limit - this.previewImageList.length) // 选择后还能选择多少图片个数
              console.log(JSON.stringify(this.uploadImages))
              this.fileList.push(...this.uploadImages.fileList) // 添加上传图片路径
              this.previewImageList.push(...this.uploadImages.previewImageList) // 添加展示图片

            })
        }


      }
    }

  }
}