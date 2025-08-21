-- 문자 전송
CREATE TABLE message_tbl (
    message_id      NUMBER NOT NULL,
    member_id       VARCHAR2(20) NOT NULL,
    resv_id         NUMBER NOT NULL,
    closed_id       NUMBER NOT NULL,
    message_type    VARCHAR2(20) NOT NULL,
    message_content CLOB,
    message_date    DATE DEFAULT sysdate NOT NULL
);


-- PK 설정
ALTER TABLE message_tbl ADD CONSTRAINT pk_message_tbl PRIMARY KEY ( message_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE message_tbl
ADD CONSTRAINT fk_message_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);

-- 휴무일 설정 테이블 연결
ALTER TABLE message_tbl
ADD CONSTRAINT fk_message_closed_day
FOREIGN KEY (closed_id)
REFERENCES closed_day_tbl(closed_id);

-- 신청(예약) 정보 테이블 연결
ALTER TABLE message_tbl
ADD CONSTRAINT fk_message_resv
FOREIGN KEY (resv_id)
REFERENCES reservation_tbl(resv_id);


-- 메시지 타입 제약(체크)
ALTER TABLE message_tbl
ADD CONSTRAINT chk_message_type
CHECK ( message_type IN('예약확인', '예약취소', '휴관공지') );


--  같은 시간에 같은 유형 문자 중복 방지
ALTER TABLE message_tbl
ADD CONSTRAINT un_message_total UNIQUE ( member_id,
                                         message_type,
                                         message_date );


-- 주석 설정
COMMENT ON TABLE  message_tbl                  IS '문자 전송 테이블';
COMMENT ON COLUMN message_tbl.message_id       IS '문자 고유 이력 ID';
COMMENT ON COLUMN message_tbl.member_id        IS '문자 수신자 ID';
COMMENT ON COLUMN message_tbl.resv_id          IS '관련 예약 ID';
COMMENT ON COLUMN message_tbl.closed_id        IS '관련 휴관일 ID';
COMMENT ON COLUMN message_tbl.message_type     IS '문자 분류 유형';
COMMENT ON COLUMN message_tbl.message_content  IS '실제 발송된 문자 내역';
COMMENT ON COLUMN message_tbl.message_date     IS '문자 발송 일시';