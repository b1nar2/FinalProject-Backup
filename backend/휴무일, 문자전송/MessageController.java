package com.gym.controller.user;

import com.gym.domain.message.Message;
import com.gym.domain.message.MessageResponse;
import com.gym.service.MessageService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 메시지 전송 및 조회 REST API 컨트롤러
 */
@RestController
@RequestMapping("/api/messages")
@Tag(name = "Message", description = "문자전송 및 조회 API")
public class MessageController {

    private final MessageService messageService;

    /**
     * 생성자 기반 의존성 주입
     */
    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    /**
     * 메시지 전송 요청 API
     * @param message 요청 바디의 메시지 객체(JSON)
     * @return 처리 결과 메시지
     */
    @Operation(summary = "문자 전송 요청 (DB 저장 및 로그 기록)")
    @PostMapping("/send")
    public String sendMessage(
        @Parameter(description = "전송할 메시지 객체", required = true)
        @RequestBody Message message) {
        messageService.sendMessage(message);
        return "문자전송 요청이 처리되었습니다.";
    }

    /**
     * 단건 메시지 조회 API
     * @param messageId 조회할 메시지 ID
     * @return 메시지 상세 정보
     */
    @Operation(summary = "단건 메시지 조회")
    @GetMapping("/{messageId}")
    public MessageResponse getMessageById(
        @Parameter(description = "조회할 메시지 ID", required = true)
        @PathVariable(name = "messageId") Long messageId) {
        return messageService.getMessageById(messageId);
    }

    /**
     * 회원별 메시지 목록 조회 (페이징)
     * @param memberId 회원 ID
     * @param size 페이지 크기 (기본 10)
     * @param offset 시작 위치 (기본 0)
     * @return 메시지 리스트
     */
    @Operation(summary = "회원별 메시지 목록 조회")
    @GetMapping("/member/{memberId}")
    public List<MessageResponse> getMessagesByMember(
        @Parameter(description = "회원 ID", required = true)
        @PathVariable(name = "memberId") String memberId,
        @Parameter(description = "조회할 개수 (페이지 크기)", required = false)
        @RequestParam(name = "size", defaultValue = "10") int size,
        @Parameter(description = "조회 시작 위치 (0부터 시작)", required = false)
        @RequestParam(name = "offset", defaultValue = "0") int offset) {
        return messageService.getMessagesByMember(memberId, size, offset);
    }

    /**
     * 예약별 메시지 목록 조회 API
     * @param resvId 예약 ID
     * @return 메시지 리스트
     */
    @Operation(summary = "예약별 메시지 목록 조회")
    @GetMapping("/reservation/{resvId}")
    public List<MessageResponse> getMessagesByReservation(
        @Parameter(description = "예약 ID", required = true)
        @PathVariable(name = "resvId") Long resvId) {
        return messageService.getMessagesByReservation(resvId);
    }

    /**
     * 전체 메시지 목록 조회 (페이징)
     * @param size 페이지 크기 (기본 10)
     * @param offset 시작 위치 (기본 0)
     * @return 전체 메시지 리스트
     */
    @Operation(summary = "전체 메시지 목록 조회")
    @GetMapping
    public List<MessageResponse> getAllMessages(
        @Parameter(description = "조회할 개수 (페이지 크기)", required = true)
        @RequestParam(name = "size") int size,
        @Parameter(description = "조회 시작 위치 (0부터 시작)", required = true)
        @RequestParam(name = "offset") int offset) {
        return messageService.getAllMessages(size, offset);
    }

    /**
     * 회원별 메시지 개수 조회 API
     * @param memberId 회원 ID
     * @return 메시지 총 개수
     */
    @Operation(summary = "회원별 메시지 개수 조회")
    @GetMapping("/member/{memberId}/count")
    public Long countMessagesByMember(
        @PathVariable(name = "memberId") String memberId) {
        return messageService.countMessagesByMember(memberId);
    }

    /**
     * 전체 메시지 개수 조회 API
     * @return 전체 메시지 총 개수
     */
    @Operation(summary = "전체 메시지 개수 조회")
    @GetMapping("/count")
    public Long countAllMessages() {
        return messageService.countAllMessages();
    }
}
