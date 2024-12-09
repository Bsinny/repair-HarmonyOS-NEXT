import { axiosTestInstance } from "../common/utils/httpTest"


export interface getRepTypes{
  repairTypeId:number
  repairType:string
  /*sysDept
   这个有数据但是现在懒得弄*/
}
export interface getTypes{
  repexpectTypeId:number
  repexpectType:string

}


export interface getTypeResponse<T>{
  total:number
  code:number
  msg:string
  rows:T
}

//todo: 新建一个axios实例管理表格类的东西

export function getType(){
  axiosTestInstance.get('/api/repair/type/list')

}
export function getRepType(){
  axiosTestInstance.get('/api/repair/reptype/list')
}