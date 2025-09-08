package com.gym.mapper.xml;

import com.gym.domain.message.Message;
import com.gym.domain.message.MessageResponse;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

/**
 * MyBatis 매퍼 인터페이스
 * SQL Mapper XML과 연동되어 DB 작업 수행
 */
@Mapper
public interface MessageMapper {

    /**
     * 메시지 저장 (insert)
     * @param message 저장 대상 메시지 정보
     * @return 저장된 메시지 고유 ID (생성된 키값)
     */
    Long insertMessage(Message message);

    /**
     * 메시지 단건 조회
     * @param messageId 메시지 ID
     * @return 조회된 메시지 정보
     */
    MessageResponse selectMessageById(Long messageId);

    /**
     * 회원별 메시지 목록 조회 (페이징)
     * @param params 페이징 및 회원ID 포함 파라미터 맵 (memberId, size, offset)
     * @return 메시지 목록 리스트
     */
    List<MessageResponse> selectMessagesByMember(Map<String, Object> params);

    /**
     * 예약별 메시지 목록 조회
     * @param resvId 예약 ID
     * @return 메시지 목록 리스트
     */
    List<MessageResponse> selectMessagesByReservation(Long resvId);

    /**
     * 전체 메시지 목록 조회 (페이징)
     * @param params 페이징 파라미터 맵 (size, offset)
     * @return 메시지 전체 리스트
     */
    List<MessageResponse> selectAllMessages(Map<String, Object> params);

    /**
     * 회원별 메시지 개수 조회
     * @param memberId 회원 ID
     * @return 메시지 총 개수
     */
    Long countMessagesByMember(String memberId);

    /**
     * 전체 메시지 개수 조회
     * @return 메시지 총 개수
     */
    Long countAllMessages();
}
