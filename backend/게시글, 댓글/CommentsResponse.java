package com.gym.domain.comments;

import lombok.*;
import java.time.LocalDateTime;

/**
 * 댓글 조회 시 반환 DTO
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class CommentsResponse {
    private Long commentsId;            /* 댓글 고유 번호(PK) */
    private Long postId;                /* 관련 게시글(FK) */
    private String memberId;            /* 댓글 작성한 회원(FK) */
    private String memberName;          /* 시설명 => closed_day_tbl에는 없음. facility_tbl과 조인 결과로 포함되는 컬럼 */
    private String content;             /* 댓글 내용 */
    private LocalDateTime createdAt;    /* 작성일 */
    private LocalDateTime updatedAt;    /* 수정일 */
}
