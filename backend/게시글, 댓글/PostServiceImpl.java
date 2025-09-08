package com.gym.service.impl;

import com.gym.domain.post.PostResponse;
import com.gym.mapper.xml.PostMapper;
import com.gym.service.PostService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PostServiceImpl implements PostService {

    private final PostMapper postMapper;

    public PostServiceImpl(PostMapper postMapper) {
        this.postMapper = postMapper;
    }

    /**
     * 게시글 등록 처리
     *
     * @param postResponse 게시글 DTO (등록일, 수정일은 DB SYSDATE 자동 처리)
     * @return 생성된 게시글 ID
     */
    @Override
    @Transactional
    public Long createPost(PostResponse postResponse) {
        // 필요시 PostResponse -> Post 엔티티 변환 로직 추가 가능
        return postMapper.insertPost(postResponse);
    }

    /**
     * 게시판별 게시글 목록 조회 (페이징, 검색, 공지 필터 포함)
     */
    @Override
    @Transactional(readOnly = true)
    public List<PostResponse> getPostsByBoard(Long boardId, int page, int size, String keyword, Boolean notice) {
        int offset = (page - 1) * size;
        return postMapper.selectPostsByBoard(boardId, offset, size, keyword, notice);
    }

    /**
     * 게시글 단건 조회
     */
    @Override
    @Transactional(readOnly = true)
    public PostResponse getPostById(Long postId) {
        return postMapper.selectPostById(postId);
    }

    /**
     * 게시글 수정 처리
     */
    @Override
    @Transactional
    public void updatePost(PostResponse postResponse) {
        int updatedCount = postMapper.updatePost(postResponse);
        if (updatedCount == 0) {
            throw new RuntimeException("수정할 게시글이 존재하지 않습니다. postId=" + postResponse.getPostId());
        }
    }

    /**
     * 게시글 삭제
     */
    @Override
    @Transactional
    public void deletePostById(Long postId) {
        int deletedCount = postMapper.deletePostById(postId);
        if (deletedCount == 0) {
            throw new RuntimeException("삭제할 게시글이 존재하지 않습니다. postId=" + postId);
        }
    }

    /**
     * 게시판별 게시글 개수 조회 (검색 및 공지 필터 포함)
     */
    @Override
    @Transactional(readOnly = true)
    public int countPostsByBoard(Long boardId, String keyword, Boolean notice) {
        return postMapper.countPostsByBoard(boardId, keyword, notice);
    }
}
