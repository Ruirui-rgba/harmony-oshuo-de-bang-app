import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import preferencesUtil from '../utils/PreferencesUtil';

let windowStage_: window.WindowStage | null = null;
let sub_windowClass: window.Window | null = null;
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }
  // showSubWindow() {
  //   let time=0
  //   // 1.创建应用子窗口。
  //   if (windowStage_ == null) {
  //     console.error('Failed to create the subwindow. Cause: windowStage_ is null');
  //   }
  //   else {
  //     windowStage_.createSubWindow("mySubWindow", (err: BusinessError, data) => {
  //       let errCode: number = err.code;
  //       if (errCode) {
  //         console.error('Failed to create the subwindow. Cause: ' + JSON.stringify(err));
  //         return;
  //       }
  //       sub_windowClass = data;
  //       console.info('Succeeded in creating the subwindow. Data: ' + JSON.stringify(data));
  //       sub_windowClass.setUIContent("pages/Appstart", (err: BusinessError) => {
  //         let errCode: number = err.code;
  //         if (errCode) {
  //           console.error('Failed to load the content. Cause:' + JSON.stringify(err));
  //           return;
  //         }
  //         console.info('Succeeded in loading the content.');
  //         // 3.显示子窗口。
  //         (sub_windowClass as window.Window).showWindow((err: BusinessError) => {
  //           let errCode: number = err.code;
  //           if (errCode) {
  //             console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
  //             return;
  //           }
  //           console.info('Succeeded in showing the window.');
  //         });
  //       });
  //
  //       let timeout=setInterval(()=>{
  //         time++
  //         if (time == 5) {
  //           this.destroySubWindow()
  //           clearInterval(timeout)
  //         }
  //       },1000)
  //     })
  //   }
  // }
  // destroySubWindow() {
  //   // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
  //   (sub_windowClass as window.Window).destroyWindow((err: BusinessError) => {
  //     let errCode: number = err.code;
  //     if (errCode) {
  //       console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
  //       return;
  //     }
  //     console.info('Succeeded in destroying the window.');
  //   });
  // }
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage_ = windowStage
    preferencesUtil.initPreference(this.context,'HuoDeBang')
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      // this.showSubWindow()
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    // this.destroySubWindow()
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
