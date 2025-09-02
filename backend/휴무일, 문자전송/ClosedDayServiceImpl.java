package com.gym.service.impl;

import com.gym.domain.closedday.ClosedDay;
import com.gym.domain.closedday.ClosedDayResponse;
import com.gym.mapper.ClosedDayMapper;
import com.gym.service.ClosedDayService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class ClosedDayServiceImpl implements ClosedDayService {

    private final ClosedDayMapper closedDayMapper;

    public ClosedDayServiceImpl(ClosedDayMapper closedDayMapper) {
        this.closedDayMapper = closedDayMapper;
    }

    @Override
    @Transactional
    public Long createClosedDay(ClosedDay closedDay) {
        closedDayMapper.insertClosedDay(closedDay);
        return closedDay.getClosedId(); // 시퀀스 생성 후 key 설정 필요
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClosedDayResponse> findClosedDaysByFacility(Long facilityId, LocalDate fromDate, LocalDate toDate) {
        return closedDayMapper.selectClosedDaysByFacility(facilityId, fromDate, toDate);
    }    
    
    // 삭제 로직 추가    
    @Override
    @Transactional
    public void deleteClosedDayById(Long closedId) {
        int deleted = closedDayMapper.deleteClosedDayById(closedId);
        if (deleted == 0) {
            throw new RuntimeException("해당 휴무일(ClosedId=" + closedId + ")이 존재하지 않습니다.");  // ← 이렇게 변경
        }
    }
}
