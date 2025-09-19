import React from 'react';

type SearchBarProps = {
  keyword: string;
  onKeywordChange: (value: string) => void;
  onSearch: () => void;
  placeholder?: string;
};

export function SearchBar({
  keyword,
  onKeywordChange,
  onSearch,
  placeholder = "검색어를 입력하세요",
}: SearchBarProps) {
  return (
    <div style={{ marginBottom: 18 }}>
      <input
        placeholder={placeholder}
        value={keyword}
        onChange={(e) => onKeywordChange(e.target.value)}
        style={{ marginRight: 4 }} // 입력창과 버튼 사이 간격
      />
      <button onClick={onSearch}>검색</button>
    </div>
  );
}
