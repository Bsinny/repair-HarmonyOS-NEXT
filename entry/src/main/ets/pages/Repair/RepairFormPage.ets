@Entry
@Component
struct RepairFormPage {
  @State message: string = 'Hello World';
  @State applyAddress:string= '提瓦特大陆';
  @State applyContent:string= '提瓦特大陆里面玩不了原神搞得积极洋洋的';


  aboutToAppear(): void {

  }


  build() {
    Navigation() {
      Column({space:20}){
        List({space:10}){
          ListItemGroup({space:10}){
            ListItem(){
              TextInput({
                placeholder:'报修地点',
              })
                .type(InputType.Normal)
                .fontSize(14)
                .height(50)
                /*.backgroundColor(Color.Transparent)*/
                .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
                .padding(0)
                .onChange((value) => {
                  this.applyAddress = value
                })
            }
            ListItem(){
              TextArea({
                placeholder:'报修内容',
              })
                .height(150)
                .fontSize(14)
                /*.backgroundColor(Color.Transparent)*/
                .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
                .padding(0)
                .onChange((value) => {
                  this.applyAddress = value
                })

            }
          }
          ListItemGroup(){
            ListItem(){

            }
          }
        }
        .width('100%')
    }
    }
    .title('填写报修单')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)

  }

}