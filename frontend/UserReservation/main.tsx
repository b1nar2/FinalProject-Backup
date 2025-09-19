import React from "react";
import ReactDOM from "react-dom/client";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import RootLayout from "./routes/RootLayout";
import FacilityInfo from "./FacilityInfo";
import UserReservation from "./UserReservation";
import Payment from "./Payment";
import Complete from "./Complete";
import { ReservationProvider } from "./reservation";
import { enableMocking } from "./mocks/index"; // mocks/index.ts

const router = createBrowserRouter([
  {
    path: "/",
    element: <RootLayout />,
    children: [
      { index: true, element: <FacilityInfo /> },
      { path: "apply", element: <UserReservation /> },
      { path: "pay", element: <Payment /> },
      { path: "done", element: <Complete /> },
    ],
  },
]);

enableMocking().then(() => {
  ReactDOM.createRoot(document.getElementById("root")!).render(
    <React.StrictMode>
      <ReservationProvider>
        <RouterProvider router={router} />
      </ReservationProvider>
    </React.StrictMode>
  );
});
