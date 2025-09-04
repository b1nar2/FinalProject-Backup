package com.gym.controller.user;

import com.gym.domain.comments.CommentsCreateRequest;
import com.gym.domain.comments.CommentsResponse;
import com.gym.service.CommentsService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.media.Schema;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 댓글 관련 REST API 컨트롤러
 * - 댓글 등록, 조회, 수정, 삭제 기능 제공
 */
@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
@Tag(name = "comments", description = "댓글 API")
public class CommentsController {

    private final CommentsService commentsService;

    /**
     * 댓글 등록 API
     * @param request 댓글 등록 요청 DTO
     * @return 생성된 댓글 ID
     */
    @Operation(summary = "댓글 등록", description = "게시글에 댓글을 등록합니다.")
    @PostMapping
    public Long createComments(
        @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "댓글 등록 요청 데이터", required = true)
        @RequestBody CommentsCreateRequest request) {
        return commentsService.createComments(request);
    }

    /**
     * 게시글 댓글 목록 조회 API
     * @param postId 게시글 ID
     * @return 댓글 리스트
     */
    @Operation(summary = "게시글 댓글 목록 조회", description = "특정 게시글의 댓글 전체를 조회합니다.")
    @GetMapping("/post/{postId}")
    public List<CommentsResponse> getCommentsByPost(
        @Parameter(description = "댓글 조회 대상 게시글 ID", required = true, schema = @Schema(type = "integer"))
        @PathVariable("postId") Long postId) {
        return commentsService.getCommentsByPost(postId);
    }

    /**
     * 댓글 단건 조회 API
     * @param commentsId 댓글 ID
     * @return 댓글 상세 정보 DTO
     */
    @Operation(summary = "댓글 단건 조회", description = "댓글 ID로 댓글 하나를 조회합니다.")
    @GetMapping("/{commentsId}")
    public CommentsResponse getCommentsById(
        @Parameter(description = "조회할 댓글 ID", required = true, schema = @Schema(type = "integer"))
        @PathVariable("commentsId") Long commentsId) {
        return commentsService.getCommentsById(commentsId);
    }

    /**
     * 댓글 수정 API (회원 ID + 댓글 ID 기준, 회원 소유 댓글만 수정 가능)
     * @param memberId 회원 ID
     * @param commentsId 댓글 ID
     * @param request 수정 요청 DTO
     */
    @Operation(summary = "회원 ID와 댓글 ID로 댓글 수정", description = "회원 ID와 댓글 ID가 일치하는 댓글을 수정합니다.")
    @PutMapping("/member/{memberId}/comments/{commentsId}")
    public void updateCommentsByMember(
        @Parameter(description = "수정할 회원 ID", required = true)
        @PathVariable("memberId") String memberId,
        @Parameter(description = "수정할 댓글 ID", required = true, schema = @Schema(type = "integer"))
        @PathVariable("commentsId") Long commentsId,
        @io.swagger.v3.oas.annotations.parameters.RequestBody(description = "댓글 수정 요청 데이터", required = true)
        @RequestBody CommentsCreateRequest request) {
        commentsService.updateCommentsByMember(memberId, commentsId, request);
    }

    /**
     * 댓글 삭제 API
     * @param commentsId 삭제할 댓글 ID
     */
    @Operation(summary = "댓글 삭제", description = "댓글 ID로 댓글을 삭제합니다.")
    @DeleteMapping("/{commentsId}")
    public void deleteComments(
        @Parameter(description = "삭제할 댓글 ID", required = true, schema = @Schema(type = "integer"))
        @PathVariable("commentsId") Long commentsId) {
        commentsService.deleteComments(commentsId);
    }
}
