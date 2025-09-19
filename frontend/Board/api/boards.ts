import { http, unwrap } from './http';

// 백엔드 스펙을 그대로 반영한 타입
export type BoardSummary = {
  boardId: number;
  boardTitle: string;
  boardUse: 'Y' | 'N';
  regDate: string;
  modDate?: string | null;
};

export type BoardCreateRequest = {
  boardTitle: string;
  boardContent: string;
  memberId: string;
  boardNum: string;   // "01"처럼 2자리
  boardUse: 'Y' | 'N';
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
