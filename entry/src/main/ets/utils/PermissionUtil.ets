// 来验证是否有权限
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

async function checkPermissionGrant(permission:Permissions):Promise<abilityAccessCtrl.GrantStatus>{
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
  let tokenId: number = 0;

  try {
    // 拿到应用信息
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    // 应用信息 。accessTokenId tokenId
    tokenId = appInfo.accessTokenId;
    let bundleName = bundleInfo.name // 打开指定应用的详情页面

  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
  }

  return grantStatus;
}

// 完整的过程
export async function checkPermissions(permissions:Array<Permissions>,context:common.UIAbilityContext): Promise<boolean> {
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkPermissionGrant(permissions[0]);
  if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    // 已经授权，可以继续访问目标操作
    //   已经有权限了，可以操作
    console.log('testTag PERMISSION_GRANTED')
    return true
  } else {
    // 申请权限
    //   手动申请
    console.log('testTag PERMISSION_DENIED')
    return  await reqPermissionsFromUser(permissions,context)
  }
}

async  function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext) {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let bool:boolean=false
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  await atManager.requestPermissionsFromUser(context, permissions).then(async (data) => {
    // 授权的结果 数组
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作
        console.log('testTag  requestPermissionsFromUser PERMISSION_GRANTED')
        bool=true
        return
        //   使用麦克风
      } else {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        console.log('testTag  requestPermissionsFromUser PERMISSION_DENIED')

        atManager.requestPermissionOnSetting(context, ['ohos.permission.MICROPHONE']).then((data: Array<abilityAccessCtrl.GrantStatus>) => {
          console.info('data:' + JSON.stringify(data));
        }).catch((err: BusinessError) => {
          console.error('data:' + JSON.stringify(err));
        });

        return
      }
    }
    // 授权成功
  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
  })
  return bool

}