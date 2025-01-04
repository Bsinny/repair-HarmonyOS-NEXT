import { AxiosResponse } from "@ohos/axios";
import { axiosInstance } from "../common/utils/httpInstance";
import { getTypeResponse, GetTypeResponseData } from "./getTypeAPI";
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

interface usersList{
  code: number;
  msg: string;
  data:UserInfo[]
}

/**
 * 获取当前用户的部门id，查询同部门的维修人员
 * /api/repair/tb/findByDeptIdUserIdForUser?deptId=200
 */
export function getByDeptIdUserIdForUserAPI(params:getByDeptIdUserIdForUser){
  return axiosInstance.get<null, AxiosResponse<getTypeResponse<usersList>,null>,getByDeptIdUserIdForUser>(
    '/api/repair/tb/findByDeptIdUserIdForUser', { params }
  );
}
