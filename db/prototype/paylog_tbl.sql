-- 결제 로그
CREATE TABLE paylog_tbl (
    paylog_id            NUMBER NOT NULL,
    payment_id           NUMBER NOT NULL,
    member_id            VARCHAR2(20) NOT NULL,
    card_id              NUMBER NOT NULL,
    account_id           NUMBER NOT NULL,
    resv_id              NUMBER NOT NULL,
    paylog_type          VARCHAR2(20) DEFAULT '결제' NOT NULL,
    paylog_before_status VARCHAR2(20),
    paylog_after_status  VARCHAR2(20),
    paylog_money         NUMBER,
    paylog_method        VARCHAR2(20),
    paylog_manager       VARCHAR2(20),
    paylog_history       DATE DEFAULT sysdate NOT NULL,
    paylog_memo          VARCHAR2(1000)
);


-- PK 설정
ALTER TABLE paylog_tbl ADD CONSTRAINT pk_paylog_tbl PRIMARY KEY ( paylog_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE paylog_tbl
ADD CONSTRAINT fk_paylog_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);

-- 결제 카드 정보 테이블 연결
ALTER TABLE paylog_tbl
ADD CONSTRAINT fk_paylog_card
FOREIGN KEY (card_id)
REFERENCES card_tbl(card_id);

-- 결제 계좌 정보 테이블 연결
ALTER TABLE paylog_tbl
ADD CONSTRAINT fk_paylog_account
FOREIGN KEY (account_id)
REFERENCES account_tbl(account_id);

-- 결제 신청 테이블 연결
ALTER TABLE paylog_tbl
ADD CONSTRAINT fk_paylog_payment
FOREIGN KEY (payment_id)
REFERENCES payment_tbl(payment_id);

-- 신청(예약) 정보 테이블 연결
ALTER TABLE paylog_tbl
ADD CONSTRAINT fk_paylog_resv
FOREIGN KEY (resv_id)
REFERENCES reservation_tbl(resv_id);


-- 결제 동작 유형 제약(체크)
ALTER TABLE paylog_tbl
ADD CONSTRAINT chk_paylog_type
CHECK (paylog_type IN('결제', '취소', '환불', '실패', '수정', '삭제') );


-- 주석 설정
COMMENT ON TABLE  paylog_tbl                        IS '결제 로그 테이블';
COMMENT ON COLUMN paylog_tbl.paylog_id              IS '결제 로그 고유번호(PK)';
COMMENT ON COLUMN paylog_tbl.payment_id             IS '결제 PK(FK)';
COMMENT ON COLUMN paylog_tbl.member_id              IS '결제자 회원 ID(FK)';
COMMENT ON COLUMN paylog_tbl.card_id                IS '결제에 사용된 카드 ID (FK)';
COMMENT ON COLUMN paylog_tbl.account_id             IS '결제에 사용된 계좌 ID (FK)';
COMMENT ON COLUMN paylog_tbl.resv_id                IS '예약 ID(예약과 연동 시)';
COMMENT ON COLUMN paylog_tbl.paylog_type            IS '결제 동작 유형(결제/취소 등)';
COMMENT ON COLUMN paylog_tbl.paylog_before_status   IS '변경 전 결제 상태';
COMMENT ON COLUMN paylog_tbl.paylog_after_status    IS '변경 후 결제 상태';
COMMENT ON COLUMN paylog_tbl.paylog_money           IS '결제 금액';
COMMENT ON COLUMN paylog_tbl.paylog_method          IS '결제 방식(카드/계좌)';
COMMENT ON COLUMN paylog_tbl.paylog_manager         IS '담당자(작업자 ID)';
COMMENT ON COLUMN paylog_tbl.paylog_history         IS '결제 로그 기록 시각';
COMMENT ON COLUMN paylog_tbl.paylog_memo            IS '기타사항 입력1(1000자 이내)';