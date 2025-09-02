package com.gym.service;

import com.gym.domain.closedday.ClosedDay;
import com.gym.domain.closedday.ClosedDayResponse;

import java.time.LocalDate;
import java.util.List;

public interface ClosedDayService {
    Long createClosedDay(ClosedDay closedDay);
    List<ClosedDayResponse> findClosedDaysByFacility(Long facilityId, LocalDate fromDate, LocalDate toDate);
    
    // 삭제 메서드
    void deleteClosedDayById(Long closedId);
}
