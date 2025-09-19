import React from "react";

export type TableColumn<T> = {
  header: string;
  render: (item: T) => React.ReactNode;
};

type TableProps<T> = {
  data: T[];
  columns: TableColumn<T>[];
  keyField?: keyof T; // 예: 'id' 같은 필드명
};

// 값을 키 문자열로 안전 변환
function toKey(value: unknown): string | number {
  if (value == null) return ""; // null/undefined 방지
  if (typeof value === "string" || typeof value === "number") return value;
  return String(value);
}

export function BoardTable<T extends Record<string, any>>({
  data,
  columns,
  keyField,
}: TableProps<T>) {
  return (
    <table style={{ width: "100%", borderCollapse: "collapse" }} border={1} cellPadding={8}>
      <thead>
        <tr>
          {columns.map((col, idx) => (
            <th key={idx}>{col.header}</th>
          ))}
        </tr>
      </thead>
      <tbody>
        {data.length === 0 ? (
          <tr>
            <td colSpan={columns.length} style={{ textAlign: "center" }}>
              데이터가 없습니다.
            </td>
          </tr>
        ) : (
          data.map((item, idx) => {
            const key =
              keyField !== undefined
                ? toKey(item[keyField])
                : idx; // 마지막 수단으로 index
            return (
              <tr key={key}>
                {columns.map((col, cidx) => (
                  <td key={cidx}>{col.render(item)}</td>
                ))}
              </tr>
            );
          })
        )}
      </tbody>
    </table>
  );
}
