import { AxiosResponse } from "@ohos/axios"
import { axiosTestInstance } from "../common/utils/httpTest"

//res.data.rows
export interface typeItem{

  //报修类型
  repairTypeId?:number
  repairType?:string
}
export interface repTypeItem{

  //报修期待类型
  repexpectTypeId?:number
  repexpectType?:string
}
export interface getRepTypes{
  //
  repairTypeId?:number
  repairType?:string
  /*sysDept
   这个有数据但是现在懒得弄*/
}
export interface getTypes{
  //期待类型
  repexpectTypeId?:number
  repexpectType?:string

}


export interface getTypeResponse<T>{
  total:number
  code:number
  msg:string
  rows:T[]
}
export type GetTypeResponseData<T = null> = AxiosResponse<getTypeResponse<T>,null>

//todo: 新建一个axios实例管理表格类的东西
//后端自己设置错误服了，两个类型的请求地址反了，导致拿不下来
export function getTypeListAPI(){
  return axiosTestInstance.get<null,GetTypeResponseData<typeItem>,null>
  ('/api/repair/reptype/list')

}
export function getRepTypeListAPI(){
  return axiosTestInstance.get<null,GetTypeResponseData<repTypeItem>,null>
  ('/api/repair/type/list')
}