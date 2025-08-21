-- 회원 정보 테이블
CREATE TABLE member_tbl (
    member_id           VARCHAR2(20)  NOT NULL,
    member_pw           VARCHAR2(300) NOT NULL, -- 비밀번호 암호화를 고려해 300자 이상으로 설정
    member_name         VARCHAR2(100) NOT NULL,
    member_gender       CHAR(1)       NOT NULL,
    member_email        VARCHAR2(100) NOT NULL, -- 메일주소 100자 이상 권장
    member_mobile       VARCHAR2(13)  NOT NULL,
    member_phone        VARCHAR2(13),
    zip                 CHAR(5),
    road_address        NVARCHAR2(200), -- 주소는 최소 100자 이상 권장
    jibun_address       NVARCHAR2(200),
    detail_address      NVARCHAR2(200),
    member_birthday     DATE,
    member_joindate     DATE         DEFAULT SYSDATE NOT NULL, 
    member_role         VARCHAR2(10) DEFAULT 'user',
    admin_type          VARCHAR2(20) -- DEFAULT '관리자' 제거 : usre일 때 admin_type null값을 설정하기 위함
);

-- PK 설정
ALTER TABLE member_tbl ADD CONSTRAINT pk_member_tbl PRIMARY KEY ( member_id );

--  이메일 중복 방지 
ALTER TABLE member_tbl ADD CONSTRAINT un_member_email UNIQUE ( member_email );

--  휴대폰 중복 방지
ALTER TABLE member_tbl ADD CONSTRAINT un_member_mobile UNIQUE ( member_mobile );

-- 성별 제약(체크)
ALTER TABLE member_tbl
ADD CONSTRAINT chk_member_gender
CHECK(member_gender IN ('m', 'f'));

-- 일반유저/관리자 설정(체크)
ALTER TABLE member_tbl
ADD CONSTRAINT chk_member_role
CHECK(member_role IN ('user', 'admin'));

-- 관리자 권한 유형 설정(체크)
ALTER TABLE member_tbl
ADD CONSTRAINT chk_member_admin_type
CHECK(
    (member_role = 'admin' AND admin_type IN ('책임자', '관리자', '강사'))
 OR (member_role = 'user' AND admin_type IS NULL) -- user 관리자 권한 부여 제어
);

-- 주석 설정
COMMENT ON TABLE member_tbl                    IS '회원 정보 테이블';
COMMENT ON COLUMN member_tbl.member_id          IS '회원 ID';
COMMENT ON COLUMN member_tbl.member_pw          IS '회원 비번';
COMMENT ON COLUMN member_tbl.member_name        IS '사용자명';
COMMENT ON COLUMN member_tbl.member_gender      IS '성별';
COMMENT ON COLUMN member_tbl.member_email       IS '이메일';
COMMENT ON COLUMN member_tbl.member_mobile      IS '휴대폰 번호';
COMMENT ON COLUMN member_tbl.member_phone       IS '일반 번호';
COMMENT ON COLUMN member_tbl.zip                IS '우편번호';
COMMENT ON COLUMN member_tbl.road_address       IS '도로명 주소';
COMMENT ON COLUMN member_tbl.jibun_address      IS '지번 주소';
COMMENT ON COLUMN member_tbl.detail_address     IS '상세 주소';
COMMENT ON COLUMN member_tbl.member_birthday    IS '생년월일';
COMMENT ON COLUMN member_tbl.member_joindate    IS '가입일';
COMMENT ON COLUMN member_tbl.member_role        IS '권한';
COMMENT ON COLUMN member_tbl.admin_type         IS '관리자 유형 : 책임자, 관리자, 강사';