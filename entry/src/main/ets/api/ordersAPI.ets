import { AxiosResponse } from "@ohos/axios";
import { axiosInstance } from "../common/utils/httpInstance";
import { getTypeResponse, GetTypeResponseData } from "./getTypeAPI";
import { GetRepairResponseData } from "./myOrdersAPI";
import { RepairItem } from "./myRepairListAPI";
import { UserInfo } from "./userInfoAPI";


interface receiveRepBody{
  applyId
    :
    number
  applyNo?
    :
    number
  repairDep
    :
    number
  repairId
    :
    number
  repairNo
    :
    string
}
interface RepListBody{
  repairIsDelete: number
  repairState: number
  curWork: number
  repairDestory: number
  repairDep: number
}
//接单
export function postReceiveRepAPI(data:receiveRepBody){
  return axiosInstance.post<null, GetTypeResponseData,receiveRepBody>(
    '/api/repair/tb/receiveRep',data
  );
}
//获取订单列表
export function getRepListAPI(params:RepListBody){
  return axiosInstance.get<null, GetTypeResponseData<RepairItem>,RepListBody>(
    '/api/repair/tb/repairpersonwaitReplist', { params }
  );
}
interface getByDeptIdUserIdForUser{
  deptId:number
}

export interface usersList{
  code: number;
  msg: string;
  data:UserInfo[]
}

/**
 * 获取当前用户的部门id，查询同部门的维修人员
 * /api/repair/tb/findByDeptIdUserIdForUser?deptId=200
 */
export function getByDeptIdUserIdForUserAPI(params:getByDeptIdUserIdForUser){
  return axiosInstance.get<null, GetRepairResponseData<UserInfo>,getByDeptIdUserIdForUser>(
    '/api/repair/tb/findByDeptIdUserIdForUser', { params }
  );
}
/**
 * 销单操作
 * http://localhost:8999/api/repair/tb/relieveRepair/515/1?processDescribe=22222
 * http://localhost:8999/api/repair/tb/relieveRepair/512/0?processDescribe=111
 * 0已修复，1已换新，2无法修复，3未修复
 */
interface processDescribeForm{
  processDescribe:string
}
//销单
export function getDestroyRepairAPI(repairId:number,repairState:number,params:processDescribeForm){
  return axiosInstance.get<null,GetRepairResponseData ,processDescribeForm>(
    `/api/repair/tb/relieveRepair/${repairId}/${repairState}`, { params }
  );
}
export interface transferRepairer{
  TrDescribe?: string
  repairId: number
  repairNo: string
  repairType: number
  applyId: number
  userId: number
  deptId: number
  userName: string
  repairDep: number
}
/**
 * http://localhost:8999/api/repair/tb/transferRepair?TrDescribe=2222&repairId=527
 * &repairNo=GXUA20241218003019MD1734453019192&repairType=1&applyId=3022&userId=154&deptId=200
 * &userName=202109512100&repairDep=200
 * 转单
 */
export function getTransferRepairAPI(params:transferRepairer){
  return axiosInstance.get<null,GetRepairResponseData ,transferRepairer>(
    '/api/repair/tb/transferRepair', { params }
  );
}
/**
 * repairNo=GXUA20250106235628MD1736178988925&repairType=1&repairId=548&applyId=3035&deptId=204
 * @param params
 * @returns
 */
export interface transferFromDepForm{
  repairNo: string
  repairType: number
  repairId: number
  applyId: number
  deptId: number
}
export function getTransferFromDepAPI(params:transferFromDepForm){
  return axiosInstance.get<null,GetRepairResponseData ,transferFromDepForm>(
    '/api/repair/tb/transferFromDep', { params }
  );
}
export interface arrangeForm{
  userName: string
  userId: number
  repairNo: string
  repairType: number
  repairId: number
  applyId: number
}
export function getArrangeAPI(params:arrangeForm){
  return axiosInstance.get<null,GetRepairResponseData ,arrangeForm>(
    '/api/repair/tb/arrange', { params }
  );
}
/**
 * http://localhost:8999/api/repair/tb/arrange
 * ?userName=201809512626&userId=127&repairNo=GXUA20250107171055MD1736241055925&
 * repairType=3&repairId=558&applyId=3042
 */