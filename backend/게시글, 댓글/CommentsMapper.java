package com.gym.domain.comments;

import lombok.*;
import java.time.LocalDateTime;

/*
 * 댓글 엔티티 DTO
 * - DB 테이블과 매핑되는 객체
 * - 댓글 생성/조회/수정을 위한 필드 포함
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Comments {

    
    private Long commentsId;             /* 댓글 고유 ID (Primary key) */
    private Long postId;                 /* 댓글이 달린 게시글 ID (Foreign key) */
    private String memberId;             /* 댓글 작성 회원 ID */
    private String content;              /* 댓글 내용 */
    private LocalDateTime createdAt;     /* 댓글 생성 시간 */
    private LocalDateTime updatedAt;     /* 댓글 수정 시간 */
}
