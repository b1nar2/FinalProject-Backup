import { http, HttpResponse } from "msw";

export const handlers = [
  http.post("/api/reservations", async ({ request }) => {
    const body = await request.json();
    console.log("[MSW] /api/reservations", body);
    return HttpResponse.json({ id: "r-2025-0001", status: "LOGGED" }, { status: 201 });
  }),
];
