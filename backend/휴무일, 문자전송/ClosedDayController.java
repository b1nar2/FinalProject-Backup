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

@RestController
@RequestMapping("/api/closed-days")
@Tag(name = "ClosedDay", description = "휴무일 API")
public class ClosedDayController {

    private final ClosedDayService closedDayService;

    public ClosedDayController(ClosedDayService closedDayService) {
        this.closedDayService = closedDayService;
    }

    @Operation(summary = "시설별 휴무일 조회")
    @GetMapping("/{facilityId}")
    public List<ClosedDayResponse> getClosedDaysByFacility(
        @PathVariable("facilityId") Long facilityId,
        @RequestParam("fromDate") LocalDate fromDate,
        @RequestParam("toDate") LocalDate toDate) {
        return closedDayService.findClosedDaysByFacility(facilityId, fromDate, toDate);
    }


    @Operation(summary = "휴무일 등록")
    @PostMapping
    public Long createClosedDay(@RequestBody ClosedDay closedDay) {
        return closedDayService.createClosedDay(closedDay);
    }
    
    // 삭제 API 추가
    @Operation(summary = "휴무일 삭제")
    @DeleteMapping("/{closedId}")
    public String deleteClosedDay(
        @Parameter(name = "closedId", description = "삭제할 휴무일 ID", required = true)
        @PathVariable(name = "closedId") Long closedId
    ) {
        closedDayService.deleteClosedDayById(closedId);
        return "휴무일이 삭제되었습니다.";
    }
}
    

