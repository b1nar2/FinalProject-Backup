-- 첨부 파일
CREATE TABLE file_tbl (
    file_id              NUMBER NOT NULL,
    file_target_type     VARCHAR2(20) NOT NULL,
    file_target_id       VARCHAR2(20) NOT NULL,
    file_name            VARCHAR2(200) NOT NULL,
    file_path            VARCHAR2(500) NOT NULL,
    file_type            VARCHAR2(50) DEFAULT '본문' NOT NULL,
    file_ext             VARCHAR2(20),
    file_size            NUMBER,
    file_reg_date        DATE DEFAULT sysdate  NOT NULL
);


-- PK 설정
ALTER TABLE file_tbl ADD CONSTRAINT pk_file_tbl PRIMARY KEY ( file_id );


-- 파일 사용 제약(체크)
ALTER TABLE file_tbl
ADD CONSTRAINT file_type_ch CHECK ( file_type IN ( '썸네일', '본문' ) );


-- 주석 설정
COMMENT ON TABLE  file_tbl                  IS '첨부 파일 테이블';
COMMENT ON COLUMN file_tbl.file_id          IS '파일 고유번호';
COMMENT ON COLUMN file_tbl.file_target_type IS '어느 테이블에 속한 파일인지(게시판, 콘텐츠, 시설 등등)';
COMMENT ON COLUMN file_tbl.file_target_id   IS '어느 게시물/시설의 파일인지 (PK/FK는 아님, 문자열 ID)';
COMMENT ON COLUMN file_tbl.file_name        IS '실제 업로드된 원본 파일명';
COMMENT ON COLUMN file_tbl.file_path        IS '서버 저장 경로 (URL 또는 물리경로)';
COMMENT ON COLUMN file_tbl.file_type        IS '파일 용도 (본문 이미지, 썸네일 등)';
COMMENT ON COLUMN file_tbl.file_ext         IS '파일 확장자';
COMMENT ON COLUMN file_tbl.file_size        IS '파일 크기 (byte 단위)';
COMMENT ON COLUMN file_tbl.file_reg_date    IS '파일 등록일';