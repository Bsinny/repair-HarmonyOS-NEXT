import { Dept, findAllDeptAPI, findAllRoleAPI, Role, UserInfo, userRegisterAPI,
  USER_INFO } from '../../api/userInfoAPI';
import { promptAction, router } from '@kit.ArkUI';
import { permissionManager } from '../../manager';

@Entry
@Component
struct UserRegisterPage {
  @StorageLink(USER_INFO) userInfo: UserInfo = {}  as UserInfo;
  @State allDeptList:Dept[]=[];
  @State selectedDeptName:string='请选择'
  @State selectedDeptId:number|number[]=-1;
  @State allRoleList:Role[]=[];
  @State selectedRoleName:string='请选择'
  @State selectedRoleId:number|number[]=-1;
  @State email:string='';
  @State nickName:string='';
  @State passWord:string='';
  @State phonenumber:string='';
  @State userName:string='';
  //后端要求传一个depId的number类型的depName
  @State depName:number=-1;
  //后端同样要求向depName一样
  @State roleName:number=-1;
  @State selectedSexName:string = '请选择';
  @State showEmailError: boolean = false;
  @State showPhoneError: boolean = false;
  // 其他错误状态...

  @State sex:number=-1;
  sexes:string[]=['男','女']


  async registerUser(){
    const res=await userRegisterAPI(
      {
        deptName:this.depName,
        email: this.email,
        nickName: this.nickName,
        passWord: this.passWord,
        phonenumber: this.phonenumber,
        roleName: this.roleName,
        sex: this.sex,
        userName: this.userName,
      }
    )
    router.back();
    promptAction.showToast({ message: res.data.msg })

  }
  cleanUserForm(){
    this.depName=-1
    this.email=''
    this.nickName=''
    this.passWord=''
    this.phonenumber=''
    this.roleName=-1
    this.sex=-1
    this.userName=''

  }
  async getAllDeptList() {
    try {
      const res = await findAllDeptAPI();
      if (res.data && Array.isArray(res.data.data)) {
        this.allDeptList = res.data.data as Dept[];
      } else {
        console.error('Invalid response format for allDeptList');
      }
    } catch (error) {
      console.error('Failed to fetch allDeptList:', error);
    }
  }
  async getAllRoleList() {
    try {
      const res = await findAllRoleAPI();
      if (res.data && Array.isArray(res.data.data)) {
        this.allRoleList = res.data.data as Role[];
      } else {
        console.error('Invalid response format for allDeptList');
      }
    } catch (error) {
      console.error('Failed to fetch allDeptList:', error);
    }
  }
  async aboutToAppear(): Promise<void> {
    console.log('aboutToAppear called');
    await this.getAllDeptList();
    await this.getAllRoleList();


  }
  private updateSelectedRole(index: number): void {
    if (index >= 0 && index < this.allRoleList.length) {
      const selectedRole = this.allRoleList[index];
      this.selectedRoleId = selectedRole.roleId; // 更新为实际的角色ID
      this.selectedRoleName = selectedRole.roleName; // 更新为实际的角色名称
      this.roleName = this.selectedRoleId; // 后端需要的是角色ID
/*      AlertDialog.show({
        message: `选择的是 ${this.selectedRoleName} 索引值是 ${this.roleName}`
      });*/
    } else {
      console.error('Invalid index provided');
    }
  }
  // 更新选中的部门信息
  private updateSelectedDepartment(index: number): void {
    if (index >= 0 && index < this.allDeptList.length) {
      const selectedDept = this.allDeptList[index];
      this.selectedDeptId = selectedDept.deptId; // 更新为实际的部门ID
      this.selectedDeptName = selectedDept.deptName; // 更新为实际的部门名称
      this.depName = this.selectedDeptId; // 后端需要的是部门ID
/*      AlertDialog.show({
        message: `选择的是 ${this.selectedDeptName} 索引值是 ${this.depName}`
      });*/
    } else {
      console.error('Invalid index provided');
    }
  }
  // 在UserRegisterPage结构体内添加以下代码
  private isFormValid(): boolean {
    // 基础字段非空验证
    const basicFieldsValid =
      this.userName.trim().length > 0 &&
        this.nickName.trim().length > 0 &&
        this.passWord.trim().length >= 6 && // 密码至少6位
        this.phonenumber.trim().length >= 11 && // 手机号11位
        this.email.trim().length > 0;

    // 选择项验证
    const selectionValid =
      this.sex !== -1 &&
        this.depName !== -1 &&
        this.roleName !== -1;

    // 邮箱格式验证
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const isEmailValid = emailRegex.test(this.email);

    // 手机号格式验证（简单版）
    const phoneRegex = /^1[3-9]\d{9}$/;
    const isPhoneValid = phoneRegex.test(this.phonenumber);

    return basicFieldsValid && selectionValid && isEmailValid && isPhoneValid;
  }
  private showValidationToast(): void {
    if (!this.userName.trim()) {
      promptAction.showToast({ message: '请输入用户名', duration: 1500 });
      return;
    }
    if (!this.passWord.trim() || this.passWord.length < 6) {
      promptAction.showToast({ message: '密码需至少6位', duration: 1500 });
      return;
    }
    if (!/^1[3-9]\d{9}$/.test(this.phonenumber)) {
      promptAction.showToast({ message: '请输入正确手机号', duration: 1500 });
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)) {
      promptAction.showToast({ message: '邮箱格式不正确', duration: 1500 });
      return;
    }
    if (this.sex === -1) {
      promptAction.showToast({ message: '请选择性别', duration: 1500 });
    }
  }
  build() {
    Navigation() {
      Column({space:20}){

        Row({ space: 15 }) { // 使用 space 属性来增加间距
          Text('用户姓名:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          TextInput({
            placeholder: '请输入用户姓名',

          })
            .type(InputType.Normal)
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .border({ width: 1, color: $r('app.color.border_light') })
            .padding(10)
            .onChange((value) => {
              this.nickName = value;
            });
        }
        .width('100%')
        .height(60)
        Row({ space: 10 }) {
          Text('性别:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          Text(this.selectedSexName)
            .margin(20)
            .onClick(()=>{
              TextPickerDialog.show({
                range: this.sexes,
                selected: this.sex,
                disappearTextStyle: { color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } },
                textStyle: {
                  color: $r('app.color.font'),
                  font: { size: 18, weight: FontWeight.Medium }
                },
                selectedTextStyle: {
                  color: $r('app.color.primary'),
                  font: { size: 20, weight: FontWeight.Bold }
                },
                onAccept: (values: TextPickerResult) => {
                  this.sex=values.index as number
                  this.selectedSexName=values.value as string
                  /*promptAction.showToast({ message: '选择的性别是:' +this.selectedSexName+'索引值是:'+this.sex})*/
                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()");
                },
              });

            })
        }
        .width('100%')
        .height(60)
        Row({ space: 15 }) { // 使用 space 属性来增加间距
          Text('用户邮箱:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          TextInput({
            placeholder: '请输入用户邮箱',

          })
            .type(InputType.Email)
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .border({ width: 1, color: $r('app.color.border_light') })
            .padding(10)
            .onChange((value) => {
              this.email = value;
            });
        }
        .width('100%')
        .height(60)
        Row({ space: 15 }) { // 使用 space 属性来增加间距
          Text('用户号码:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          TextInput({
            placeholder: '请输入用户号码',

          })
            .type(InputType.PhoneNumber)
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .border({ width: 1, color: $r('app.color.border_light') })
            .padding(10)
            .onChange((value) => {
              this.phonenumber = value;
            });
        }
        .width('100%')
        .height(60)

        Row({ space: 15 }) { // 使用 space 属性来增加间距
          Text('用户账号:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          TextInput({
            placeholder: '请输入用户账号',

          })
            .type(InputType.Normal)
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .border({ width: 1, color: $r('app.color.border_light') })
            .padding(10)
            .onChange((value) => {
              this.userName = value;
            });
        }
        .width('100%')
        .height(60)

        Row({ space: 15 }) { // 使用 space 属性来增加间距
          Text('用户密码:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          TextInput({
            placeholder: '请输入用户密码',

          })
            .type(InputType.Password)
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .border({ width: 1, color: $r('app.color.border_light') })
            .padding(10)
            .onChange((value) => {
              this.passWord = value;
            });
        }
        .width('100%')
        .height(60)

        Row({ space: 15 }) { // 使用 space 属性来增加间距
          Text('用户角色:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          Text(this.selectedRoleName)
            .layoutWeight(1)
            .margin(20)
            .onClick(()=>{
              TextPickerDialog.show({
                range:this.allRoleList.map(item => item.roleName),

                selected: this.selectedRoleId,
                disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
                textStyle: {
                  color: $r('app.color.font'),
                  font: { size: 18, weight: FontWeight.Medium }
                },
                selectedTextStyle: {
                  color: $r('app.color.primary'),
                  font: { size: 20, weight: FontWeight.Bold }
                },
                onAccept:(values:TextPickerResult)=>{
                  this.updateSelectedRole(values.index as number);
                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()")
                },

              })

            })

        }
        .width('100%')
        .height(60)
        Row({ space: 15 }) {
          Text('学院名称:')
            .fontSize(16)
            .margin({top:20})
            .fontColor($r('app.color.font'));
          Text(this.selectedDeptName)
            .layoutWeight(1)
            .margin(20)
            .onClick(()=>{
              TextPickerDialog.show({
                range:this.allDeptList.map(item => item.deptName),
                selected: this.selectedDeptId,
                disappearTextStyle: {color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}},
                textStyle: {
                  color: $r('app.color.font'),
                  font: { size: 18, weight: FontWeight.Medium }
                },
                selectedTextStyle: {
                  color: $r('app.color.primary'),
                  font: { size: 20, weight: FontWeight.Bold }
                },
                onAccept:(values:TextPickerResult)=>{
                  this.updateSelectedDepartment(values.index as number);

                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()")
                },

              })

            })
        }
        .width('100%')
        .height(60)

        Button('注册账号')
          .width('80%')
          .height(50)
          .backgroundColor($r('app.color.primary'))
          .opacity(this.isFormValid() ? 1 : 0.5) // 根据表单状态调整透明度
          .enabled(this.isFormValid())
          /*.enabled(this.userName.length > 0 && this.passWord.length>0 && this.phonenumber.length>0&&this.email.length>0
          && this.depName!=-1&&this.sex!=-1&&this.roleName!=-1)*/
          .onClick(()=>{
            promptAction.showDialog({
              alignment:DialogAlignment.Center,
              title:'温馨提示',
              message:'确认该信息正确并且注册吗',
              buttons:[
                {text:'取消',color:$r('app.color.danger'),},
                {text:'确定',color:$r('app.color.success')}
              ]
            }).then((res)=>{
              if (res.index === 1) {
                this.registerUser()
              }
            })
          })

      }

    }
    .title('用户注册')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .height('100%')
    .width('100%')
  }
}