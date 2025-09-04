package com.gym.mapper.annotation;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.domain.closedday.ClosedDay;
import com.gym.domain.closedday.ClosedDayResponse;

/**
 * 휴무일(ClosedDay) 관련 데이터베이스 매퍼 인터페이스
 * MyBatis XML 매퍼와 연동되어 DB 쿼리 실행 담당
 */
@Mapper
public interface ClosedDayMapper {

    /**
     * 휴무일 등록
     * @param closedDay 등록할 휴무일 정보
     * @return 생성된 휴무일 고유 ID
     */
    Long insertClosedDay(ClosedDay closedDay);

    /**
     * 특정 시설의 특정 기간 내 휴무일 목록 조회
     * @param facilityId 시설 고유 ID
     * @param fromDate 조회 시작일
     * @param toDate 조회 종료일
     * @return 휴무일 목록 리스트
     */
    List<ClosedDayResponse> selectClosedDaysByFacility(
        @Param("facilityId") Long facilityId,
        @Param("fromDate") LocalDate fromDate,
        @Param("toDate") LocalDate toDate);

    /**
     * 휴무일 단건 조회
     * @param closedId 휴무일 고유 ID
     * @return 조회된 휴무일 상세 정보
     */
    ClosedDayResponse selectClosedDayById(@Param("closedId") Long closedId);

    /**
     * 휴무일 삭제
     * @param closedId 삭제할 휴무일 고유 ID
