package com.gym.controller.user;

import com.gym.domain.message.Message;
import com.gym.service.MessageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/messages")
@Tag(name = "Message", description = "문자전송 API (로그 기록 전용)")
public class MessageController {

    private final MessageService messageService;

    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    @Operation(summary = "문자전송 요청 (로그 기록만)")
    @PostMapping("/send")
    public String sendMessage(@RequestBody Message message) {
        messageService.sendMessage(message);
        return "문자전송 요청이 로그에 기록되었습니다.";
    }
}
