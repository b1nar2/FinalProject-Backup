package com.gym.domain.closedday;

import java.time.LocalDate;

import lombok.*;

/**
 * 휴무일 등록 및 수정 시 사용하는 도메인 클래스
 */
@Getter @Setter @ToString
@NoArgsConstructor @AllArgsConstructor @Builder
public class ClosedDay {

    
    private Long closedId;          /* 휴무일 고유번호 */
    private Long facilityId;        /* 시설 ID */
    private LocalDate closedDate;   /* 휴무일 날짜 */
    private String closedContent;   /* 휴무 사유 */
}
