package com.gym.domain.message;

import lombok.*;

/**
 * 메시지 전송 요청 시 사용하는 DTO
 * 클라이언트가 메시지 전송 시 전달하는 데이터 모델입니다.
 * 관련 예약, 휴관일, 유형, 내용 등의 정보를 포함합니다.
 */
@Getter @Setter @ToString
@NoArgsConstructor @AllArgsConstructor @Builder
public class MessageSendRequest {

    private String memberId;        /* 문자 수신자 ID */
    private Long resvId;            /* 관련 예약 ID (nullable) */
    private Long closedId;          /* 관련 휴관일 ID (nullable) */
    private String messageType;     /* 문자 유형 (예약확인/예약취소/휴관공지) */
    private String messageContent;  /* 문자 내용 */
}
