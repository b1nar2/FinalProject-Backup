import axios from 'axios';

export const http = axios.create({
  baseURL: 'http://localhost:8181', // 동일 도메인 프록시 기준
  headers: { 'Content-Type': 'application/json' },
});

// ApiResponse 래핑 안전 해제
export function unwrap<T>(res: { data: any }): T {
  return res.data?.data !== undefined ? (res.data.data as T) : (res.data as T);
}
