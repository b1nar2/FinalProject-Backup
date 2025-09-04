package com.gym.domain.closedday;

import java.time.LocalDate;

import lombok.*;

/**
 * 휴무일 단건 조회 시 반환하는 DTO 클래스
 * - 시설명 등 조인된 정보 포함
 */
@Getter @Setter @ToString
@NoArgsConstructor @AllArgsConstructor @Builder
public class ClosedDayResponse {

    
    private Long closedId;          /* 휴무일 고유번호 */
    private Long facilityId;        /* 시설 ID */
    private String facilityName;    /* 시설명 => closed_day_tbl에는 존재하지 않음. facility_tbl과의 조인 결과로 조회되는 컬럼 */
    private LocalDate closedDate;   /* 휴무일 날짜 */
    private String closedContent;   /* 휴무 사유 */
}
