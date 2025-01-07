import axios, { AxiosResponse } from "@ohos/axios"
import { axiosInstance } from "../common/utils/httpInstance"
import { getTypeResponse, GetTypeResponseData } from "./getTypeAPI"
import { myRepairData, RepairItem, repImgItem, RepType } from "./myRepairListAPI"


//月份统计订单金额
export interface moneyTotalItem{
  RepairMoneyTotal
    :
    number
  RepairOrderTotal
    :
    number
  repairMonth
    :
    number
}
interface HuzxResponse<T>{
  msg:string
  code:number
  data:T[]
}

export interface repairTotalItem{
  /*appImgList: appImgList[]*/
  apply: null
  applyId: number
  /*createBy: null
  createTime: null*/
  curWork: number
  /*params: {}*/
/*  processList
    :
    []*/
/*  remark
    :
    null*/
  repImgList: repImgItem[]
  repType: RepType
  repairAddress
    :
    string
  repairComment
    :
    number
  repairContent
    :
    string
  repairCreateTime
    :
    Date
  repairDay
    :
    number
  repairDep
    :
    number
  repairDestory
    :
    number
  repairDestoryTime
    :
    Date
  repairExpectTime
    :
    Date
  repairExpectType
    :
    number
  repairId
    :
    number
  repairIsDelete
    :
    number
  repairMoney
    :
    number
  repairMonth
    :
    number
  repairName
    :
    string
  repairNo
    :
    string
  repairState
    :
    number
  repairTransfer
    :
    number
  repairType
    :
    number
  repairYear
    :
    number
  repaireId
    :
    number
  repaireName
    :
    string
  repairedState
    :
    number
/*  repcomment
    :
    null*/
/*  searchValue
    :
    null
  updateBy
    :
    null
  updateTime
    :
    null*/
}
//已转单
/**
 * /api/repair/reptransfer/list
 */
export interface repTransferItem{

  apply_address
    :
    string
  apply_content
    :
    string
  apply_no
    :
    string
  apply_type
    :
    string
  apply_userid
    :
    number
  dept_id
    :
    number
  dept_name
    :
    string
  nick_name
    :
    string
  phonenumber
    :
    string
  reptransfeTime
    :
    Date
  reptransfe_message
    :
    string
  reptransfe_to_user
    :
    number
  reptransfe_user
    :
    number
  reptransfe_user_type
    :
    number
  reptransfer_id
    :
    number
  sex
    :
    string
  to_dept_name
    :
    string
  to_nick_name
    :
    string
  tophonenumber
    :
    string
  tosex
    :
    string
  user_id
    :
    number
}
interface OrdersForm{
  repairIsDelete:number
  repairDestory:number
  repairTransfer:number
}

/**
 * 已销单
 * /api/repair/tb/list?repairIsDelete=0&repairDestory=1&repairTransfer=0
 * 已转单
 * api/repair/tb/list?repairIsDelete=0&repairDestory=0&repairTransfer=1
 * 转单功能需要配合下面的list转单细节使用
 * 正在维修
 * api/repair/tb/list?repairIsDelete=0&repairDestory=0&repairTransfer=0
 */

export function getOrdersByConditionListAPI(params:OrdersForm){

  return axiosInstance.get<null, GetTypeResponseData<RepairItem>,OrdersForm>(
    '/api/repair/tb/list',{params}

  );
}

export function getTransferOrdersDetailListAPI(){
  return axiosInstance.get<null, GetTypeResponseData<repTransferItem>,null>(
    '/api/repair/reptransfer/list'
  );

}

interface repairMonth{
  repairMonth:number
}
//月份统计订单金额
export function getMoneyTotalAPI(params:repairMonth){

  return axiosInstance.get<null, GetRepairResponseData<moneyTotalItem>,repairMonth>(
    '/api/repair/tb/moneytotal',{params}
    /*'/api/repair/tb/moneytotal?repairMonth='+data.repairMonth.toString()*/
  );
}
export type GetRepairResponseData<T = null> = AxiosResponse<HuzxResponse<T>,null>
//月份统计订单
export function getRepairTotalAPI(params:repairMonth){

  return axiosInstance.get<null, GetTypeResponseData<RepairItem>,repairMonth>(
    '/api/repair/tb/repairtotal',{params}

  );
}
interface regeoForm{
  key:string
  location:string
  radius:number
  extensions:string
}


