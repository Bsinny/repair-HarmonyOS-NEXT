import { permissionManager } from '../../manager';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoPickerUtil } from '../../common/utils/photoPickerUtil';
import Index from '../Repair';
import { getImagePaths } from '../../common/utils/imageUpload';

@Entry
@Component
struct MediaLibraryKitTestPage {
  @State isAuth:boolean =false;
  @State photoAccessUri:string='';
  @State photoAccessCount:number=0;
  @State photoUris:string[]=[];
  @State imgUri:string='';
  @State fileList: string[] = []; // 新增状态用于存储已选图片路径
  @State limit: number = 5; // 设置最大可选图片数量限制
  aboutToAppear(): void {
    this.requestPermission()
 }
  async requestPermission(){
      this.isAuth=await permissionManager.requestPermissions([
        'ohos.permission.READ_IMAGEVIDEO',
        'ohos.permission.WRITE_IMAGEVIDEO'
      ])


  }
  build() {
    Navigation(){
      Scroll(){
        Column({space:20}){
          Text('图库是否开启:'+this.isAuth)
          Button('获取图库资源').onClick(async ()=>{
            //获取图库管理器
            const phAccessHelper=photoAccessHelper.getPhotoAccessHelper(getContext())
            const predicates =new dataSharePredicates.DataSharePredicates();
            //获取图库资源的核心api
            const fetchResult=await phAccessHelper.getAssets({
              fetchColumns:[],
              predicates:predicates
            })
            this.photoAccessCount=fetchResult.getCount()
            const photoAsset=await fetchResult.getFirstObject()
            this.photoAccessUri=photoAsset.uri
            console.log('fetchResult'+this.photoAccessUri)

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
/*          Image(this.photoAccessUri)
            .width(200)*/
/*
          ForEach(this.photoUris,(item:string)=>{
            Row(){
                  Image(item)
                    .width(200)

            }

          })
*/
/*

          Button('使用封装的组件选择照片')
            .onClick(async ()=>{
              const res=await photoPickerUtil()
              this.imgUri=res as string

            })
          Image(this.imgUri)
            .width("100%")
            .height(200)*/
          // 使用Index组件展示已选图片
          /*Index({
            fileList: this.fileList,
            limit: this.limit,
            deleteImage: this.imgUri*//*(imgPath: string) => {
              // 移除图片逻辑
              this.fileList = this.fileList.filter(img => img !== imgPath);
            },*//*

          }).margin({ top: 20 });*/

          Button('选择照片')
            .onClick(async ()=>{
              const res=await getImagePaths(3)
              AlertDialog.show({message:res.fileList.length.toString()})

            })

        }
      }
    }
    .height('100%')
    .width('100%')
  }
}