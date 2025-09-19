// ReservationStatus.tsx
import React, { useEffect, useMemo, useState } from 'react';
import { SearchBar } from './SearchBar';
import { Pagination } from './Pagination';
import { Button } from './Button';
import { BoardTable, type TableColumn } from './BoardTable';
import { useNavigate } from 'react-router-dom';
import './reservation.css'

// 행 타입
export type ReservationRow = {
  resvId: number;
  memberLogin: string;  // 신청인(대표) 아이디
  memberName: string;   // 신청인(대표) 이름
  facilityName: string; // 시설명
  useDate: string;      // 이용일 (YYYY-MM-DD)
  timeRange: string;    // 이용시간대 (HH:mm~HH:mm)
  requestedAt: string;  // 신청일 (YYYY.MM.DD HH:mm)
  amount: number;       // 금액
  payMethod: '카드' | '계좌';
  status: '승인' | '취소' | '완료' | '대기';
};

// 컬럼 타입 별칭
type ResvColumns = TableColumn<ReservationRow>[];

// 컬럼 액션 핸들러
type ResvHandlers = {
  onCancel: (r: ReservationRow) => void;
  onComplete: (r: ReservationRow) => void;
  onViewMember: (login: string) => void;
};

// 4) 컬럼 팩토리 (이미지 순서/라벨 반영)
export const createResvColumns = (h: ResvHandlers): ResvColumns => [
  { header: '신청번호',       render: (r) => r.resvId },
  { header: '신청인(대표)',   render: (r) => (
      <div className="linklike" onClick={() => h.onViewMember(r.memberLogin)}>
        {r.memberLogin}
      </div>
    )
  },
  { header: '신청인(대표)',   render: (r) => r.memberName },
  { header: '시설명',         render: (r) => r.facilityName },
  { header: '이용일',         render: (r) => r.useDate },
  { header: '이용시간대',     render: (r) => r.timeRange },
  { header: '신청일',         render: (r) => r.requestedAt },
  { header: '금액',           render: (r) => r.amount.toLocaleString() },
  { header: '결제수단',       render: (r) => r.payMethod },
  { header: '신청상태',       render: (r) => (
      <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
        <span>{r.status}</span>
        <Button size="sm" variant="danger"  label="취소처리" onClick={() => h.onCancel(r)} />
        <Button size="sm" variant="neutral" label="완료"     onClick={() => h.onComplete(r)} />
      </div>
    )
  },
];

// 5) API는 기존 패턴(BoardsAPI)처럼 가정
const ReservationsAPI = {
  list: async (params?: { keyword?: string; facilityType?: string }) => {
    // TODO: 실제 http 레이어 연결
    // 여기선 목 데이터로 데모
    const demo: ReservationRow[] = [
      { resvId: 1005, memberLogin: 'aaa123', memberName: '테스트1',   facilityName: '축구장',
        useDate: '2025-08-02', timeRange: '10:00~12:00', requestedAt: '2025.05.16 02:29',
        amount: 0, payMethod: '계좌', status: '승인' },
      { resvId: 1004, memberLogin: 'bbb123', memberName: '테스트2', facilityName: '농구장',
        useDate: '2025-08-02', timeRange: '18:00~19:00', requestedAt: '2025.05.15 01:38',
        amount: 10000, payMethod: '카드', status: '대기' },
      { resvId: 1003, memberLogin: 'ccc123', memberName: '테스트3', facilityName: '수영장',
        useDate: '2025-08-02', timeRange: '11:00~15:00', requestedAt: '2025.05.14 12:40',
        amount: 5000, payMethod: '계좌', status: '취소' },
      { resvId: 1002, memberLogin: 'ddd123', memberName: '테스트4', facilityName: '헬스장',
        useDate: '2025-08-02', timeRange: '18:00~19:00', requestedAt: '2025.05.04 18:05',
        amount: 20000, payMethod: '카드', status: '승인' },
      { resvId: 1001, memberLogin: 'eee123', memberName: '테스트5', facilityName: '사우나',
        useDate: '2025-08-02', timeRange: '11:00~15:00', requestedAt: '2025.04.11 08:47',
        amount: 1000, payMethod: '계좌', status: '대기' },
    ];
    return demo;
  },
  cancel: async (resvId: number) => { /* TODO */ },
  complete: async (resvId: number) => { /* TODO */ },
};

// 6) 페이지 컴포넌트
export default function CMSReservationStatus() {
  const [rows, setRows] = useState<ReservationRow[]>([]);
  const [keyword, setKeyword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [pageIndex, setPageIndex] = useState(0);
  const [pageSize] = useState(10);
  const [facilityTab, setFacilityTab] = useState<'축구장'|'농구장'|'수영장'|'사우나'|'신청인'>('신청인');
  const navigate = useNavigate();

  const fetchList = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await ReservationsAPI.list({
        keyword: keyword || undefined,
        facilityType: facilityTab !== '신청인' ? facilityTab : undefined,
      });
      setRows(data);
      setPageIndex(0);
    } catch (e) {
      setError('목록을 불러오지 못했습니다.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchList();
  }, [facilityTab]);

  const totalPages = Math.max(1, Math.ceil(rows.length / pageSize));
  const paged = useMemo(() => rows.slice(pageIndex * pageSize, pageIndex * pageSize + pageSize), [rows, pageIndex, pageSize]);

  const columns = useMemo(
    () =>
      createResvColumns({
        onCancel: async (r) => {
          await ReservationsAPI.cancel(r.resvId);
          await fetchList();
        },
        onComplete: async (r) => {
          await ReservationsAPI.complete(r.resvId);
          await fetchList();
        },
        onViewMember: (login) => navigate(`/CMS/members/${login}`),
      }),
    [navigate]
  );

  return (
    <div>
      <h2>신청 현황</h2>

      {/* 탭 */}
      <div style={{ display: 'flex', gap: 8, marginBottom: 12 }}>
        {(['축구장','농구장','수영장','사우나','신청인'] as const).map(t => (
          <Button
            key={t}
            label={t}
            variant={facilityTab === t ? 'primary' : 'outline'}
            onClick={() => setFacilityTab(t)}
          />
        ))}
      </div>

      {/* 총 건수 + 검색 */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
        <div>총 {rows.length}개</div>
        <SearchBar
          keyword={keyword}
          onKeywordChange={setKeyword}
          onSearch={fetchList}
          placeholder="신청인/시설명 검색"
        />
      </div>

      {/* 표 */}
      {loading && <p>로딩 중...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <BoardTable data={paged} columns={columns} keyField="resvId" />

      {/* 페이지네이션 */}
      <Pagination pageIndex={pageIndex} totalPages={totalPages} onPageChange={setPageIndex} />
    </div>
  );
}
