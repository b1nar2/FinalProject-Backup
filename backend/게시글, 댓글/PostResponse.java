package com.gym.domain.post;

import java.time.LocalDateTime;
import lombok.*;

/**
 * 게시글 상세 조회 시 반환되는 DTO
 * - 게시글 주요 정보 및 작성자 이름 포함
 */
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PostResponse {

    private Long postId;                /* 게시글 고유 ID */
    private Long boardId;               /* 게시판 ID */
    private String postTitle;           /* 게시글 제목 */
    private String postContent;         /* 게시글 내용 */
    private String memberId;            /* 작성자 회원 ID */
    private String memberName;          /* 작성자 회원 이름 => post_tbl에는 존재하지 않음. member_tbl과의 조인 결과로 조회되는 컬럼 */
    private LocalDateTime postRegDate;  /* 게시글 등록일 */
    private Integer postViewCount;      /* 조회수 */
    private Boolean postNotice;         /* 공지 여부 */
    private Boolean postSecret;         /* 비밀글 여부 */
    private String postType;            /* 게시글 유형 */
}
