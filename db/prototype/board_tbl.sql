-- 게시판
CREATE TABLE board_tbl (
    board_id       NUMBER, -- 게시글 번호 자동 증가
    board_title    VARCHAR2(50) NOT NULL,
    board_content  VARCHAR2(100) NOT NULL,
    board_use      CHAR(1) DEFAULT 'Y' NOT NULL,
    board_reg_date DATE DEFAULT sysdate NOT NULL,
    board_mod_date DATE,
    member_id      VARCHAR2(20) NOT NULL
);


-- PK 설정
ALTER TABLE board_tbl ADD CONSTRAINT pk_board_tbl PRIMARY KEY ( board_id );


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE board_tbl
ADD CONSTRAINT fk_board_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);


-- 사용 여부 제약(체크)
ALTER TABLE board_tbl
ADD CONSTRAINT chk_board_use CHECK ( board_use IN ( 'Y', 'N' ) );


-- 주석 설정
COMMENT ON TABLE  board_tbl                 IS '게시판 테이블';
COMMENT ON COLUMN board_tbl.board_title     IS '게시판 이름(공지사항 등)';
COMMENT ON COLUMN board_tbl.board_content   IS '게시판 상단내용';
COMMENT ON COLUMN board_tbl.board_use       IS '사용여부(활성화/비활성화)';
COMMENT ON COLUMN board_tbl.board_reg_date  IS '생성일자(기본값 SYSDATE)';
COMMENT ON COLUMN board_tbl.board_mod_date  IS '수정일자(수정시 갱신)';
COMMENT ON COLUMN board_tbl.member_id       IS '회원(작성자)id';