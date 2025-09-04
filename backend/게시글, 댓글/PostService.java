package com.gym.service;

import com.gym.domain.post.PostResponse;
import java.util.List;

public interface PostService {
    Long createPost(PostResponse postResponse);

    List<PostResponse> getPostsByBoard(Long boardId, int page, int size, String keyword, Boolean notice);

    PostResponse getPostById(Long postId);

    void updatePost(PostResponse postResponse);

    void deletePostById(Long postId);

    int countPostsByBoard(Long boardId, String keyword, Boolean notice);
}
