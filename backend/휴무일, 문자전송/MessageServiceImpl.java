package com.gym.service.impl;

import com.gym.domain.message.Message;
import com.gym.service.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class MessageServiceImpl implements MessageService {

    private static final Logger logger = LoggerFactory.getLogger(MessageServiceImpl.class);

    @Override
    public void sendMessage(Message message) {
        // 로그에만 기록: 발송 일시 현재 시간으로 설정(테스트용)
        message.setMessageDate(java.time.LocalDateTime.now());

        logger.info("문자전송 요청 - 수신자 ID: {}, 수신 번호: {}, 유형: {}, 내용: {}, 발송 시간: {}",
            message.getMemberId(),
            message.getMessagePhone(),
            message.getMessageType(),
            message.getMessageContent(),
            message.getMessageDate());

        // 실제 DB 저장이나 문자 API 호출은 미실행
    }
}
