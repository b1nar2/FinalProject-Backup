--------------------------------------------------------------------------------
-- 1) 시퀀스 생성 (시퀀스 + 트리거 => comments_id 자동 생성)
--------------------------------------------------------------------------------
CREATE SEQUENCE seq_comments
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

--------------------------------------------------------------------------------
-- 2) comments_tbl 테이블 생성
--------------------------------------------------------------------------------
CREATE TABLE comments_tbl (
    comments_id     NUMBER          NOT NULL,           -- 댓글 고유 번호 (PK)
    post_id         NUMBER          NOT NULL,           -- 관련 게시글 (FK)
    member_id       VARCHAR2(20)   NOT NULL,           -- 댓글 작성한 회원 (FK)
    content         VARCHAR2(1000) NOT NULL,           -- 댓글 내용
    created_at      DATE            DEFAULT SYSDATE,    -- 작성일
    updated_at      DATE                                -- 수정일
);

--------------------------------------------------------------------------------
-- 3) 테이블/컬럼 주석
--------------------------------------------------------------------------------
COMMENT ON TABLE  comments_tbl                     IS '댓글 테이블';
COMMENT ON COLUMN comments_tbl.comments_id         IS '댓글 고유 번호';
COMMENT ON COLUMN comments_tbl.post_id             IS '관련 게시글 ID';
COMMENT ON COLUMN comments_tbl.member_id           IS '댓글 작성 회원 ID';
COMMENT ON COLUMN comments_tbl.content             IS '댓글 내용';
COMMENT ON COLUMN comments_tbl.created_at          IS '댓글 작성일';
COMMENT ON COLUMN comments_tbl.updated_at          IS '댓글 수정일';

--------------------------------------------------------------------------------
-- 4) PK
--------------------------------------------------------------------------------    
ALTER TABLE comments_tbl ADD CONSTRAINT comments_tbl_pk PRIMARY KEY (comments_id); 

/*
현재 PK값 조회
SELECT constraint_name
FROM user_constraints
WHERE table_name = 'COMMENTS_TBL' AND constraint_type = 'P';
*/
--------------------------------------------------------------------------------
-- 5) CHECK 제약조건
--------------------------------------------------------------------------------
-- 빈 문자열 입력 방지
ALTER TABLE comments_tbl ADD CONSTRAINT comments_nonempty_ch CHECK (content IS NOT NULL AND TRIM(content) <> '');

-- 댓글 수정 시 updated_at이 created_at 이전의 값으로 설정되는 것을 방지
ALTER TABLE comments_tbl ADD CONSTRAINT comments_dates_ch CHECK (updated_at IS NULL OR updated_at >= created_at);

--------------------------------------------------------------------------------
-- 6) FK
--------------------------------------------------------------------------------
ALTER TABLE comments_tbl              -- FK : 게시글 삭제 시 댓글 자동 삭제
  ADD CONSTRAINT fk_comments_post
  FOREIGN KEY (post_id)
  REFERENCES post_tbl(post_id)
  ON DELETE CASCADE;

ALTER TABLE comments_tbl              -- FK : 회원 삭제 시 댓글 자동 삭제
  ADD CONSTRAINT fk_comments_member
  FOREIGN KEY (member_id)
  REFERENCES member_tbl(member_id)
  ON DELETE CASCADE;

--------------------------------------------------------------------------------
-- 7) 트리거 (시퀀스 + 트리거 => comments_id 자동 생성)
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_comments_id
BEFORE INSERT ON comments_tbl
FOR EACH ROW
BEGIN
    IF :NEW.comments_id IS NULL THEN
        :NEW.comments_id := seq_comments.NEXTVAL;
    END IF;
END;
/

--------------------------------------------------------------------------------
-- 8) 더미데이터 입력 예시
--------------------------------------------------------------------------------
/*
member_tbl에 테스트 회원 추가 -> post_tbl에 게시글 더미 추가 -> comments_tbl에 댓글 추가
순서대로 실행해야 테스트 가능
*/

-- 기존 더미데이터 삭제 후 재삽입
DELETE FROM post_tbl WHERE post_id IN (1, 2);
COMMIT;

-- 댓글 3개 추가 (comments_id는 트리거로 자동 생성)
INSERT INTO comments_tbl (post_id, member_id, content)
VALUES (3, 'hong10', '첫 번째 댓글입니다.');

INSERT INTO comments_tbl (post_id, member_id, content)
VALUES (3, 'hong10', '두 번째 댓글입니다.');

INSERT INTO comments_tbl (post_id, member_id, content)
VALUES (3, 'hong10', '다른 게시글 댓글입니다.');

--------------------------------------------------------------------------------
-- 9) 확인/조회 예시
--------------------------------------------------------------------------------
-- 1) 전체 댓글 조회
SELECT * FROM comments_tbl;

-- 2) 특정 게시글 댓글 조회 (게시글 ID = 3)
SELECT comments_id, member_id, content, created_at
FROM comments_tbl
WHERE post_id = 3
ORDER BY created_at;

-- 3) 특정 회원이 작성한 댓글 조회 (회원 ID = 'hong10')
SELECT comments_id, post_id, content, created_at
FROM comments_tbl
WHERE member_id = 'hong10'
ORDER BY created_at;

--------------------------------------------------------------------------------
-- 10) 💀 ddl 블록까지 안전 삭제 💀
--      - 실제 구조 제거 (테스트 종료 시 사용)
--------------------------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_comments_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN EXECUTE IMMEDIATE 'DROP TABLE comments_tbl CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
