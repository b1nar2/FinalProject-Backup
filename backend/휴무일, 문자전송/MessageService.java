package com.gym.service;

import com.gym.domain.message.Message;
import com.gym.domain.message.MessageResponse;

import java.util.List;

/**
 * 메시지 관련 서비스 인터페이스
 * - 메시지 전송, 조회, 카운트 기능 제공
 */
public interface MessageService {

    /**
     * 메시지 저장 및 로그 기록
     * @param message 저장할 메시지 객체
     */
    void sendMessage(Message message);

    /**
     * 단건 메시지 조회
     * @param messageId 메시지 ID
     * @return 메시지 조회 결과
     */
    MessageResponse getMessageById(Long messageId);

    /**
     * 회원별 메시지 리스트 조회 (페이징)
     * @param memberId 회원 ID
     * @param size 조회할 최대 개수
     * @param offset 조회 시작 위치 (offset)
     * @return 메시지 리스트
     */
    List<MessageResponse> getMessagesByMember(String memberId, int size, int offset);

    /**
     * 예약별 메시지 리스트 조회
     * @param resvId 예약 ID
     * @return 메시지 리스트
     */
    List<MessageResponse> getMessagesByReservation(Long resvId);

    /**
     * 전체 메시지 리스트 조회 (페이징)
     * @param size 조회할 최대 개수
     * @param offset 조회 시작 위치 (offset)
     * @return 메시지 전체 리스트
     */
    List<MessageResponse> getAllMessages(int size, int offset);

    /**
     * 회원별 메시지 개수 조회
     * @param memberId 회원 ID
     * @return 메시지 개수
     */
    Long countMessagesByMember(String memberId);

    /**
     * 전체 메시지 개수 조회
     * @return 전체 메시지 개수
     */
    Long countAllMessages();
}
