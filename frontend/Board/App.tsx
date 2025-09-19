// import React, { useState } from 'react';

import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import CMSBoard from './CMSBoard'
import CMSReservationStatus from './CMSReservationStatus';


function App() {
  return (
    <BrowserRouter>
      <Routes>

        {/* 신청 현황 */}
        {/* <Route path="/CMS/reservations" element={<CMSReservationStatus />} /> */}
        {/* 루트 진입 시 <Navigate to="이동할페이지" replace />로 이동 */}
        {/* <Route path="/" element={<Navigate to="/CMS/reservations" replace />} /> */}
        {/* 게시판 관리 목록 */}
        <Route path="/CMS/boards" element={<CMSBoard />} />
        {/* 404 */}
        <Route path="*" element={<div>페이지를 찾을 수 없습니다.</div>} />
      </Routes>
    </BrowserRouter>



  );
}

export default App;