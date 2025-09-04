package com.gym.controller.user;

import com.gym.domain.post.PostResponse;
import com.gym.service.PostService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 게시글 관련 REST API 컨트롤러
 * - 게시판별 게시글 조회, 단건 조회, 등록, 수정, 삭제 기능 제공
 */
@RestController
@RequestMapping("/api/boards/{boardId}/posts")
@Tag(name = "Post", description = "게시글 API")
public class PostController {

    private final PostService postService;

    public PostController(PostService postService) {
        this.postService = postService;
    }


    /**
     * 게시판별 게시글 목록 조회
     */
    @Operation(summary = "게시판별 게시글 목록")
    @GetMapping
    public List<PostResponse> listPosts(@PathVariable("boardId") Long boardId,
                                        @RequestParam(defaultValue = "1") int page,
                                        @RequestParam(defaultValue = "10") int size,
                                        @RequestParam(required = false) String keyword,
                                        @RequestParam(required = false) Boolean notice) {
        return postService.getPostsByBoard(boardId, page, size, keyword, notice);
    }


    /**
     * 게시글 단건 조회
     */
    @Operation(summary = "게시글 단건 조회")
    @GetMapping("/{postId}")
    public PostResponse getPost(@Parameter(description = "게시판 ID", required = true)
                                @PathVariable("boardId") Long boardId,
                                @Parameter(description = "게시글 ID", required = true)
                                @PathVariable("postId") Long postId) {
        return postService.getPostById(postId);
    }


    /**
     * 게시글 등록
     * 실제 등록 시엔 DTO 변환 로직이 필요할 수 있음
     */
    @Operation(summary = "게시글 등록")
    @PostMapping
    public Long createPost(@PathVariable("boardId") Long boardId, @RequestBody PostResponse postResponse) {
        // 게시글 등록 시엔 PostCreateRequest DTO 사용하는 게 더 좋으나
        // 간단히 PostResponse 사용 예시.
        // boardId 세팅
        // postResponse.setBoardId(boardId);
        // 실제 서비스 메서드에 맞춰 DTO 변환 필요할 수 있음
        return postService.createPost(postResponse);
    }


    /**
     * 게시글 수정
     */
    @Operation(summary = "게시글 수정")
    @PutMapping("/{postId}")
    public String updatePost(@PathVariable("boardId") Long boardId,
                             @PathVariable("postId") Long postId,
                             @RequestBody PostResponse postResponse) {
        postResponse.setPostId(postId);
        postResponse.setBoardId(boardId);
        postService.updatePost(postResponse);
        return "게시글이 수정되었습니다.";
    }


    /**
     * 게시글 삭제
     */
    @Operation(summary = "게시글 삭제")
    @DeleteMapping("/{postId}")
    public String deletePost(@PathVariable("boardId") Long boardId,
                             @PathVariable("postId") Long postId) {
        postService.deletePostById(postId);
        return "게시글이 삭제되었습니다.";
    }
}
