import axios from '@ohos/axios'
export const axiosInstance = axios.create({
  baseURL: 'http://123.57.165.155'
});
export interface  Message{
  code?:number;
  msg: string;
  total: number;
  data: object|string
}
