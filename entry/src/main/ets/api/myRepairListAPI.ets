import { axiosInstance } from "../common/utils/httpInstance";
import { getTypeResponse } from "./getTypeAPI";

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
export interface repImgItem{

  appimgId: number,
  appId: number,
  appimgName: string,
  appimgPath: string,
  /*appimgCreateTime": "2024-12-25 08:57:34",*/
  appimgIsDeleted: number
}
export interface RepType {
  repairTypeId?: number | null;
  repairType: string;
  repairDep?: number | null;
}
export interface myRepairData{
  repairIsDelete: number,
  curWork: number,
  repairDestory?: number

}
export function getMyRepairListAPI(
  params:myRepairData
){
  return axiosInstance.get<null, getTypeResponse<RepairItem>,myRepairData>(
    '/api/repair/tb/myrepairs',{params/*{repairIsDelete:data.repairIsDelete,curWork:data.curWork,repairDestory:data.repairDestory}*/}

  );
}