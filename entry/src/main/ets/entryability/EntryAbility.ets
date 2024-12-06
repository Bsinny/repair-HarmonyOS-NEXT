import { AbilityConstant, errorManager, UIAbility, Want } from '@kit.AbilityKit';
import { promptAction, window } from '@kit.ArkUI';
import { FaultLogger, hilog } from '@kit.PerformanceAnalysisKit';
import axios from '@ohos/axios';
import { BASE_URL, LOGIN_INFO, PrivacySettings } from '../common/constants';
import { privacyManager } from '@kit.StoreKit';
import { LOGIN_TOKEN, USER_INFO } from '../api/userTestAPI';

let observerId = -1
export default class EntryAbility extends UIAbility {
  //应用创建时
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    //注册错误管理器
    observerId=errorManager.on('error',{
      //应用注册后，当应用产生未捕获catch的异常时的回调，做统一的错误管理
      async onUnhandledException(errMsg){
        //获取所有故障日志，FaultLogger的故障日志会更加全面
        const logs=await FaultLogger.query(FaultLogger.FaultType.JS_CRASH)
        //提取当前的错误日志详情
        const currentFaultLog =logs[0]
        console.log('errorManager',JSON.stringify(currentFaultLog))
        //上报到服务器
        await axios.post(BASE_URL+'/log/fault/report/single',currentFaultLog)
        promptAction.showToast({
          message:'出现未知错误，已自动上报'
        })
      }
    })
  }
  //应用销毁时
  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    errorManager.off('error',observerId)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('/pages/Index'.slice(1), (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      PersistentStorage.persistProp<PrivacySettings>(LOGIN_INFO,{})
      PersistentStorage.persistProp<PrivacySettings>(LOGIN_TOKEN,{})
      PersistentStorage.persistProp<PrivacySettings>(USER_INFO,{})

    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
