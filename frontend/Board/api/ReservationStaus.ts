import { http, unwrap } from './http';

// 백엔드 스펙을 그대로 반영한 타입
export type ReservationSummary = {
  resv_id: number;
  member_id: string;
  facility_id: number;
  resv_content: string;
  wnat_date: string;
  resv_date: string;
  resv_log_time: number;
  resv_person_count: number;
  resv_status: string;
  facility_money: number;
  resv_start_time: string;
  resv_end_time: string;
  resv_money: number;
};

export type ReservationCreateRequest = {
  member_id: string;
  facility_id: number;
  resv_content: string;
  want_date: string;
  resv_person_count: number;
  resv_start_time: string;
  resv_end_time: string;
};

export type BoardUpdateRequest = {
  boardTitle: string;
  boardContent: string;
  boardNum: string;
  boardUse: 'Y' | 'N';
};

export const BoardsAPI = {
  list: async (params?: { boardId?: string; boardTitle?: string; memberId?: string }) => {
    const res = await http.get('/api/cms/boards', { params });
    return unwrap<BoardSummary[]>(res);
  },
  create: async (body: BoardCreateRequest) => {
    const res = await http.post('/api/cms/boards', body);
    // 컨트롤러는 생성된 boardId를 data로 반환
    return unwrap<number>(res);
  },
  update: async (boardId: number, memberId: string, body: BoardUpdateRequest) => {
    const res = await http.put(`/api/cms/boards/${boardId}/members/${memberId}`, body);
    return unwrap<number>(res); // 수정된 row 수
  },
  remove: async (boardId: number, memberId: string) => {
    const res = await http.delete(`/api/cms/boards/${boardId}/members/${memberId}`);
    return unwrap<void>(res);
  },
};
