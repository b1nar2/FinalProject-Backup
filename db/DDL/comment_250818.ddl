--------------------------------------------------------------------------------
-- 1) 시퀀스 생성 (시퀀스 + 트리거 => comment_id 자동 생성)
--------------------------------------------------------------------------------
CREATE SEQUENCE seq_comment
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

--------------------------------------------------------------------------------
-- 2) commetn_tbl 테이블 생성
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

/*
현재 PK값 조회
SELECT constraint_name
FROM user_constraints
WHERE table_name = 'COMMENT_TBL' AND constraint_type = 'P';
*/
--------------------------------------------------------------------------------
-- 5) CHECK 제약조건
--------------------------------------------------------------------------------
-- 빈문자 입력 방지
ALTER TABLE comment_tbl    ADD CONSTRAINT comment_nonempty_ch    CHECK (TRIM(content) IS NOT NULL);

-- 댓글 수정 시 updated_at이 created_at 이전의 값으로 설정되는 것을 방지
ALTER TABLE comment_tbl    ADD CONSTRAINT comment_dates_ch       CHECK (updated_at IS NULL OR updated_at >= created_at);

--------------------------------------------------------------------------------
-- 6) FK
--------------------------------------------------------------------------------
ALTER TABLE comment_tbl              -- FK
  ADD CONSTRAINT fk_comment_board
  FOREIGN KEY (board_id)
  REFERENCES board_tbl(board_id)
  ON DELETE CASCADE;  -- 게시글 삭제시 댓글 자동 삭제

ALTER TABLE comment_tbl              -- FK
  ADD CONSTRAINT fk_comment_member
  FOREIGN KEY (member_id)
  REFERENCES member_tbl(member_id)
  ON DELETE CASCADE;  -- 게시글 삭제시 댓글 자동 삭제

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
/*
member_tbl에 테스트 회원 추가 -> board_tbl에 게시글 더미 추가 -> comment_tbl에 댓글 추가

순서대로 실행해야 테스트 가능
*/

-- 기존 더미데이터 삭제 후 재삽입
DELETE FROM board_tbl WHERE board_id IN (1, 2);
COMMIT;

-- 댓글 3개 추가 (comment_id는 트리거로 자동 생성)
INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (1, 'hong10', '첫 번째 댓글입니다.');

INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (1, 'hong10', '두 번째 댓글입니다.');

INSERT INTO comment_tbl (board_id, member_id, content)
VALUES (1, 'hong10', '다른 게시글 댓글입니다.');

--------------------------------------------------------------------------------
-- 9) 확인/조회
--------------------------------------------------------------------------------
-- 1) 전체 댓글 조회
SELECT * FROM comment_tbl;

-- 2) 특정 게시글 댓글 조회 (게시글 ID = 1)
SELECT comment_id, member_id, content, created_at
FROM comment_tbl
WHERE board_id = 1
ORDER BY created_at;

-- 3) 특정 회원이 작성한 댓글 조회 (회원 ID = 'hong10')
SELECT comment_id, board_id, content, created_at
FROM comment_tbl
WHERE member_id = 'hong10'
ORDER BY created_at;



--------------------------------------------------------------------------------
-- 10) 💀 ddl 블록까지 안전 삭제 💀
--      - 실제 구조 제거 (테스트 종료 시 사용)
--------------------------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_comment_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE comment_tbl CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

