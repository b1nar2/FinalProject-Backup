package com.gym.domain.message;

import java.time.LocalDateTime;

import lombok.*;

/**
 * 메시지 조회 시 반환되는 DTO 클래스
 * - member_name 컬럼 조인 결과 포함
 */
@Getter @Setter @ToString
@NoArgsConstructor @AllArgsConstructor
@Builder
public class MessageResponse {

    private Long messageId;          /* 메시지 고유 ID */
    private String memberId;         /* 문자 수신자 ID */
    private String memberName;       /* 회원 이름 => message_tbl에는 존재하지 않음. member_tbl과의 조인 결과로 조회되는 컬럼 */
    private Long resvId;             /* 관련 예약 ID */
    private Long closedId;           /* 관련 휴관일 ID */
    private String messageType;      /* 문자 유형 */
    private String messageContent;   /* 문자 내용 */
    private LocalDateTime messageDate; /* 문자 발송 일시 */
}
