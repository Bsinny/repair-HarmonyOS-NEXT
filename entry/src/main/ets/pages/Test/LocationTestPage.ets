import { isRegExp } from '@wolfx/lodash';
import { permissionManager } from '../../manager';
import { geoLocationManager } from '@kit.LocationKit';
import { bundleManager } from '@kit.AbilityKit';


@Entry
@Component
struct LocationTestPage {
  @State isGrant:boolean=false
  @State location:geoLocationManager.Location|null=null
  aboutToAppear(): void {
  this.requestPermissions()
  }

  async requestPermissions(){
    const res=await permissionManager.requestPermissions([
      'ohos.permission.LOCATION'
    ])
    this.isGrant=res
  }

  build() {
    Navigation(){
      Scroll(){
        Column({space:10}){
          Text(`是否授权${this.isGrant}`)
          Text('当前位置为'+JSON.stringify(this.location,null,2))

          Button('获取当前为位置')
            .onClick(async ()=>{
              this.location=await geoLocationManager.getCurrentLocation()

            })

          Button('判断地理编码于逆地理编码服务是否可用')
            .onClick(()=>{
              const isAvailable=geoLocationManager.isGeocoderAvailable()
              AlertDialog.show({message:'是否支持'+JSON.stringify(isAvailable,null,2)})
            })
          Button('转地址')
            .onClick(async ()=>{
              let flag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO;
              let bundleInfo = bundleManager.getBundleInfoForSelfSync(flag)
              let appId = bundleInfo.signatureInfo.appId;
              console.log('yuanshenwwww',JSON.stringify(appId,null,2))
              AlertDialog.show({message:JSON.stringify(appId,null,2)})
            })

          Button('高德地理编码')
            .onClick(async ()=>{


            })


        }
        .constraintSize({minHeight:'100%'})
      }

    }
    .title('Location测试页')
    .titleMode(NavigationTitleMode.Mini)
    .height('100%')
    .width('100%')
  }
}