package com.gym.service.impl;

import com.gym.domain.message.Message;
import com.gym.domain.message.MessageResponse;
import com.gym.mapper.xml.MessageMapper;
import com.gym.service.MessageService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 메시지 관련 비즈니스 로직 구현 클래스
 * - 메시지 저장 시 현재 시간 세팅, DB 삽입 및 로그 기록
 * - 조회 및 카운트 기능 구현
 */
@Service
public class MessageServiceImpl implements MessageService {

    private static final Logger logger = LoggerFactory.getLogger(MessageServiceImpl.class);

    private final MessageMapper messageMapper;

    /**
     * 생성자 기반 의존성 주입
     * @param messageMapper 메시지 매퍼
     */
    public MessageServiceImpl(MessageMapper messageMapper) {
        this.messageMapper = messageMapper;
    }

    @Override
    public void sendMessage(Message message) {
        // 메시지 발송 시 현재 서버시간으로 발송일시 세팅 (나노초는 0으로)
        message.setMessageDate(LocalDateTime.now().withNano(0));

        // DB에 메시지 저장 (생성된 PK 리턴)
        Long id = messageMapper.insertMessage(message);
        message.setMessageId(id);

        // 메시지 전송 내용 로그 기록
        logger.info("문자전송 요청 - ID: {}, 수신자 ID: {}, 번호: {}, 유형: {}, 내용: {}, 발송 시간: {}",
            id,
            message.getMemberId(),
            message.getMessageType(),
            message.getMessageContent(),
            message.getMessageDate());
    }

    @Override
    public MessageResponse getMessageById(Long messageId) {
        return messageMapper.selectMessageById(messageId);
    }

    @Override
    public List<MessageResponse> getMessagesByMember(String memberId, int size, int offset) {
        Map<String, Object> params = new HashMap<>();
        params.put("memberId", memberId);
        params.put("size", size);
        params.put("offset", offset);
        return messageMapper.selectMessagesByMember(params);
    }

    @Override
    public List<MessageResponse> getMessagesByReservation(Long resvId) {
        return messageMapper.selectMessagesByReservation(resvId);
    }

    @Override
    public List<MessageResponse> getAllMessages(int size, int offset) {
        Map<String, Object> params = new HashMap<>();
        params.put("size", size);
        params.put("offset", offset);
        return messageMapper.selectAllMessages(params);
    }

    @Override
    public Long countMessagesByMember(String memberId) {
        return messageMapper.countMessagesByMember(memberId);
    }

    @Override
    public Long countAllMessages() {
        return messageMapper.countAllMessages();
    }
}
