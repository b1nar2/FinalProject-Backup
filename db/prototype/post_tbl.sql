-- 게시글
CREATE TABLE post_tbl (
    post_id         NUMBER NOT NULL,
    board_id        NUMBER NOT NULL,
    post_title      VARCHAR2(200) NOT NULL,
    post_content    CLOB NOT NULL,
    member_id       VARCHAR2(20) NOT NULL,
    post_reg_date   DATE DEFAULT sysdate NOT NULL,
    post_mod_date   DATE,
    post_view_count NUMBER DEFAULT 0,
    post_notice     CHAR(1) DEFAULT 'N',
    post_type       VARCHAR2(20) DEFAULT '일반' NOT NULL
);


-- PK 설정
ALTER TABLE post_tbl ADD CONSTRAINT pk_post_tbl PRIMARY KEY ( post_id ); 


-- FK 설정
-- 회원 정보 테이블 연결
ALTER TABLE post_tbl
ADD CONSTRAINT fk_post_member
FOREIGN KEY (member_id)
REFERENCES member_tbl(member_id);

-- 게시판 테이블 연결
ALTER TABLE post_tbl
ADD CONSTRAINT fk_post_board
FOREIGN KEY (board_id)
REFERENCES board_tbl(board_id);


-- 공지글 여부 제약(체크)
ALTER TABLE post_tbl
ADD CONSTRAINT chk_post_notice CHECK ( post_notice IN ( 'Y', 'N' ) );

-- 게시글 유형 제약(체크)
ALTER TABLE post_tbl
ADD CONSTRAINT chk_post_type CHECK ( post_type IN ( '공지', '일반' ) );

-- 추가 : 조회수 음수값 방지
ALTER TABLE post_tbl
ADD CONSTRAINT chk_post_view_count CHECK (post_view_count >= 0);



-- 추가 : post_type=> '공지' 일 때 post_notice 컬럼 값을 'Y'로 바꿔주는 트리거
CREATE TRIGGER trg_post_notice_sync
BEFORE INSERT OR UPDATE ON post_tbl
FOR EACH ROW
BEGIN
    IF :NEW.post_type = '공지' THEN
        :NEW.post_notice := 'Y';
    ELSE
        :NEW.post_notice := 'N';
    END IF;
END;
/

-- 주석 설정
COMMENT ON TABLE  post_tbl                  IS '게시글 테이블';
COMMENT ON COLUMN post_tbl.post_id          IS '게시글 고유번호(PK)';
COMMENT ON COLUMN post_tbl.board_id         IS '게시판 ID(FK)';
COMMENT ON COLUMN post_tbl.post_title       IS '게시글 제목';
COMMENT ON COLUMN post_tbl.post_content     IS '게시글 내용(HTML 가능)';
COMMENT ON COLUMN post_tbl.member_id        IS '작성자 id(member_tbl)';
COMMENT ON COLUMN post_tbl.post_reg_date    IS '등록일(기본값 SYSDATE)';
COMMENT ON COLUMN post_tbl.post_mod_date    IS '수정일(수정시 갱신)';
COMMENT ON COLUMN post_tbl.post_view_count  IS '조회수(기본값 0)';
COMMENT ON COLUMN post_tbl.post_notice      IS '공지글 여부(공지=Y, 일반=N, 트리거로 자동 동기화)';
COMMENT ON COLUMN post_tbl.post_type        IS '게시글 유형(공지/일반 등 구분)';