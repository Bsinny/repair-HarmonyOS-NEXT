@Entry
@Component
struct SwiperTestPage {
  @State message: string = 'Hello World';

  build() {
    Swiper() {
      Text('0')
        .width('90%')
        .height('100%')
        .backgroundColor(Color.Gray)
        .textAlign(TextAlign.Center)
        .fontSize(30)

      Text('1')
        .width('90%')
        .height('100%')
        .backgroundColor(Color.Green)
        .textAlign(TextAlign.Center)
        .fontSize(30)

      Text('2')
        .width('90%')
        .height('100%')
        .backgroundColor(Color.Pink)
        .textAlign(TextAlign.Center)
        .fontSize(30)

    }
    .height(200)
    .loop(true)
    .autoPlay(true)
    .interval(1000)
  }
}