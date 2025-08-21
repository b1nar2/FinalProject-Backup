-- =========================================================
-- 🔧 공통: 스키마 고정 (DDL에 스키마 접두어 없음)
-- =========================================================
-- ALTER SESSION SET CURRENT_SCHEMA = gym;    -- ← 필요 시 스키마 고정

-- ============================================================================
-- 체육관 예약시스템 - 결제/결제로그 "통합 스키마 + 더미데이터 + 초기화(현금 제거판)"
--    규칙(최종): payment_method 별 FK 조합 강제
--          - '계좌' → account_id 필수 / card_id NULL              -- 현금 제거
--          - '카드' → card_id 필수 / account_id NULL              -- 현금 제거
--    선행 조건: member_tbl, account_tbl, card_tbl, reservation_tbl 존재
--    실행 순서: [0)드롭]→[1)payment]→[2)수단검증 트리거]→[3)paylog]→[더미]→[확인]→[초기화]
-- ============================================================================

--------------------------------------------------------------------------------
-- 0) 재실행 안전 드롭 (자식→부모 순서로 드롭, 없으면 무시)
--------------------------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_bdel_to_paylog';          EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_ins_upd_to_paylog';       EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_paylog_id';                        EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE paylog_tbl CASCADE CONSTRAINTS';         EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942  THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_method_fk_chk';            EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_id';                       EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE payment_tbl CASCADE CONSTRAINTS';        EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942  THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_paylog_id';                       EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_payment_id';                      EXCEPTION WHEN OTHERS THEN IF SQLCODE != -2289 THEN RAISE; END IF; END;
/

--------------------------------------------------------------------------------
-- 1) 결제 테이블 (payment_tbl) 생성 + 기본 제약/인덱스 + 자동채번
--------------------------------------------------------------------------------
CREATE TABLE payment_tbl (                                  -- 결제신청 + 결제내역 저장 테이블
    payment_id      NUMBER        NOT NULL,                 -- 결제 고유번호(PK)
    member_id       VARCHAR2(20)  NOT NULL,                 -- 결제자 회원ID (FK → member_tbl.member_id)
    account_id      NUMBER        NULL,                     -- 계좌 결제 시 사용하는 계좌ID (FK)
    card_id         NUMBER        NULL,                     -- 카드 결제 시 사용하는 카드ID (FK)
    resv_id         NUMBER        NOT NULL,                 -- 연결된 예약ID (FK → reservation_tbl.resv_id)
    payment_money   NUMBER        NOT NULL,                 -- 결제금액(원)
    payment_method  VARCHAR2(20)  DEFAULT '계좌' NOT NULL,  -- 결제수단('카드','계좌')  ← 현금 제거
    payment_status  VARCHAR2(20)  DEFAULT '예약중' NOT NULL,-- 결제상태('완료','예약중','취소','실패')
    payment_date    DATE          DEFAULT SYSDATE           -- 결제일시
);

COMMENT ON TABLE  payment_tbl IS '결제신청+내역';
COMMENT ON COLUMN payment_tbl.payment_id     IS '결제 고유번호(PK)';
COMMENT ON COLUMN payment_tbl.member_id      IS '결제자 회원ID';
COMMENT ON COLUMN payment_tbl.account_id     IS '계좌 결제 시 사용하는 계좌ID';
COMMENT ON COLUMN payment_tbl.card_id        IS '카드 결제 시 사용하는 카드ID';
COMMENT ON COLUMN payment_tbl.resv_id        IS '연결된 예약ID';
COMMENT ON COLUMN payment_tbl.payment_money  IS '결제금액(원 단위)';
COMMENT ON COLUMN payment_tbl.payment_method IS '결제수단(카드/계좌)';      -- 현금 문구 삭제
COMMENT ON COLUMN payment_tbl.payment_status IS '결제상태(완료/예약중/취소/실패)';
COMMENT ON COLUMN payment_tbl.payment_date   IS '결제일시';

ALTER TABLE payment_tbl ADD CONSTRAINT payment_tbl_pk PRIMARY KEY (payment_id);                              -- PK 정의
-- 결제수단 체크(현금 제거)
ALTER TABLE payment_tbl ADD CONSTRAINT payment_method_CH CHECK (payment_method IN ('카드','계좌'));
-- 상태 체크
ALTER TABLE payment_tbl ADD CONSTRAINT payment_status_CH CHECK (payment_status IN ('완료','예약중','취소','실패'));

