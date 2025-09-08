package com.gym.controller.user;

import com.gym.domain.closedday.ClosedDay;
import com.gym.domain.closedday.ClosedDayResponse;
import com.gym.service.ClosedDayService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;

/**
 * 휴무일 관리를 위한 REST API 컨트롤러.
 */
@RestController
@RequestMapping("/api/closed-days")
@Tag(name = "ClosedDay", description = "휴무일 API")
public class ClosedDayController {

    private final ClosedDayService closedDayService;

    public ClosedDayController(ClosedDayService closedDayService) {
        this.closedDayService = closedDayService;
    }

    /**
     * 시설별 휴무일 조회 (기간 지정 가능)
     */
    @Operation(summary = "시설별 휴무일 조회")
    @GetMapping("/{facilityId}")
    public List<ClosedDayResponse> getClosedDaysByFacility(
        @Parameter(description = "시설 ID", required = true)
        @PathVariable(name = "facilityId") Long facilityId,
        @Parameter(description = "조회 시작일", required = true)
        @RequestParam(name = "fromDate") LocalDate fromDate,
        @Parameter(description = "조회 종료일", required = true)
        @RequestParam(name = "toDate") LocalDate toDate
    ) {
        return closedDayService.findClosedDaysByFacility(facilityId, fromDate, toDate);
    }

    /**
     * 휴무일 등록
     */
    @Operation(summary = "휴무일 등록")
    @PostMapping
    public Long createClosedDay(
        @Parameter(description = "등록할 휴무일 정보", required = true)
        @RequestBody ClosedDay closedDay
    ) {
        return closedDayService.createClosedDay(closedDay);
    }

    /**
     * 휴무일 삭제
     */
    @Operation(summary = "휴무일 삭제")
    @DeleteMapping("/{closedId}")
    public String deleteClosedDay(
        @Parameter(name = "closedId", description = "삭제할 휴무일 ID", required = true)
        @PathVariable(name = "closedId") Long closedId
    ) {
        closedDayService.deleteClosedDayById(closedId);
        return "휴무일이 삭제되었습니다.";
    }

    /**
     * 휴무일 수정
     */
    @Operation(summary = "휴무일 수정")
    @PutMapping("/{closedId}")
    public String updateDay(
        @Parameter(name = "closedId", description = "수정할 휴무일 ID", required = true)
        @PathVariable(name = "closedId") Long closedId,
        @Parameter(description = "수정할 휴무일 정보", required = true)
        @RequestBody ClosedDay update
    ) {
        closedDayService.updateClosedDay(closedId, update);
        return "휴무일이 수정되었습니다.";
    }
}
