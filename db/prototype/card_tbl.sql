-- 결제 카드 정보
CREATE TABLE card_tbl (
    card_id       NUMBER NOT NULL,
    member_id     VARCHAR2(20) NOT NULL,
    card_bank     VARCHAR2(50) NOT NULL,
    card_number   VARCHAR2(30) NOT NULL,    -- 카드번호 길이 20 -> 30으로 조정
    card_approval VARCHAR2(30),
    card_main     CHAR(1) DEFAULT 'N' NOT NULL,
    card_reg_date DATE DEFAULT sysdate
);


-- PK 설정
ALTER TABLE card_tbl ADD CONSTRAINT pk_card_tbl PRIMARY KEY ( card_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE card_tbl
ADD CONSTRAINT fk_card_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);


-- 대표 카드 설정 제약(체크)
ALTER TABLE card_tbl
ADD CONSTRAINT chk_card_main
CHECK (card_main IN ('Y', 'N'));


-- 카드 번호 중복 제약
ALTER TABLE card_tbl
ADD CONSTRAINT un_card_number UNIQUE ( card_number );


-- 주석 설정
COMMENT ON TABLE  card_tbl                  IS '결제 카드 정보'; 
COMMENT ON COLUMN card_tbl.card_id          IS '카드 고유번호 (PK)';
COMMENT ON COLUMN card_tbl.member_id        IS '계좌 소유자 회원 ID (FK)';
COMMENT ON COLUMN card_tbl.card_bank        IS '카드사명 (신한, 현대 등)';
COMMENT ON COLUMN card_tbl.card_number      IS '카드번호';
COMMENT ON COLUMN card_tbl.card_approval    IS '카드 승인번호';
COMMENT ON COLUMN card_tbl.card_main        IS '대표 계좌 여부 (Y/N)';
COMMENT ON COLUMN card_tbl.card_reg_date    IS '카드 등록일';