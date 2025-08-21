-- 1) 휴무일 설정 테이블 생성
CREATE TABLE closed_day_tbl (
    closed_id   NUMBER NOT NULL,                -- 휴무일 고유 번호
    facility_id NUMBER NOT NULL,                -- 대상 시설 ID
    closed_date DATE NOT NULL,                  -- 휴무일 날짜
    reason      VARCHAR2(200)                   -- 휴무 사유
);


-- 컬럼 주석
COMMENT ON TABLE closed_day_tbl                 IS '휴무일 설정 테이블';
COMMENT ON COLUMN closed_day_tbl.closed_id      IS '휴무일 고유 번호';
COMMENT ON COLUMN closed_day_tbl.facility_id    IS '대상 시설 ID';
COMMENT ON COLUMN closed_day_tbl.closed_date    IS '휴무일 날짜';
COMMENT ON COLUMN closed_day_tbl.reason         IS '휴무 사유';


-- PK 설정
ALTER TABLE closed_day_tbl ADD CONSTRAINT pk_closed_day_tbl PRIMARY KEY ( closed_id );                  -- PK
ALTER TABLE closed_day_tbl ADD CONSTRAINT un_closed_day_total UNIQUE ( facility_id, closed_date );      -- 동일 시설 중복 방지 제약



-- FK
ALTER TABLE closed_day_tbl
  ADD CONSTRAINT fk_closed_fac
  FOREIGN KEY (facility_id)
  REFERENCES facility_tbl (facility_id);
  
--------------------------------------------------------------------------------
-- 2) 트리거 설정

/************************************************
휴무 사유가 없으면 기본값 자동 입력 (AFTER INSERT)
reason 값이 비어 있는 경우 기본 사유를 넣어주는 트리거
*************************************************/

CREATE OR REPLACE TRIGGER trg_closed_day_default_reason
BEFORE INSERT ON closed_day_tbl
FOR EACH ROW
BEGIN
  IF :NEW.reason IS NULL THEN
    :NEW.reason := '정기 휴무';
  END IF;
END;
/


/*****************************************************************
과거 날짜 등록 방지 트리거
휴무일은 미래 날짜 또는 당일만 허용하고, 과거 날짜는 등록하지 못하도록 방지
******************************************************************/
CREATE OR REPLACE TRIGGER trg_closed_day_no_past
BEFORE INSERT OR UPDATE ON closed_day_tbl
FOR EACH ROW
BEGIN
  IF :NEW.closed_date < TRUNC(SYSDATE) THEN
    RAISE_APPLICATION_ERROR(
      -20051,
      '과거 날짜로는 휴무일을 설정할 수 없습니다.'
    );
  END IF;
END;
/


--------------------------------------------------------------------------------

/*********************************
 3) 기존 더미 데이터 삭제 (중복 방지)
**********************************/
DELETE FROM closed_day_tbl WHERE closed_id IN (1, 2, 3);
COMMIT;

-- 더미 데이터 삽입
INSERT INTO closed_day_tbl (closed_id, facility_id, closed_date, reason)
VALUES (1, 101, TO_DATE('2025-08-25', 'YYYY-MM-DD'), NULL);  -- reason은 NULL, 트리거로 '정기 휴무' 자동 입력

INSERT INTO closed_day_tbl (closed_id, facility_id, closed_date, reason)
VALUES (2, 102, TO_DATE('2025-08-26', 'YYYY-MM-DD'), '임시 점검');

INSERT INTO closed_day_tbl (closed_id, facility_id, closed_date, reason)
VALUES (3, 101, TO_DATE('2025-08-27', 'YYYY-MM-DD'), NULL);

COMMIT;


/********************************
 4) 확인 조회
*********************************/

SELECT
    closed_id                          AS "휴무일ID",
    facility_id                       AS "시설ID",
    TO_CHAR(closed_date, 'YYYY-MM-DD') AS "휴무일자",
    NVL(reason, '정기 휴무')           AS "사유"
FROM closed_day_tbl
ORDER BY facility_id, closed_date;


