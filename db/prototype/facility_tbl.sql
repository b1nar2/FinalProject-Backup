-- 시설 정보 테이블
CREATE TABLE facility_tbl (
    facility_id           NUMBER NOT NULL,
    facility_name         VARCHAR2(100) NOT NULL,
    member_id             VARCHAR2(20),-- not null 삭제: 강사 삭제시 null값으로 지정해두기 위해 삭제
    facility_phone        VARCHAR2(20),
    facility_content      CLOB,
    facility_image_path   VARCHAR2(200),
    facility_person_max   NUMBER,
    facility_person_min   NUMBER,
    facility_use          CHAR(1) NOT NULL DEFAULT 'Y' ,
    facility_reg_date     DATE DEFAULT SYSDATE NOT NULL,
    facility_mod_date     DATE DEFAULT SYSDATE NOT NULL, -- 디폴트값 sysdate 추가
    facility_open_time    VARCHAR2(5),-- date -> VARCHAR2(5)변경 : 날짜 혼입 방지를 위해 변경 (HH24:MI 형식으로 표기)
    facility_close_time   VARCHAR2(5) --  위와 같음
);


-- PK 설정
ALTER TABLE facility_tbl ADD CONSTRAINT pk_facility_tbl PRIMARY KEY ( facility_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE facility_tbl
ADD CONSTRAINT fk_facility_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id)
ON DELETE SET NULL; -- 강사 삭제 시 facility_tbl.member_id를 NULL로 변경(시설정보는 그대로, 강사만 없는 경우를 표기하기 위함)


-- 사용 가능 여부 제약(체크)
ALTER TABLE facility_tbl
ADD CONSTRAINT chk_facility_use
CHECK (facility_use in ('Y', 'N'));

-- 최대/최소 인원 제약(체크)
ALTER TABLE facility_tbl
ADD CONSTRAINT chk_facility_person
CHECK (facility_person_max >= facility_person_min
       AND facility_person_max > 0
       AND facility_person_min > 0);


-- 수정일 자동 업데이트 트리거
CREATE OR REPLACE TRIGGER trg_facility_mod_date
BEFORE UPDATE ON facility_tbl
FOR EACH ROW
BEGIN
    :NEW.facility_mod_date := SYSDATE;
END;
/

/*
BEFORE UPDATE: UPDATE 실행 직전에 동작.
FOR EACH ROW: 변경되는 각 행마다 적용.
:NEW.facility_mod_date := SYSDATE; → 새로 저장되는 facility_mod_date 값이 현재 시각으로 변경됨.
*/

-- 주석 설정
COMMENT ON TABLE  facility_tbl                          IS '시설 정보 테이블';
COMMENT ON COLUMN facility_tbl.facility_id              IS '시설 고유 번호';
COMMENT ON COLUMN facility_tbl.facility_name            IS '시설명';
COMMENT ON COLUMN facility_tbl.member_id                IS '강사ID(관리자ID)';
COMMENT ON COLUMN facility_tbl.facility_phone           IS '시설 연락처';
COMMENT ON COLUMN facility_tbl.facility_content         IS '설명 HTML 내용';
COMMENT ON COLUMN facility_tbl.facility_image_path      IS '이미지 경로';
COMMENT ON COLUMN facility_tbl.facility_person_max      IS '최대인원';
COMMENT ON COLUMN facility_tbl.facility_person_min      IS '최소인원';
COMMENT ON COLUMN facility_tbl.facility_use             IS '사용 가능 여부';
COMMENT ON COLUMN facility_tbl.facility_reg_date        IS '시설 등록일';
COMMENT ON COLUMN facility_tbl.facility_mod_date        IS '시설 수정일';
COMMENT ON COLUMN facility_tbl.facility_open_time       IS '운영 시작 시간';
COMMENT ON COLUMN facility_tbl.facility_close_time      IS '운영 종료 시간';
