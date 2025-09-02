package com.gym.domain.message;

import java.time.LocalDateTime;
import lombok.*;

@Getter @Setter @ToString
@NoArgsConstructor @AllArgsConstructor @Builder
public class Message {
    
    private Long 			messageId; 		// 문자 이력 고유 ID
    private String			memberId; 		// 문자 수신자 ID
    private Long 			resvId; 		// 관련 예약 ID (nullable)
    private Long 			closedId; 		// 관련 휴관일 ID (nullable)  
    private String 			messagePhone; 	// 수신번호
    private String 			messageType; 	// 문자 분류 유형
    private String 			messageContent; // 실제 발송된 문자 내용
    private LocalDateTime 	messageDate; 	// 문자 발송 일시
}
