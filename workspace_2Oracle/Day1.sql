-- 한줄 주석
/* 여러줄 주석 */
-- ';' 문장의 끝

-- SELECT 문 : 조회용 SQL
-- [형식] 
-- SELECT 컬럼명		: 조회하고자 하는 내용
-- FROM 테이블명		: 조회하고자 하는 테이블 명
-- [WHERE 조건]		: 특정 조건
-- [ORDER BY 컬럼]	: 정렬
-- ;

-- 모든 행과 모든 컬럼 조회
SELECT * FROM EMPLOYEE;

-- 사원의 ID와 사원명, 연락처 조회
SELECT EMP_ID, EMP_NAME, PHONE 
FROM EMPLOYEE;

-- 사원의 아이디, 사원명, 이메일, 연락처, 부서번호, 직급코드를 조회
SELECT EMP_ID, EMP_NAME, EMAIL, PHONE, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;


-- WHERE 절
-- 테이블에서 조건을 만족하는 값을 가지는 행을 따로 선택하여
-- 조회하는 조건절
-- 여러 개의 조건을 선택하고자 할 경우    AND , OR 명령어를 함께 사용

-- 부서 코드가 D6인 사원 정보를 모두 조회하기
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';
--EMPLOYEE 테이블에서 DEPT_CODE가 D6인 사원의 모든 컬럼을 조회하겠다.

-- 문제 1.
-- 직급이(JOB_CODE) 'J1'인 사원의 
-- 사번, 사원명, 직급코드, 부서코드 를 조회하시오.
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE 
WHERE JOB_CODE = 'J1';

-- 문제2.
-- 급여가(SALARY) 300만원 이상인 사원의
-- 아이디, 사원명, 직급코드, 급여를 조회하시오.
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;
















