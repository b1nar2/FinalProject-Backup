--------------------------------------------------------------------------------
-- 1) 시퀀스 생성 (시퀀스 + 트리거 => comment_id 자동 생성)
--------------------------------------------------------------------------------
CREATE SEQUENCE seq_comment
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

--------------------------------------------------------------------------------
-- 2) comment_tbl 테이블 생성
--------------------------------------------------------------------------------
CREATE TABLE comment_tbl (
    comment_id     NUMBER          NOT NULL,           -- 댓글 고유 번호 (PK)
    board_id       NUMBER          NOT NULL,           -- 관련 게시글 (FK)
    member_id      VARCHAR2(20)    NOT NULL,           -- 댓글 작성한 회원 (FK)
    content        VARCHAR2(1000)  NOT NULL,           -- 댓글 내용
    created_at     DATE            DEFAULT SYSDATE,    -- 작성일
    updated_at     DATE                                -- 수정일
);

--------------------------------------------------------------------------------
-- 3) 테이블/컬럼 주석
--------------------------------------------------------------------------------
COMMENT ON TABLE  comment_tbl                     IS '댓글 테이블';
COMMENT ON COLUMN comment_tbl.comment_id          IS '댓글 고유 번호';
COMMENT ON COLUMN comment_tbl.board_id            IS '관련 게시글 ID';
COMMENT ON COLUMN comment_tbl.member_id           IS '댓글 작성 회원 ID';
COMMENT ON COLUMN comment_tbl.content             IS '댓글 내용';
COMMENT ON COLUMN comment_tbl.created_at          IS '댓글 작성일';
COMMENT ON COLUMN comment_tbl.updated_at          IS '댓글 수정일';

--------------------------------------------------------------------------------
-- 4) PK
--------------------------------------------------------------------------------    
ALTER TABLE comment_tbl ADD CONSTRAINT comment_tbl_pk PRIMARY KEY (comment_id); 

--------------------------------------------------------------------------------
-- 5) CHECK 제약조건
--------------------------------------------------------------------------------
ALTER TABLE comment_tbl ADD CONSTRAINT comment_nonempty_ch 
    CHECK (TRIM(content) IS NOT NULL);

ALTER TABLE comment_tbl ADD CONSTRAINT comment_dates_ch 
    CHECK (updated_at IS NULL OR updated_at >= created_at);

--------------------------------------------------------------------------------
-- 6) FK
--------------------------------------------------------------------------------
ALTER TABLE comment_tbl
  ADD CONSTRAINT fk_comment_board
  FOREIGN KEY (board_id)
  REFERENCES board_tbl(board_id)
  ON DELETE CASCADE;

ALTER TABLE comment_tbl
  ADD CONSTRAINT fk_comment_member
  FOREIGN KEY (member_id)
  REFERENCES member_tbl(member_id)
  ON DELETE CASCADE;

--------------------------------------------------------------------------------
-- 7) 트리거 (시퀀스 + 트리거 => comment_id 자동 생성)
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_comment_id
BEFORE INSERT ON comment_tbl
FOR EACH ROW
BEGIN
    IF :NEW.comment_id IS NULL THEN
        :NEW.comment_id := seq_comment.NEXTVAL;
    END IF;
END;
/
--------------------------------------------------------------------------------
-- 8) 더미데이터 입력
--------------------------------------------------------------------------------
-- 댓글 더미데이터 삭제 + 시퀀스 삭제/재생성
DELETE FROM comment_tbl;
COMMIT;

-- 🔥 중요: 시퀀스도 같이 삭제 후 다시 생성해야 트리거가 깨지지 않음
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_comment';
EXCEPTION WHEN OTHERS THEN 
  IF SQLCODE != -2289 THEN RAISE; END IF; -- 시퀀스 없음은 무시
END;
/

CREATE SEQUENCE seq_comment
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

-- 댓글 3개 추가 (comment_id는 트리거로 자동 생성)
INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (1, 'hong10', '첫 번째 댓글입니다.');

INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (1, 'hong10', '두 번째 댓글입니다.');

INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (1, 'hong10', '다른 게시글 댓글입니다.');

INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (1, 'hong9', '테스트 게시글 댓글입니다.');

INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (2, 'hong9', '테스트 게시글 댓글입니다2.');
--------------------------------------------------------------------------------
-- 9) 확인 및 조회
--------------------------------------------------------------------------------
-- 댓글 일괄 조회
SELECT
    c.comment_id       AS "댓글ID",
    c.board_id         AS "게시글ID",
    c.member_id        AS "작성자ID",
    c.content          AS "댓글내용",
    TO_CHAR(c.created_at, 'YYYY-MM-DD HH24:MI:SS') AS "작성일",
    TO_CHAR(c.updated_at, 'YYYY-MM-DD HH24:MI:SS') AS "수정일"
FROM comment_tbl c
ORDER BY c.created_at DESC;

-- 특정 게시글의 댓글 조회 (게시판에서 조회되는 게시판ID값 입력)
SELECT
    c.comment_id       AS "댓글ID",
    c.member_id        AS "작성자ID",
    c.content          AS "댓글내용",
    TO_CHAR(c.created_at, 'YYYY-MM-DD HH24:MI:SS') AS "작성일",
    TO_CHAR(c.updated_at, 'YYYY-MM-DD HH24:MI:SS') AS "수정일"
FROM comment_tbl c
WHERE c.board_id = :boardId
ORDER BY c.created_at ASC;

-- 특정 회원의 댓글 조회 (hong10 입력)
SELECT
    c.comment_id       AS "댓글ID",
    c.board_id         AS "게시글ID",
    c.content          AS "댓글내용",
    TO_CHAR(c.created_at, 'YYYY-MM-DD HH24:MI:SS') AS "작성일",
    TO_CHAR(c.updated_at, 'YYYY-MM-DD HH24:MI:SS') AS "수정일"
FROM comment_tbl c
WHERE c.member_id = :memberId
ORDER BY c.created_at DESC;

--------------------------------------------------------------------------------
-- 10) 💀 ddl 블록까지 안전 삭제 💀
--------------------------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_comment_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE comment_tbl CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_comment'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
