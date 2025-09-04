package com.gym.service.impl;

import com.gym.domain.comments.Comments;
import com.gym.domain.comments.CommentsCreateRequest;
import com.gym.domain.comments.CommentsResponse;
import com.gym.mapper.annotation.CommentsMapper;
import com.gym.service.CommentsService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 댓글 관련 서비스 구현체
 * - 실제 DB 매퍼를 통해 데이터 처리 수행
 * - 트랜잭션 관리 포함
 */
@Service
public class CommentsServiceImpl implements CommentsService {

    private final CommentsMapper commentsMapper;

    public CommentsServiceImpl(CommentsMapper commentsMapper) {
        this.commentsMapper = commentsMapper;
    }

    /**
     * 댓글 등록 처리
     * 요청 DTO -> 엔티티 변환 후 저장
     */
    @Override
    @Transactional
    public Long createComments(CommentsCreateRequest request) {
        Comments comments = Comments.builder()
            .postId(request.getPostId())
            .memberId(request.getMemberId())
            .content(request.getContent())
            .build();
        commentsMapper.insertComments(comments);
        return comments.getCommentsId();
    }

    /**
     * 특정 게시글의 댓글 전체 조회
     * 읽기 전용 트랜잭션으로 수행
     */
    @Override
    @Transactional(readOnly = true)
    public List<CommentsResponse> getCommentsByPost(Long postId) {
        return commentsMapper.selectCommentsByPost(postId);
    }

    /**
     * 댓글 단건 조회
     */
    @Override
    @Transactional(readOnly = true)
    public CommentsResponse getCommentsById(Long commentsId) {
        return commentsMapper.selectCommentsById(commentsId);
    }

    /**
     * 회원 소유 검증 후 댓글 수정
     * 수정 행 수가 0이면 예외 발생
     */
    @Override
    @Transactional
    public void updateCommentsByMember(String memberId, Long commentsId, CommentsCreateRequest request) {
        int updated = commentsMapper.updateCommentsByMember(memberId, commentsId, request.getContent());
        if (updated == 0) {
            throw new RuntimeException("수정할 댓글이 없습니다. 회원ID=" + memberId + ", 댓글ID=" + commentsId);
        }
    }

    /**
     * 댓글 삭제
     * 삭제 행 수가 0이면 예외 발생
     */
    @Override
    @Transactional
    public void deleteComments(Long commentsId) {
        int deleted = commentsMapper.deleteCommentsById(commentsId);
        if (deleted == 0) {
            throw new RuntimeException("삭제할 댓글이 없습니다. ID=" + commentsId);
        }
    }
}
