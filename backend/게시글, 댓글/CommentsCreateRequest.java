package com.gym.domain.comments;

import lombok.*;

/*
 * 댓글 등록 및 수정 요청용 DTO 클래스
 * - 댓글 생성과 수정에 동일하게 사용 가능하며, 
 *   게시글 ID, 작성자 회원 ID, 내용 정보를 포함함
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class CommentsCreateRequest {

    /* 댓글을 달 게시글 ID */
    private Long postId;

    /* 댓글 작성 회원 ID */
    private String memberId;

    /* 댓글 내용 */
    private String content;
}