-- FK
ALTER TABLE payment_tbl ADD CONSTRAINT fk_payment_member  FOREIGN KEY (member_id) REFERENCES member_tbl(member_id);
ALTER TABLE payment_tbl ADD CONSTRAINT fk_payment_account FOREIGN KEY (account_id) REFERENCES account_tbl(account_id);
ALTER TABLE payment_tbl ADD CONSTRAINT fk_payment_card    FOREIGN KEY (card_id)    REFERENCES card_tbl(card_id);
ALTER TABLE payment_tbl ADD CONSTRAINT fk_payment_resv    FOREIGN KEY (resv_id)    REFERENCES reservation_tbl(resv_id);

-- 인덱스
CREATE INDEX idx_payment_member ON payment_tbl(member_id);
CREATE INDEX idx_payment_resv   ON payment_tbl(resv_id);
CREATE INDEX idx_payment_date   ON payment_tbl(payment_date);

-- 시퀀스 + 자동채번
CREATE SEQUENCE seq_payment_id START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
/
CREATE OR REPLACE TRIGGER trg_payment_id
BEFORE INSERT ON payment_tbl
FOR EACH ROW
BEGIN
  IF :NEW.payment_id IS NULL THEN
    :NEW.payment_id := seq_payment_id.NEXTVAL;                                   -- NULL일 때만 시퀀스 할당
  END IF;
END;
/
-- ✅ payment_id 자동 채번 완료

--------------------------------------------------------------------------------
-- 2) 결제수단별 FK 유효성 강제 트리거 (계좌/카드만 허용)
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_payment_method_fk_chk
BEFORE INSERT OR UPDATE OF payment_method, account_id, card_id ON payment_tbl
FOR EACH ROW
BEGIN
  -- 허용 값 검증(현금 제외)
  IF :NEW.payment_method NOT IN ('계좌','카드') THEN
    RAISE_APPLICATION_ERROR(-20081, 'payment_method는 계좌/카드만 허용됩니다.');
  END IF;

  -- 조합 무결성: 계좌
  IF :NEW.payment_method = '계좌' THEN
    IF :NEW.account_id IS NULL OR :NEW.card_id IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(-20082, '계좌 결제는 account_id 필수, card_id는 NULL이어야 합니다.');
    END IF;

  -- 조합 무결성: 카드
  ELSIF :NEW.payment_method = '카드' THEN
    IF :NEW.card_id IS NULL OR :NEW.account_id IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(-20083, '카드 결제는 card_id 필수, account_id는 NULL이어야 합니다.');
    END IF;
  END IF;
END;
/
-- ✅ 수단별 FK 조합 무결성 강제(현금 제거) 완료

--------------------------------------------------------------------------------
-- 3) 결제로그 테이블 (paylog_tbl) + FK('ON DELETE SET NULL') + 자동채번 + 로그 트리거
--------------------------------------------------------------------------------
CREATE TABLE paylog_tbl (                                        -- 결제 변경 이력(로그)
    paylog_id            NUMBER        NOT NULL,                  -- 로그 고유번호(PK)
    payment_id           NUMBER        NULL,                      -- 결제ID(FK, 부모 삭제 시 NULL 처리)
    paylog_type          VARCHAR2(20)  NOT NULL,                  -- 로그유형('결제','취소','환불','실패','수정','삭제')
    paylog_before_status VARCHAR2(20),                            -- 변경 전 상태
    paylog_after_status  VARCHAR2(20),                            -- 변경 후 상태
    paylog_money         NUMBER,                                  -- 금액
    paylog_method        VARCHAR2(20),                            -- 결제수단
    paylog_manager       VARCHAR2(20),                            -- 담당자
    paylog_memo          VARCHAR2(200),                           -- 메모
    paylog_date          DATE DEFAULT SYSDATE                     -- 로그 시각
);

COMMENT ON TABLE  paylog_tbl IS '결제 변경 이력(로그)';
COMMENT ON COLUMN paylog_tbl.paylog_id            IS '결제 로그 고유번호(PK)';
COMMENT ON COLUMN paylog_tbl.payment_id           IS '결제ID(FK, 부모 삭제 시 NULL)';
COMMENT ON COLUMN paylog_tbl.paylog_type          IS '로그유형(결제/취소/환불/실패/수정/삭제)';
COMMENT ON COLUMN paylog_tbl.paylog_before_status IS '변경 전 상태';
COMMENT ON COLUMN paylog_tbl.paylog_after_status  IS '변경 후 상태';
COMMENT ON COLUMN paylog_tbl.paylog_money         IS '금액';
COMMENT ON COLUMN paylog_tbl.paylog_method        IS '결제수단';
COMMENT ON COLUMN paylog_tbl.paylog_manager       IS '담당자';
COMMENT ON COLUMN paylog_tbl.paylog_memo          IS '메모';
COMMENT ON COLUMN paylog_tbl.paylog_date          IS '로그 시각';

