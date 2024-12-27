import { axiosInstanceDemo, AxiosResponseData } from '../common/utils/http'

export function getTestAPI() {
  return axiosInstanceDemo.get
  <null, AxiosResponseData<string>, null>
  ('/test')
}
