import { axiosInstance } from "../common/utils/httpInstance";
import { getTypeResponse, GetTypeResponseData } from "./getTypeAPI";

export interface RepairItem{
  repairId: number;
  repairNo: string;
  repairAddress: string;
  repairContent: string;
  repairMoney?: number;
  repairType: number;
  repairExpectType: number;
  repairExpectTime: Date;
  repairState: number;
  repairedState: number;
  repairDestory: number;
  repairTransfer: number;
  repairComment: number;
  curWork: number;
  repairDep: number;
  applyId: number;
  repairDestoryTime?: Date | null;
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
  appImgList:repImgItem[];
  /*repImgList: any[]; // 如果有具体类型，请替换为实际类型
   any[]; // 如果有具体类型，请替换为实际类型
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
  appimgCreateTime: Date,
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
/**
 * 待维修表
 * /api/repair/tb/myrepairs?repairIsDelete=0&curWork=1&repairDestory=0
 * 已维修表
 * /api/repair/tb/myrepairs?repairIsDelete=0&curWork=1&repairDestory=1
 * @param params
 * @returns
 */
export function getMyRepairListAPI(
  params:myRepairData
){
  return axiosInstance.get<null, GetTypeResponseData<RepairItem>,myRepairData>(
    '/api/repair/tb/myrepairs',{params}

  );
}