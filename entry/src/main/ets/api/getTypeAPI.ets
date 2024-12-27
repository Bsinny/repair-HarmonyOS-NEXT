import { AxiosResponse, FormData } from "@ohos/axios"
import { axiosInstance } from "../common/utils/httpInstance"

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

export interface applyFormResponse{
  msg:string,
  applyId:number,
  code:number,
  repairId:number
}

export interface RepairAppImg{
  appimgId:number,
  appId:number,
  /** 图片上传时间 */
  appimgCreateTime:Date
}
export interface applyForm{
  applyUser: string, //报修用户姓名
  applyContent: string, //报修内容
  applyAddress: string, //报修地点
  applyType: number, //报修类型
  applyExpectType: number, //期望维修类型
  applyExpectTime: Date, //期望维修时间
  isOrder: number,
}

export interface getTypeResponse<T>{
  total:number
  code:number
  msg:string
  rows:T[]
}


export type GetTypeResponseData<T = null> = AxiosResponse<getTypeResponse<T>,null>


//后端自己设置错误服了，两个类型的请求地址反了，导致拿不下来
export function getTypeListAPI(){
  return axiosInstance.get<null,GetTypeResponseData<typeItem>,null>
  ('/api/repair/reptype/list')

}
export function getRepTypeListAPI(){
  return axiosInstance.get<null,GetTypeResponseData<repTypeItem>,null>
  ('/api/repair/type/list')
}

export function postApplyForm(val:number,data:applyForm){
  return axiosInstance.post<null,AxiosResponse<applyFormResponse,null>,applyForm>
  ('/api/repair/apply/'+val,data)

}
export function postApplyPhoto(data:FormData){
    return axiosInstance.post<null,GetTypeResponseData,FormData>
  ('/api/repair/appimg/add',data)

}



/*
export function getMyRepairListAPI(repairIsDelete:number,curWork:number,){
  return axiosTestInstance.post<null,GetTypeResponseData,FormData>
  ('repair/tb/myrepairs')
}*/
