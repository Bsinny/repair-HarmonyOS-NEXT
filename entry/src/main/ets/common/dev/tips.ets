import { promptAction } from '@kit.ArkUI'

export function showDevelopingTips() {
  promptAction.showToast({ message: '功能开发中，敬请期待' })
}
export function showRoleTips() {
  promptAction.showToast({ message: '当前用户权限不足，该功能无法使用' })
}