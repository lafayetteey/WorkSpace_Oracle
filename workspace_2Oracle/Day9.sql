-- 인덱스 --
-- SQL 명령어 조회 처리 속도를 향상시키기 위한 객체

-- 장점 : 검색속도가 향상
-- 단점 : 인덱스가 존재하는 테이블의 내용이 자주 변경되는 테이블이라면
--		 인덱스를 매번 다시 계산하여 만들어야 하기 때문에 오히려 성능이 저하 될 수 있다.
--	         인덱스를 저장하기 위한 별도의 공간을 할당


-- 인덱스 생성 방법
-- CREATE [UNIQUE] INDEX 인덱스명
-- ON 테이블명(컬럼[, 컬럼명 | 함수식 ])

-- 인덱스를 관리하는 데이터 사전
SELECT * FROM USER_IND_COLUMNS;


SELECT ROWID, EMP_ID, EMP_NAME
FROM EMPLOYEE;

--ROWID
-- 테이블 생성 및 데이터 추가시에 오라클에서 해당 객체를 관리하기 위한
-- 데이터의 순번, 시스템에서 직접 관리하기 때문에 사용자가 함부로 변경 불가

-- 인덱스의 종류
-- 1. 고유인덱스(UNIQUE INDEX)
-- 2. 비고유인덱스(NOUNIQUE INDEX)
-- 3. 단일인덱스(SINGLE INDEX)
-- 4. 결합인덱스(COMPOSITE INDEX)
-- 5. 함수기반 인덱스(FUNCTION BASE INDEX)

-- 고유인덱스 --
-- 인덱스 생성 시 고유값을 기준으로 생성하는 인덱스
-- PRIMARY KEY 제약조건을 사용하면 자동으로 생성하는 인덱스

--ORA-01408: such column list already indexed
CREATE UNIQUE INDEX IDX_EMP_NO
ON EMPLOYEE(EMP_NO);

SELECT * FROM USER_IND_COLUMNS 
WHERE TABLE_NAME='EMPLOYEE';


--ORA-01452: cannot CREATE UNIQUE INDEX; duplicate keys found
-- 컬럼의 값이 중복값 존재할 경우 UNIQUE INDEX 생성할 수 없다.
CREATE UNIQUE INDEX IDX_DEPT_CODE
ON EMPLOYEE(DEPT_CODE);


-- NON-UNIQUE INDEX
-- 내가 자주 사용하는 컬럼을 인덱스로 구성하여 검색 속도를 향상 시키기 위한 인덱스
CREATE INDEX IDX_DEPT_CODE
ON EMPLOYEE(DEPT_CODE);

SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D6';

SELECT * FROM USER_IND_COLUMNS 
WHERE TABLE_NAME = 'EMPLOYEE';


-- 결합 인덱스 --
-- 여러 컬럼을 하나로 묶기 위한 인덱스
CREATE INDEX IDX_DEPT
ON DEPARTMENT(DEPT_ID, DEPT_TITLE);

SELECT * FROM DEPARTMENT;

SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT
WHERE DEPT_ID != 'D1'
	AND DEPT_TITLE != '기술지원부';

DROP INDEX IDX_DEPT;


-- 함수 기반 인덱스
-- 조회 시 자주 사용하는 함수식이 있다면 해당 함수식을
-- 인덱스 생성시 반영하여 검색을 향상 하는 인덱스


SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ( (SALARY*NVL(BONUS,0)+SALARY) *12 ) > 10000000;

CREATE INDEX IDX_EMP_SAL_CAL
ON EMPLOYEE( (SALARY*NVL(BONUS,0)+SALARY) *12 );


-- 인덱스 새로고침
ALTER INDEX IDX_DEPT REBUILD;

--인덱스 삭제
DROP INDEX IDX_DEPT;




--
-- 1. SYS / 최상위 관리자
-- 2. SYSTEM / 일반 관리자
-- 3. SCOTT / 교육용 샘플계정
-- 4. HR / 교육용 샘플계정 



--PL/SQL 전 총 정리--
--ORACLE--
--DBMS
--데이터를 효율적으로 관리하기 위한 시스템

-- DDL: 데이터 정의어
-- CREATE, ALTER, DROP 

-- DMBS 객체: USER, TABLE, VIEW, INDEX, SEQUENCE


-- DML : 데이터 조작어
-- CRUD
-- CREATE : INSERT
-- READ : SELECT 
-- UPDATE : UPDATE
-- DELETE : DELETE

--SELECT--
--5.SELECT
--1.FROM
--2.WHERE
--3.GROUP BY
--4.HAVING
--6.ORDER BY

-- SET OPERATOR, JOIN
--SET OPERATOR
-- UNION, UNION ALL, MINUS, INTERSECT

--JOIN
-- INNER JOIN : 두개 이상의 테이블에서 같은 값끼리 묶어서 결과 셋을 만드는 조인 방식
-- OUTER JOIN : 서로 다른 값도 포함하기 위해 사용
--      LEFT, RIGHT, FULL 

--TABLE
-- 저장된 데이터를 표의 형태로 표현하여 관리하는 DB객체
--VIEW 
-- 조회한 SELECT 쿼리를 저장, 필요시 가져다 사용할수 있는 가상 테이블
--SEQUENCE 
--  1, 2, 3, 4, 5 .. 등의 순서를 자동으로 증감시켜 숫자데이터를 얻을 수 있는 DB 객체
-- INDEX
-- 테이블에서 특정 데이터를 검색 할 때, 효율적이고 빠르게 검색하기 위한 객체



















