import React from 'react';

type PaginationProps = {
  pageIndex: number;
  totalPages: number;
  onPageChange: (page: number) => void;
};

export function Pagination({ pageIndex, totalPages, onPageChange }: PaginationProps) {
  return (
    <div style={{ marginTop: 12 }}>
      <button disabled={pageIndex === 0} onClick={() => onPageChange(0)}>
        {"<<"}
      </button>
      <button disabled={pageIndex === 0} onClick={() => onPageChange(Math.max(pageIndex - 1, 0))}>
        {"<"}
      </button>
      <span style={{ margin: "0 8px" }}>
        {pageIndex + 1} / {totalPages}
      </span>
      <button
        disabled={pageIndex >= totalPages - 1}
        onClick={() => onPageChange(Math.min(pageIndex + 1, totalPages - 1))}
      >
        {">"}
      </button>
      <button
        disabled={pageIndex >= totalPages - 1}
        onClick={() => onPageChange(totalPages - 1)}
      >
        {">>"}
      </button>
    </div>
  );
}
