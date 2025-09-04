package com.gym.domain.comments;

import lombok.*;
import java.time.LocalDateTime;

/**
 * 댓글 엔티티 DTO (DB 매핑용)
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Comments {
    private Long commentsId;            /* 댓글 고유 번호(PK) */
    private Long postId;                /* 관련 게시글(FK) */
    private String memberId;            /* 댓글 작성한 회원(FK) */
    private String content;             /* 댓글 내용 */
    private LocalDateTime createdAt;    /* 작성일 */
    private LocalDateTime updatedAt;    /* 수정일 */
}
