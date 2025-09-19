import React, { useEffect, useMemo, useState } from 'react';
import { BoardsAPI, type BoardSummary, type BoardCreateRequest, type BoardUpdateRequest } from './api/boards';

import { SearchBar } from './SearchBar';
import { Pagination } from './Pagination';
import { Button } from './Button';
import { Table, type TableColumn } from './BoardTable';


export default function CmsBoard() {
  const [rows, setRows] = useState<BoardSummary[]>([]);
  const [keyword, setKeyword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [pageIndex, setPageIndex] = useState(0);
  const [pageSize] = useState(10);
  const [showCreate, setShowCreate] = useState(false);
  const [editTarget, setEditTarget] = useState<BoardSummary | null>(null);

  const fetchList = async (kw?: string) => {
    setLoading(true);
    setError(null);
    try {
      const data = await BoardsAPI.list({ boardTitle: kw || undefined });
      setRows(data);
      setPageIndex(0);
    } catch {
      setError('목록을 불러오지 못했습니다.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchList();
  }, []);

  const paged = useMemo(() => {
    if (!Array.isArray(rows)) return [];
    const start = pageIndex * pageSize;
    return rows.slice(start, start + pageSize);
  }, [rows, pageIndex, pageSize]);

  const totalPages = Math.max(1, Math.ceil(rows.length / pageSize));

  const onCreate = async (form: BoardCreateRequest) => {
    await BoardsAPI.create(form);
    setShowCreate(false);
    await fetchList(keyword);
  };

    const handleSave = () => {
    alert("저장 버튼 클릭됨! 실제 저장 로직 연결 필요");
  };

    // 추가: BoardSummary에 맞춘 컬럼 정의
  const boardColumns: TableColumn<BoardSummary>[] = [
    { header: "번호", render: (b) => b.boardId },
    { header: "게시판 제목", render: (b) => <a href={`/cms/boards/${b.boardId}/posts`}>{b.boardTitle}</a> },
    { header: "게시판 편집", render: (b) => <button onClick={() => setEditTarget(b)}>편집</button> },
    { header: "게시글 조회", render: (b) => <a href={`/cms/boards/${b.boardId}/posts`}><button>조회</button></a> },
    { header: "이용 가능", render: (b) => (b.boardUse === 'Y' ? 'Y' : 'N') },
    { header: "등록일", render: (b) => b.regDate ?? '-' },
    { header: "수정일", render: (b) => b.modDate ?? '-' },

  ];


  return (
    <div>
      <h2>게시판 관리</h2>

      <SearchBar keyword={keyword} onKeywordChange={setKeyword} onSearch={() => fetchList(keyword)} />

      <Button label="저장" onClick={handleSave} />

            {loading && <p>로딩 중...</p>}
      {error && <p style={{ color: 'red' }}>{error}</p>}

      <Table data={paged} columns={boardColumns} keyField="boardId" />


      <Pagination pageIndex={pageIndex} totalPages={totalPages} onPageChange={setPageIndex} />

    </div>
  );
}
