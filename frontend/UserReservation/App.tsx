import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import FacilityInfo from './FacilityInfo';
import UserReservation from './UserReservation';
import Payment from './Payment';
import Complete from './Complete';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/facility/1" replace />} />
        <Route path="/facility/:id" element={<FacilityInfo />} />
        <Route path="/reserve/:id" element={<UserReservation />} />
        <Route path="/pay/:reservationId" element={<Payment />} />
        <Route path="/complete/:reservationId" element={<Complete />} />
      </Routes>
    </BrowserRouter>
  );
}
