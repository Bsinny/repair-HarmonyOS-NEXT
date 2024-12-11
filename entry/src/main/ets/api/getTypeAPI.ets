import { AxiosResponse } from "@ohos/axios"
import { axiosTestInstance } from "../common/utils/httpTest"

//res.data.rows
export interface getRepTypes{
  //维修类型
  repairTypeId:number
  repairType:string
  /*sysDept
   这个有数据但是现在懒得弄*/
}
export interface getTypes{
  //期待类型
  repexpectTypeId:number
  repexpectType:string

}


export interface getTypeResponse<T>{
  total:number
  code:number
  msg:string
  rows:T
}
export type GetTypeResponseData<T = null> = AxiosResponse<getTypeResponse<T>,null>

//todo: 新建一个axios实例管理表格类的东西

export function getType(){
  axiosTestInstance.get<null,GetTypeResponseData<getTypes>,null>('/api/repair/type/list')

}
export function getRepType(){
  axiosTestInstance.get<null,GetTypeResponseData<getRepTypes>,null>('/api/repair/reptype/list')
}