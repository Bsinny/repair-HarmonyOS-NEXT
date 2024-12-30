import { axiosInstance } from "../common/utils/httpInstance";
import { getTypeResponse, GetTypeResponseData } from "./getTypeAPI";
import { RepairItem } from "./myRepairListAPI";


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