ALTER TABLE paylog_tbl ADD CONSTRAINT paylog_tbl_pk PRIMARY KEY (paylog_id);
ALTER TABLE paylog_tbl ADD CONSTRAINT paylog_type_CH CHECK (paylog_type IN ('결제','취소','환불','실패','수정','삭제'));
ALTER TABLE paylog_tbl ADD CONSTRAINT fk_paylog_payment
  FOREIGN KEY (payment_id) REFERENCES payment_tbl(payment_id) ON DELETE SET NULL;  -- 부모 삭제 시 FK만 NULL

CREATE INDEX idx_paylog_payment ON paylog_tbl(payment_id);
CREATE INDEX idx_paylog_date    ON paylog_tbl(paylog_date);

CREATE SEQUENCE seq_paylog_id START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
/
CREATE OR REPLACE TRIGGER trg_paylog_id
BEFORE INSERT ON paylog_tbl
FOR EACH ROW
BEGIN
  IF :NEW.paylog_id IS NULL THEN
    :NEW.paylog_id := seq_paylog_id.NEXTVAL;                                     -- NULL일 때만 시퀀스 할당
  END IF;
END;
/
-- ✅ paylog_id 자동 채번 완료

-- (A) INSERT/UPDATE 로그 (부모 존재 보장 → AFTER)
CREATE OR REPLACE TRIGGER trg_payment_ins_upd_to_paylog
AFTER INSERT OR UPDATE ON payment_tbl
FOR EACH ROW
DECLARE
  v_type VARCHAR2(20);
BEGIN
  IF INSERTING THEN
    v_type := '결제';
    INSERT INTO paylog_tbl(payment_id, paylog_type, paylog_after_status, paylog_money, paylog_method, paylog_date)
    VALUES (:NEW.payment_id, v_type, :NEW.payment_status, :NEW.payment_money, :NEW.payment_method, SYSDATE);

  ELSIF UPDATING THEN
    v_type := '수정';
    INSERT INTO paylog_tbl(payment_id, paylog_type, paylog_before_status, paylog_after_status, paylog_money, paylog_method, paylog_date)
    VALUES (:OLD.payment_id, v_type, :OLD.payment_status, :NEW.payment_status, :NEW.payment_money, :NEW.payment_method, SYSDATE);
  END IF;
END;
/
-- ✅ 삽입/수정 로그 기록

-- (B) DELETE 로그 (부모가 아직 존재할 때 기록 → BEFORE)
CREATE OR REPLACE TRIGGER trg_payment_bdel_to_paylog
BEFORE DELETE ON payment_tbl
FOR EACH ROW
BEGIN
  INSERT INTO paylog_tbl(payment_id, paylog_type, paylog_before_status, paylog_money, paylog_method, paylog_date)
  VALUES (:OLD.payment_id, '삭제', :OLD.payment_status, :OLD.payment_money, :OLD.payment_method, SYSDATE);
  -- 이후 부모 삭제 시 paylog.payment_id는 ON DELETE SET NULL로 자동 NULL 처리
END;
/
-- ✅ 삭제 로그 기록(+부모 삭제 후에도 로그 보존)

--------------------------------------------------------------------------------
-- 4) 더미데이터 (부모 존재 검증 → 중복정리 → 삽입)  ※ 현금 제거: 2건만 생성
--    전제: member_tbl('hong1','hong2'), account_tbl.account_id=1,
--          card_tbl.card_id=1, reservation_tbl.resv_id=1,2 존재
--------------------------------------------------------------------------------
DECLARE
  v_cnt NUMBER;
BEGIN
  -- (1) 회원 존재 검증
  SELECT COUNT(*) INTO v_cnt FROM member_tbl WHERE member_id IN ('hong1','hong2');
  IF v_cnt < 2 THEN
    RAISE_APPLICATION_ERROR(-20901, '더미 실패: member_tbl에 hong1, hong2가 모두 존재해야 합니다.');
  END IF;

  -- (2) 계좌/카드 존재 검증
  SELECT COUNT(*) INTO v_cnt FROM account_tbl WHERE account_id = 1;
  IF v_cnt = 0 THEN
    RAISE_APPLICATION_ERROR(-20902, '더미 실패: account_tbl.account_id=1 이 필요합니다.');
  END IF;

  SELECT COUNT(*) INTO v_cnt FROM card_tbl WHERE card_id = 1;
  IF v_cnt = 0 THEN
    RAISE_APPLICATION_ERROR(-20903, '더미 실패: card_tbl.card_id=1 이 필요합니다.');
  END IF;

  -- (3) 예약 존재 검증
  SELECT COUNT(*) INTO v_cnt FROM reservation_tbl WHERE resv_id IN (1,2);
  IF v_cnt < 2 THEN
    RAISE_APPLICATION_ERROR(-20904, '더미 실패: reservation_tbl.resv_id=1,2 가 모두 존재해야 합니다.');
  END IF;
