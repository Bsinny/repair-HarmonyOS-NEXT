import { axiosInstanceDemo, AxiosResponseData } from '../common/utils/http'


export enum ShareType {
  LOCATION = 1,
  ROUTE = 2
}

export interface GuardShardInfo {
  shareId: number
}

export interface postShareCreateData {
  shareType: ShareType
}

export function postShareCreate(shareType: ShareType) {
  const data: postShareCreateData = { shareType }
  return axiosInstanceDemo.post
  <null, AxiosResponseData<GuardShardInfo>, postShareCreateData>
  ('/share/create', data)
}

export function postShareEnd(shareType: ShareType) {
  const params: postShareCreateData = { shareType }
  return axiosInstanceDemo.post('/share/end', params)
}


export function getShareList(shareType: ShareType) {
  const params: postShareCreateData = { shareType }
  return axiosInstanceDemo.get('/share/list', { params: params })
}

export interface SetGuardShardMessageParams {
  msg: string
  shareType: ShareType
}

export function postShareMsg(params: SetGuardShardMessageParams) {
  return axiosInstanceDemo.post('/share/msg', params)
}