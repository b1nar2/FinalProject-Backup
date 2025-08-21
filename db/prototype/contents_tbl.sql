-- 콘텐츠
CREATE TABLE contents_tbl (
    content_id       NUMBER NOT NULL,
    content_title    VARCHAR2(100) NOT NULL,
    content_content  CLOB,
    member_id        VARCHAR2(20) NOT NULL,
    content_reg_date DATE DEFAULT sysdate,
    content_mod_date DATE,
    content_use      CHAR(1)
     DEFAULT 'Y' NOT NULL
);


-- PK 설정
ALTER TABLE contents_tbl ADD CONSTRAINT pk_contents_tbl PRIMARY KEY ( content_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE contents_tbl
ADD CONSTRAINT fk_contentㄴ_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);


-- 사용 여부 제약(체크)
ALTER TABLE contents_tbl
ADD CONSTRAINT content_use_ch CHECK ( content_use IN ( 'Y', 'N' ) );


-- 주석 설정
COMMENT ON TABLE  contents_tbl                  IS '콘텐츠 테이블';
COMMENT ON COLUMN contents_tbl.content_id       IS '콘텐츠 고유 ID';
COMMENT ON COLUMN contents_tbl.content_title    IS '콘텐츠 제목';
COMMENT ON COLUMN contents_tbl.content_content  IS '콘텐츠 본문 내용';
COMMENT ON COLUMN contents_tbl.member_id        IS '회원ID';
COMMENT ON COLUMN contents_tbl.content_reg_date IS '작성일';
COMMENT ON COLUMN contents_tbl.content_mod_date IS '수정일';
COMMENT ON COLUMN contents_tbl.content_use      IS '사용여부(활성화/비활성화)';