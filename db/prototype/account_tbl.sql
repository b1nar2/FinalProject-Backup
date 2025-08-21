-- 결제 계좌 정보
CREATE TABLE account_tbl (
    account_id       NUMBER NOT NULL,
    member_id        VARCHAR2(20) NOT NULL,
    account_bank     VARCHAR2(50) NOT NULL,
    account_number   VARCHAR2(20) NOT NULL,
    account_main     CHAR(1) DEFAULT 'N' NOT NULL,
    account_reg_date DATE DEFAULT SYSDATE
);


-- PK 설정
ALTER TABLE account_tbl ADD CONSTRAINT pk_account_tbl PRIMARY KEY ( account_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE account_tbl
ADD CONSTRAINT fk_account_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);

-- 대표 계좌 여부 제약(체크)
ALTER TABLE account_tbl
    ADD CONSTRAINT chk_account_main
        CHECK (account_main IN('Y', 'N') );
        
        
-- 주석 설정
COMMENT ON TABLE  account_tbl                   IS '결제 계좌 정보';
COMMENT ON COLUMN account_tbl.account_id        IS '회원 계좌 고유번호 (PK)';
COMMENT ON COLUMN account_tbl.member_id         IS '계좌 소유자 회원 ID (FK)';
COMMENT ON COLUMN account_tbl.account_bank      IS '계좌 은행명 (예: 국민은행, 카카오뱅크 등)';
COMMENT ON COLUMN account_tbl.account_number    IS '실제 계좌번호';
COMMENT ON COLUMN account_tbl.account_main      IS'대표 계좌 여부 (Y/N)';
COMMENT ON COLUMN account_tbl.account_reg_date  IS '계좌 등록일';