END;
/
-- ✅ 전제 충족 시 이하 진행

-- 기존 동일 예약건 결제 삭제(있어도 무시) → 삭제로그 남고 FK NULL로 정리됨
BEGIN
  DELETE FROM payment_tbl WHERE resv_id IN (1,2);
  COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- (1) 계좌 결제 더미: hong1 / account_id=1 / card_id=NULL / resv_id=1
INSERT INTO payment_tbl(member_id, account_id, card_id, resv_id, payment_money, payment_method, payment_status)
VALUES('hong1', 1, NULL, 1, 50000, '계좌', '완료');

-- (2) 카드 결제 더미: hong2 / card_id=1 / account_id=NULL / resv_id=2
INSERT INTO payment_tbl(member_id, account_id, card_id, resv_id, payment_money, payment_method, payment_status)
VALUES('hong2', NULL, 1, 2, 80000, '카드', '완료');

COMMIT;  -- 더미 확정
-- ✅ 삽입과 동시에 paylog_tbl에 '결제' 로그 2건 자동 생성됨

--------------------------------------------------------------------------------
-- 5) 간단 확인 쿼리 (주석 해제 상태로 제공)
--------------------------------------------------------------------------------
-- 결제내역 확인
SELECT
    p.payment_id     AS "결제ID",
    p.member_id      AS "회원ID",
    p.account_id     AS "계좌ID",
    p.card_id        AS "카드ID",
    p.resv_id        AS "예약ID",
    p.payment_money  AS "결제금액",
    p.payment_method AS "결제방식",
    p.payment_status AS "결제상태",
    TO_CHAR(p.payment_date, 'YYYY-MM-DD HH24:MI') AS "결제일시"
FROM payment_tbl p
ORDER BY p.payment_id;

-- 결제로그 확인
SELECT
    l.paylog_id            AS "로그ID",
    l.payment_id           AS "결제ID(NULL=부모삭제됨)",
    l.paylog_type          AS "로그유형",
    l.paylog_before_status AS "이전상태",
    l.paylog_after_status  AS "이후상태",
    l.paylog_money         AS "금액",
    l.paylog_method        AS "방식",
    l.paylog_manager       AS "담당자",
    l.paylog_memo          AS "메모",
    TO_CHAR(l.paylog_date, 'YYYY-MM-DD HH24:MI') AS "로그일시"
FROM paylog_tbl l
ORDER BY l.paylog_id;

--------------------------------------------------------------------------------
-- 6) 💀 데이터 초기화(테스트 데이터/시퀀스만 재설정)  ※ 필요 시만 실행
--------------------------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'ALTER TRIGGER trg_payment_ins_upd_to_paylog DISABLE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'ALTER TRIGGER trg_payment_bdel_to_paylog DISABLE';   EXCEPTION WHEN OTHERS THEN NULL; END;
/
DELETE FROM paylog_tbl;   COMMIT;   -- 로그 전체 삭제
DELETE FROM payment_tbl;  COMMIT;   -- 결제 전체 삭제
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_paylog_id';  EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE SEQUENCE seq_paylog_id  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_payment_id'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE SEQUENCE seq_payment_id START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
/
BEGIN EXECUTE IMMEDIATE 'ALTER TRIGGER trg_payment_ins_upd_to_paylog ENABLE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'ALTER TRIGGER trg_payment_bdel_to_paylog ENABLE';   EXCEPTION WHEN OTHERS THEN NULL; END;
/
-- ✅ 테스트 데이터/시퀀스 초기화 완료

--------------------------------------------------------------------------------
-- 6-2) 💀 DDL까지 안전 삭제 (정말 전부 지울 때만 사용)  ← 기본 주석 유지 권장
--------------------------------------------------------------------------------
/*
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_bdel_to_paylog';          EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_ins_upd_to_paylog';       EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_paylog_id';                        EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_method_fk_chk';            EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_payment_id';                       EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE paylog_tbl CASCADE CONSTRAINTS';         EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE payment_tbl CASCADE CONSTRAINTS';        EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_paylog_id';                       EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_payment_id';                      EXCEPTION WHEN OTHERS THEN NULL; END;
/
*/
