import { AxiosResponse, FormData } from "@ohos/axios"
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

export interface RepairItem{
  repairId: number;
  repairNo: string;
  repairAddress: string;
  repairContent: string;
  repairMoney?: number;
  repairType: number;
  repairExpectType: number;
  repairExpectTime: string;
  repairState: number;
  repairedState: number;
  repairDestory: number;
  repairTransfer: number;
  repairComment: number;
  curWork: number;
  repairDep: number;
  applyId: number;
  repairDestoryTime?: string | null;
  repairCreateTime: string;
  repairIsDelete: number;
  repairYear: number;
  repairMonth: number;
  repairDay: number;
  repairName: string;
  repaireName?: string | null;
  repaireId?: number | null;
  repType: RepType;
  apply: Apply;
  repImgList?: repImgItem[];
  /*repImgList: any[]; // 如果有具体类型，请替换为实际类型
  appImgList: any[]; // 如果有具体类型，请替换为实际类型
  processList: any[]; // 如果有具体类型，请替换为实际类型
  repcomment?: any; // 如果有具体类型，请替换为实际类型*/
}
interface Apply {
  applyId?: number | null;
  applyNo?: string | null;
  applyAddress?: string | null;
  applyContent?: string | null;
  applyType?: string | null;
  applyExpectType?: string | null;
  applyExpectTime?: string | null;
  applyDep?: number | null;
  applyUser: string;
  applyRole: string;
  applyUserid: number;
  applyCreateTime?: string | null;
  applyIsDelete?: number | null;
/*  appImgList?: any[]; // 如果有具体类型，请替换为实际类型
  processList?: any[]; // 如果有具体类型，请替换为实际类型*/
  /*repImgList?: repImgItem[]; // 如果有具体类型，请替换为实际类型*/
}
interface repImgItem{

  appimgId: number,
  appId: number,
  appimgName: string,
  appimgPath: string,
  /*appimgCreateTime": "2024-12-25 08:57:34",*/
  appimgIsDeleted: number
}
interface RepType {
  repairTypeId?: number | null;
  repairType: string;
  repairDep?: number | null;
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

export function postApplyForm(val:number,data:applyForm){
  return axiosTestInstance.post<null,AxiosResponse<applyFormResponse,null>,applyForm>
  ('/api/repair/apply/'+val,data)

}
export function postApplyPhoto(data:FormData){
    return axiosTestInstance.post<null,GetTypeResponseData,FormData>
  ('/api/repair/appimg/add',data)

}

export interface myRepairData{
  repairIsDelete: number,
  curWork: number,
  repairDestory?: number

}
export function getMyRepairListAPI(
  data:myRepairData
/*  repairIsDelete: number,
  curWork: number,
  repairDestory?: number*/
){
/*  const params = new URLSearchParams({
    repairIsDelete: repairIsDelete.toString(),
    curWork: curWork.toString(),
    ...(repairDestory !== undefined && { repairDestory: repairDestory.toString() })
  });*/

  return axiosTestInstance.get<null, getTypeResponse<RepairItem>,myRepairData >(
    '/api/repair/tb/myrepairs',{params:{repairIsDelete:data.repairIsDelete,curWork:data.curWork,repairDestory:data.repairDestory}}

  );
}

/*
export function getMyRepairListAPI(repairIsDelete:number,curWork:number,){
  return axiosTestInstance.post<null,GetTypeResponseData,FormData>
  ('repair/tb/myrepairs')
}*/
