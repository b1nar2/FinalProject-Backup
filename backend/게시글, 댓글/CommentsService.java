package com.gym.service;

import com.gym.domain.comments.CommentsCreateRequest;
import com.gym.domain.comments.CommentsResponse;

import java.util.List;

/**
 * 댓글 관련 서비스 인터페이스
 * - 댓글 등록, 조회, 수정, 삭제 등의 비즈니스 로직 추상화
 */
public interface CommentsService {

    /**
     * 댓글 등록
     * @param request 댓글 등록 시 전달되는 DTO 객체
     * @return 생성된 댓글 고유 ID
     */
    Long createComments(CommentsCreateRequest request);

    /**
     * 특정 게시글에 달린 댓글 전체 목록 조회
     * @param postId 게시글 ID
     * @return 댓글 목록 리스트
     */
    List<CommentsResponse> getCommentsByPost(Long postId);

    /**
     * 댓글 단건 조회
     * @param commentsId 댓글 고유 ID
     * @return 댓글 상세 정보 DTO
     */
    CommentsResponse getCommentsById(Long commentsId);

    /**
     * 회원 ID와 댓글 ID를 기준으로 댓글 수정 (회원 소유 검증 포함)
     * @param memberId 댓글 작성자 회원 ID
     * @param commentsId 댓글 고유 ID
     * @param request 댓글 수정 요청 DTO (주로 내용 포함)
     */
    void updateCommentsByMember(String memberId, Long commentsId, CommentsCreateRequest request);

    /**
     * 댓글 삭제
     * @param commentsId 삭제할 댓글 고유 ID
     */
    void deleteComments(Long commentsId);
}
