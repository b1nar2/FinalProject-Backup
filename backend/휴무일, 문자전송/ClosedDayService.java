package com.gym.service;

import com.gym.domain.closedday.ClosedDay;
import com.gym.domain.closedday.ClosedDayResponse;

import java.time.LocalDate;
import java.util.List;

/**
 * 휴무일 관리 서비스 인터페이스
 * - 휴무일 CRUD 및 조회 기능 제공
 */
public interface ClosedDayService {

    /**
     * 휴무일 등록
     * @param closedDay 등록할 휴무일 객체
     * @return 생성된 휴무일 ID
     */
    Long createClosedDay(ClosedDay closedDay);

    /**
     * 시설별 특정 기간의 휴무일 조회
     * @param facilityId 시설 ID
     * @param fromDate 조회 시작일
     * @param toDate 조회 종료일
     * @return 휴무일 목록
     */
    List<ClosedDayResponse> findClosedDaysByFacility(Long facilityId, LocalDate fromDate, LocalDate toDate);

    /**
     * 휴무일 삭제
     * @param closedId 삭제할 휴무일 ID
     */
    void deleteClosedDayById(Long closedId);

    /**
     * 휴무일 수정
     * @param closedId 수정 대상 휴무일 ID
     * @param update 수정 내용 포함 휴무일 객체
     */
    void updateClosedDay(Long closedId, ClosedDay update);
}
