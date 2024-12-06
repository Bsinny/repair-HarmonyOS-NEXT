import { AxiosResponse } from "@ohos/axios"
import { axiosTestInstance, AxiosTestResponseData } from "../common/utils/httpTest"



export const LOGIN_TOKEN ='LOGIN_TOKEN'
export const USER_INFO='USER_INFO'

export interface loginTestInfo{
  username?:string
  password?:string
}

export interface LoginResponseInfo{
  msg?:string
  code?:number
  token?:string
}
export interface TestResponseInfo/*<TestUserInfo>*/{
  msg:string
  code:number
  deptName:string
  permissions:string[]
  user:TestUserInfo

}
export interface TestUserInfo {
  /*searchValue?: string;//注释的都是null值 */
  createBy?: string;
  createTime?: string;
  /*updateBy?: string;*/
  /*updateTime?: string;*/
  /*remark?: string;*/
  /*params?: Record<string, string>;*/
  userId?: number;
  deptId?: number;
  userName?: string;
  nickName?: string;
  email?: string;
  phonenumber?: string;
  sex?: string;
  avatar?: string;
  /*salt?: string;*/
  status?: string;
  delFlag?: string;
  loginIp?: string;
  loginDate?: Date;
  state?: number;
  /*grantid?: string;*/
  // todo: 嵌套Dept属性
  /*dept?: Dept;  //这个太复杂稍后再做决定*/
  /*roles?: Role[];*/
/*  roleIds?: string;
  postIds?: string;
  roleId?: string;*/
  admin?: boolean;
}
export interface Dept {
  searchValue?: string;
  createBy?: string;
  createTime?: string;
  updateBy?: string;
  updateTime?: string;
  remark?: string;
  params?: Record<string, string>;
  deptId: number;
  parentId: number;
  ancestors?: string;
  deptName: string;
  orderNum: string;
  leader: string;
  phone?: string;
  email?: string;
  status: string;
  delFlag?: string;
  parentName?: string;
  children: string[];
}
export interface Role {
  searchValue?: string;
  createBy?: string;
  createTime?: string;
  updateBy?: string;
  updateTime?: string;
  remark?: string;
  params?: Record<string, string>;
  roleId: number;
  roleName: string;
  roleKey: string;
  roleSort: string;
  dataScope: string;
  menuCheckStrictly: boolean;
  deptCheckStrictly: boolean;
  status: string;
  delFlag?: string;
  flag: boolean;
  menuIds?: string;
  deptIds?: string;
  admin: boolean;
}
export function postTestUserLoginPasswdAPI(data: loginTestInfo) {
  return axiosTestInstance.post
  <null, AxiosResponse<LoginResponseInfo,null>, loginTestInfo>
  ('/login', data)
}
export function getTestUserInfoAPI() {
  return axiosTestInstance.get
  <null,/*AxiosTestResponseData<TestUserInfo>*/ AxiosResponse<TestResponseInfo,null>,null>
  ('/getInfo')
}

/*
export function getUserInfoAPI() {
  return axiosInstance.get
  <null, AxiosResponseData<UserInfoResponse>, null>
  ('/user/me')
}*/
