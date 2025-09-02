package com.gym.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.domain.closedday.ClosedDay;
import com.gym.domain.closedday.ClosedDayResponse;

@Mapper
public interface ClosedDayMapper {
    
    // 휴무일 등록
    Long insertClosedDay(ClosedDay closedDay);
    
    // 시설별 휴무일 조회
    List<ClosedDayResponse> selectClosedDaysByFacility(
        @Param("facilityId") Long facilityId,
        @Param("fromDate") LocalDate fromDate,
        @Param("toDate") LocalDate toDate
    );
    
    // 휴무일 단건 조회
    ClosedDayResponse selectClosedDayById(@Param("closedId") Long closedId);
    
    // 휴무일 삭제
    int deleteClosedDayById(@Param("closedId") Long closedId);
    
    // 휴무일 존재 여부 확인
    boolean existsClosedDayById(@Param("closedId") Long closedId);
    
    // 특정 날짜의 휴무일 여부 확인
    boolean existsClosedDayByDate(
        @Param("facilityId") Long facilityId, 
        @Param("closedDate") LocalDate closedDate
    );
}
