-- 결제 신청
CREATE TABLE payment_tbl (
    payment_id     NUMBER NOT NULL,
    member_id      VARCHAR2(20) NOT NULL,
    account_id     NUMBER NOT NULL,
    card_id        NUMBER NOT NULL,
    resv_id        NUMBER NOT NULL,
    payment_money  NUMBER NOT NULL,
    payment_method VARCHAR2(20) DEFAULT '계좌' NOT NULL,
    payment_status VARCHAR2(20) DEFAULT '예약중' NOT NULL,
    payment_date   DATE DEFAULT sysdate
);


-- PK 설정
ALTER TABLE payment_tbl ADD CONSTRAINT pk_payment_tbl PRIMARY KEY ( payment_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE payment_tbl
ADD CONSTRAINT fk_payment_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);

-- 결제 카드 정보 테이블 연결
ALTER TABLE payment_tbl
ADD CONSTRAINT fk_payment_card
FOREIGN KEY (card_id)
REFERENCES card_tbl(card_id);

-- 결제 계좌 정보 테이블 연결
ALTER TABLE payment_tbl
ADD CONSTRAINT fk_payment_account
FOREIGN KEY (account_id)
REFERENCES account_tbl(account_id);

-- 신청(예약)정보 연결
ALTER TABLE payment_tbl
ADD CONSTRAINT fk_payment_resv
FOREIGN KEY (resv_id)
REFERENCES reservation_tbl(resv_id);


-- 결제 상태 제약(체크)
ALTER TABLE payment_tbl 
    ADD CONSTRAINT chk_payment_status 
    CHECK ( payment_status IN ('완료', '예약중', '취소', '실패') );

-- 결제 방식 제약(체크)
ALTER TABLE payment_tbl 
    ADD CONSTRAINT chk_payment_method 
    CHECK (payment_method IN ('카드', '계좌', '현금'));

-- 추가: 결제 금액에서 음수값 제외    
ALTER TABLE payment_tbl 
ADD CONSTRAINT chk_payment_money
CHECK (payment_money >= 0);    
    
--  예약 id 중복값 방지
ALTER TABLE payment_tbl ADD CONSTRAINT un_resv_id UNIQUE ( resv_id );


-- 주석 설정
COMMENT ON COLUMN payment_tbl.payment_id        IS '결제 고유번호 (PK)';
COMMENT ON COLUMN payment_tbl.member_id         IS '계좌 소유자 회원 ID (FK)';
COMMENT ON COLUMN payment_tbl.account_id        IS '사용한 계좌 ID (FK)';
COMMENT ON COLUMN payment_tbl.card_id           IS '사용한 카드 ID (FK)';
COMMENT ON COLUMN payment_tbl.resv_id           IS '연결된 예약 ID (FK)';
COMMENT ON COLUMN payment_tbl.payment_money     IS '결제금액';
COMMENT ON COLUMN payment_tbl.payment_method    IS '결제 방식(계좌/카드 중 선택)';
COMMENT ON COLUMN payment_tbl.payment_status    IS '결제 상태(''완료'', ''예약중'', ''취소'', ''실패'')';
COMMENT ON COLUMN payment_tbl.payment_date      IS '결제일시';