-- 신청(예약) 정보 테이블
CREATE TABLE reservation_tbl (
    resv_id           NUMBER            NOT NULL,                       -- 예약 고유 번호 (결제 시스템과 연동)
    member_id         VARCHAR2(20)      NOT NULL,                       -- 신청자 ID
    facility_id       NUMBER            NOT NULL,                       -- 예약 대상 시설 고유번호
    resv_content      VARCHAR2(500),                                    -- 신청시 요구 사항(단순 텍스트)
    want_date         DATE              NOT NULL,                       -- 예약 희망일
    resv_date         DATE              DEFAULT sysdate NOT NULL,       -- 예약 신청일 (프론트 화면에 나오는 용도)
    resv_log_time     DATE              DEFAULT sysdate NOT NULL,       -- resv_date의 확장판 - 사용자가 신청한 등록한 로그 추적용(log4-j2)
    resv_person_count NUMBER,                                           -- 신청 인원 수
    resv_status       VARCHAR2(20)      DEFAULT '완료' NOT NULL          -- 예약 상태
);


-- 컬럼 주석
COMMENT ON TABLE  reservation_tbl                   IS '신청(예약) 정보 테이블';
COMMENT ON COLUMN reservation_tbl.resv_id           IS '예약 고유 번호 (결제 시스템과 연동)';
COMMENT ON COLUMN reservation_tbl.member_id         IS '신청자 ID';
COMMENT ON COLUMN reservation_tbl.facility_id       IS '예약 대상 시설 고유번호';
COMMENT ON COLUMN reservation_tbl.resv_content      IS '신청시 요구 사항(단순 텍스트)';
COMMENT ON COLUMN reservation_tbl.want_date         IS '예약 희망일';
COMMENT ON COLUMN reservation_tbl.resv_date         IS '예약 신청일 (프론트 화면에 나오는 용도)';
COMMENT ON COLUMN reservation_tbl.resv_log_time     IS 'resv_date의 확장판 - 사용자가 신청한 등록한 로그 추적용(log4-j2)';
COMMENT ON COLUMN reservation_tbl.resv_person_count IS '신청 인원 수';
COMMENT ON COLUMN reservation_tbl.resv_status       IS '예약 상태';


-- 제약조건
ALTER TABLE reservation_tbl ADD CONSTRAINT pk_reservation_tbl PRIMARY KEY (resv_id);                          -- PK
ALTER TABLE reservation_tbl ADD CONSTRAINT chk_resv_status CHECK (resv_status IN('완료', '취소', '대기'));      -- 예약 상태 제약(체크)
ALTER TABLE reservation_tbl ADD CONSTRAINT chk_resv_person_count CHECK (resv_person_count > 0);               -- **추가** 신청 인원수 제약(최소 한 명 이상)
ALTER TABLE reservation_tbl MODIFY resv_person_count NUMBER NOT NULL;                                         -- **추가** 신청 인원수 null값(체크 회피) 방지
ALTER TABLE reservation_tbl ADD CONSTRAINT un_resv_user_fac_date UNIQUE (member_id, facility_id, want_date);  -- **추가** 중복 예약 방지



-- FK
-- 회원 정보 테이블 연결
ALTER TABLE reservation_tbl
  ADD CONSTRAINT fk_reservation_mem
  FOREIGN KEY (member_id)
  REFERENCES member_tbl(member_id);

ALTER TABLE reservation_tbl
  ADD CONSTRAINT fk_reservation_fac
  FOREIGN KEY (facility_id)
  REFERENCES facility_tbl(facility_id);

--------------------------------------------------------------------------------

/**-*******************************************************
과거 날짜 예약 방지 트리거
want_date가 오늘보다 이전 날짜인 경우 예약 등록을 차단하는 트리거
***********************************************************/
CREATE OR REPLACE TRIGGER trg_resv_no_past_date
BEFORE INSERT OR UPDATE ON reservation_tbl
FOR EACH ROW
BEGIN
    IF :NEW.want_date < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(
            -20051,
            '과거 날짜로는 예약할 수 없습니다.'
        );
    END IF;
END;
/


/*************************************************************
예약 상태 변경 제한 트리거
취소나 완료된 예약은 다시 대기 상태로 되돌릴 수 없도록 제한하는 트리거
**************************************************************/
CREATE OR REPLACE TRIGGER trg_resv_status_transition
BEFORE UPDATE ON reservation_tbl
FOR EACH ROW
BEGIN
    IF :OLD.resv_status IN ('취소', '완료') AND :NEW.resv_status = '대기' THEN
        RAISE_APPLICATION_ERROR(
            -20052,
            '이미 완료되었거나 취소된 예약은 대기 상태로 되돌릴 수 없습니다.'
        );
    END IF;
END;
/

