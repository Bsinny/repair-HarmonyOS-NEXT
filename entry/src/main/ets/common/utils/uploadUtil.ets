import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl, { Context, Permissions } from '@ohos.abilityAccessCtrl';

//校验应用是否授予权限
//@params permissions:权限名称数组
//@return permissionabilityAccessCtrl:权限名称
async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = 0;

  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (err) {
    console.error(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (err) {
    console.error(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
  }

  return grantStatus;
}


//检查用户权限
//@params permissions:权限名称数组
export  async function checkPermissions(permissions: Permissions): Promise<boolean> {
  try {
    let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions);
    return grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
  }
  catch (e) {
    return Promise.reject(e)
  }
}
