import { Outlet, NavLink, useLocation } from "react-router-dom";

const steps = [
  { label: "시설 정보", to: "/" },
  { label: "예약 신청", to: "/apply" },
  { label: "결제 신청", to: "/pay" },
  { label: "신청 완료", to: "/done" },
];

export default function RootLayout() {
  const { pathname } = useLocation();
  const currentIdx = Math.max(
    0,
    steps.findIndex((s) => (s.to === "/" ? pathname === "/" : pathname.startsWith(s.to)))
  );

  return (
    <div>
      <header style={{ padding: 12, borderBottom: "1px solid #eee" }}>
        <nav style={{ display: "flex", gap: 12, alignItems: "center", flexWrap: "wrap" }}>
          {steps.map((s, idx) => {
            const isDone = idx < currentIdx;
            const isActive = idx === currentIdx;
            const base = { padding: "6px 10px", borderRadius: 6, textDecoration: "none", fontWeight: 600 } as const;
            const style: React.CSSProperties = isActive
              ? { ...base, color: "#fff", background: "#2563eb" }
              : isDone
              ? { ...base, color: "#2563eb", background: "#e0ecff" }
              : { ...base, color: "#64748b", background: "#f1f5f9" };
            const isDisabled = idx > currentIdx;

            return isDisabled ? (
              <span key={s.to} style={{ ...style, pointerEvents: "none", opacity: 0.6 }}>
                {s.label}
              </span>
            ) : (
              <NavLink key={s.to} to={s.to} end={s.to === "/"} style={style}>
                {s.label}
              </NavLink>
            );
          })}
        </nav>
      </header>

      <div style={{ height: 4, background: "#e5e7eb" }}>
        <div
          style={{
            height: "100%",
            width: `${(currentIdx / (steps.length - 1)) * 100}%`,
            background: "#2563eb",
            transition: "width .2s",
          }}
        />
      </div>

      <main style={{ padding: 16 }}>
        <Outlet />
      </main>
    </div>
  );
}
