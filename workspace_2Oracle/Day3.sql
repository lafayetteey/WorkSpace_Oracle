--날짜 처리 함수
-- SYSDATE : 현재 컴퓨터의 날짜를 반환 하는 함수
SELECT SYSDATE FROM DUAL;

-- MONTHS_BETWEEN(날짜1, 날짜2) : 두 날짜 사이의 개월 수
SELECT HIRE_DATE 입사일,
	MONTHS_BETWEEN(SYSDATE, HIRE_DATE) "입사 후 개월 수"
FROM EMPLOYEE;

-- ADD_MONTHS(날짜, 개월 수)
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

-- EXTRACT(YEAR | MONTH | DAY  FROM 날짜데이터)
-- 지정한 날로 부터 날짜 값을 추출 하는 함수
SELECT EXTRACT( YEAR FROM HIRE_DATE ),
	EXTRACT( MONTH FROM HIRE_DATE ),
	EXTRACT( DAY FROM HIRE_DATE )
FROM EMPLOYEE;


--형변환 함수
-- DATE <--> CHAR <--> NUMBER
-- TO_DATE(), TO_CHAR(), TO_NUMBER()

--TO_CHAR()--
--날짜 정보 변경
SELECT HIRE_DATE,
	TO_CHAR(HIRE_DATE,'YYYY-MM-DD'),
	TO_CHAR(HIRE_DATE,'YY-MON-DD')
FROM EMPLOYEE;

--숫자 형식 변경
-- 9: 남은 빈 칸은 표시하지 않는다.
-- 0: 남은 빈 칸을 0으로 표시
-- L: 통화기호(원, 엔, 위안, 달러)
SELECT SALARY,
	TO_CHAR(SALARY, 'L999,999,999'),
	TO_CHAR(SALARY, '000,000,000'),
	TO_CHAR(SALARY, 'L999,999')
FROM EMPLOYEE;

--TO_DATE()--
SELECT 20200515,
	TO_DATE(20200515, 'yyyymmdd'),
	TO_DATE(20200515, 'YYYY/MM/DD')
FROM DUAL;

-- DECODE() --
-- JAVA에서 3항연산자
-- 조건 ? 참 : 거짓 

-- 현재 근무하는 직원들의 성별을 남, 여로 구분 짓기
SELECT EMP_NAME, EMP_NO,
	DECODE(SUBSTR(EMP_NO,8,1), '1', '남','여' ) 성별
FROM EMPLOYEE
ORDER BY 성별;


-- 실습 1
-- employee테이블에서
-- 모든 직원의 사번, 사원명, 부서코드, 직급코드, 근무여부, 관리자여부
-- 조회하되 만약 근무 여부가 'Y'퇴사자, 'N' 근무자,
-- 			관리자사번(MANAGER_ID) 있으면 '사원', 없으면 '관리자'
--로 작성하여 조회
SELECT EMP_ID 사번,
	EMP_NAME 사원명,
	DEPT_CODE 부서코드,
	JOB_CODE 직급코드,
	DECODE(ENT_YN, 'Y','퇴사자','근무자') "근무 여부",
	DECODE(NVL(MANAGER_ID,0), 0,'관리자','사원') "관리자 여부"
FROM EMPLOYEE;

-- Case 문
-- JAVA의 IF, SWITCH 처럼 사용할 수 있는 함수 표현식
-- CASE
--	WHEN (조건식1) THEN 결과값1
--	WHEN (조건식2) THEN 결과값2
--	ELSE 결과값 3
-- END
SELECT EMP_ID 사번,
	EMP_NAME 사원명,
	DEPT_CODE 부서코드,
	JOB_CODE 직급코드,
	CASE
		WHEN ENT_YN = 'Y' THEN '퇴사자'
		ELSE '근무자'
	END "근무 여부",
	CASE 
		WHEN MANAGER_ID IS NULL THEN '관리자'
		ELSE '사원'
	END "관리자 여부"
FROM EMPLOYEE;

-- NVL2(컬럼명|데이터, NULL이 아닐경우 값, NULL일 경우 값)
SELECT EMP_ID 사번,
	EMP_NAME 사원명,
	BONUS 보너스,
	NVL(TO_CHAR(BONUS),'X') "NVL함수",
	NVL2(BONUS, TO_CHAR(BONUS,'0.99'), 'X') "NVL2함수"
FROM EMPLOYEE;


--숫자 데이터 함수--
-- ABS() : 절대값 표현
SELECT ABS(10), ABS(-10)
FROM DUAL;

-- MOD() : 주어진 컬럼이나 값을 나눈 나머지를 반환하는 함수
SELECT MOD(10,3), MOD(10,2), MOD(10,7)
FROM DUAL;

-- ROUND() : 지정한 숫자를 반올림 하는 함수
SELECT ROUND(123.456, 0),
	ROUND(123.456, 1),
	ROUND(123.456, 2),
	ROUND(123.456, -2)
FROM DUAL;

--CEIL() : 소수점 첫째 자리에서 올림
--FLOOR() : 소수점 이하 자리를 버림
--TRUNC() : 지정한 위치까지 수자를 버림
SELECT CEIL(123.456),
	FLOOR(123.456),
	TRUNC(123.456,0),
	TRUNC(123.456,1),
	TRUNC(123.456,-2)
FROM DUAL;

-- 실습 2
-- EMPLOYEE 테이블에서   입사한 달의 숫자가 홀수 달인
-- 직원의 사번, 사원명, 입사일 정보를 조회
SELECT EMP_ID 사번,
	EMP_NAME 사원명,
	HIRE_DATE 입사일,
	HIRE_DATE
FROM EMPLOYEE  -- 10/11/15
WHERE MOD( SUBSTR(HIRE_DATE,5,1), 2 ) = 1;


-- 날짜 데이터
-- SYSDATE, MONTHS_BETWEEN, ADD_MONTHS,
-- EXTRACT, LAST_DAY, NEXT_DAY

-- SYSDATE, SYSTIMESTAMP
SELECT SYSDATE,
	SYSTIMESTAMP
FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS'),
	TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH:MI:SSFF' )
FROM DUAL;

--NEXT_DAY(날짜, 요일명)
-- 앞으로 다가올 가장 가까운 요일을 반환하는 함수
SELECT NEXT_DAY(SYSDATE, '토요일'),
	NEXT_DAY(SYSDATE, '토'),
	NEXT_DAY(SYSDATE, 7)	--1:일요일 ~ 7:토요일
	--NEXT_DAY(SYSDATE, 'SATURDAY')
FROM DUAL;

--데이터 사전(데이터 딕셔너리)
--현제 계정에설정된 정보를 DB의 테이블 형태로 보관하는 테이블
--기본적으로 시스템의 관리자만 변경 가능
--단, 사용자 계정도 접속한 동안은 변경 가능, 변경 후 재접속 하면 초기화
SELECT * FROM V$NLS_PARAMETERS;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;

--영문자 요일 조회
SELECT NEXT_DAY(SYSDATE, 'SATURDAY')
FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '토요일')
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- LAST_DAY() : 주어진 날짜의 마지막 일자를 조회
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

-- 날짜값끼리는 가장 최근 날짜일 수록 점점 더 큰값으로 판단
-- +,- 연산 가능
SELECT (SYSDATE - 10) "날짜1",
	TRUNC(SYSDATE - TO_DATE('20/03/01','RR/MM/DD')) "날짜2",
	TRUNC(TO_DATE('21/03/01','RR/MM/DD') - SYSDATE ) "날짜2"
FROM DUAL;


-- 실습 3
-- EMPLOYEE 테이블에서 
-- 근무 년수가 20년 이상인 사원들의 
-- 사번 사원명 부서코드 입사일을 조회하시오
SELECT EMP_ID 사번, EMP_NAME 사원명, 
	DEPT_CODE 부서코드, HIRE_DATE 입사일
FROM EMPLOYEE
WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE; 

--형변환
/*
 	YYYY 년도 표현(4자리)	YY 년도 표현(2자리)
 	MM	월을 숫자로
 	DAY 요일 표현 */
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS'),
	TO_CHAR(SYSDATE, 'MON DY, YYYY' ),
	TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY'),
	TO_CHAR(SYSDATE, 'YEAR, Q')
FROM DUAL;

-- Y/R
SELECT TO_CHAR(TO_DATE('200315','YYMMDD'),'YYYY') "결과1",
	TO_CHAR(TO_DATE('200315','RRMMDD'),'RRRR') "결과2",
	TO_CHAR(TO_DATE('800315','YYMMDD'),'YYYY') "결과3",
	TO_CHAR(TO_DATE('800315','RRMMDD'),'RRRR') "결과4"
FROM DUAL;

--4자리 한번에 입력 받을 경우 문제X
--2자리 입력 받을경우
--YY는 현 세기 기준
--RR은 반 세기 기준

--YY
-- 80 --> 2080
--RR
-- 51 ~ 99 --> 1900년대
-- 00 ~ 50 --> 2000년대

SELECT '123'+'456'
FROM dual;
SELECT '123'+'456ABC'
FROM DUAL;


--SELECT문의 실행 순서
/*
 	5: SELECT 컬럼명 AS 별칭, 계산, 함수식
 	1: FROM 테이블명
 	2: WHERE 조건
 	3: GROUP BY 그룹을 묶을 컬럼명
 	4: HAVING 그룹에 대한 조건식, 함수식
 	6: ORDER BY 컬럼|별칭|순서 
 */
-- ORDER BY --
SELECT EMP_ID, EMP_NAME 이름, SALARY, DEPT_CODE
FROM EMPLOYEE
--ORDER BY EMP_ID;	-- 정렬 기본값은 ASC
--ORDER BY EMP_NAME DESC;
ORDER BY DEPT_CODE, EMP_ID;

-- GROUP BY --
-- 부서별 평균
SELECT TRUNC(AVG(SALARY),-3)
FROM EMPLOYEE;
--D1 평균 급여
SELECT TRUNC(AVG(SALARY),-3)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';
SELECT TRUNC(AVG(SALARY),-3)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

-- GROUP BY 
--: 특정 컬럼, 계산식을 하나의 그룹으로 묶어
-- 한테이블 내에서 소그룹 별로 조회 하고자 할때 선언하는 구문
SELECT DEPT_CODE, TRUNC(AVG(SALARY),-3)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- 실습 4
-- EMPLOYEE 테이블에서 
-- 부서 별 총 인원, 급여 합계, 급여 평균, 최대 급여, 최소 급여를 
-- 조회 하여 부서코드 기준으로 오름차순 정렬하시오.
-- 단, 급여 평균 데이터는 100의 자리까지만 처리
SELECT DEPT_CODE,
	COUNT(*),
	SUM(SALARY),
	TRUNC(AVG(SALARY),-2),
	MAX(SALARY),
	MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

--직급 코드 별 보너스를 받는 사원의 수를 조회
SELECT JOB_CODE 직급코드, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE 
ORDER BY 1 DESC;

--실습5
-- EMPLOYEE 테이블에서 
-- 남성직원과 여성직원의 수를 조회하시오
-- GROUP BY 에서 주어진 컬럼 만이 아닌 함수식도 사용 가능
SELECT DECODE(SUBSTR(EMP_NO,8,1),1,'남성',2,'여성') 성별,
	COUNT(*) || '명' 직원수
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO,8,1),1,'남성',2,'여성');

-- HAVING 구문
-- GROUP BY 한 각 소그룹에 대한 조건을 설정 할때 
-- 그룹함수와 함꼐 사용 하는 구문
SELECT DEPT_CODE,
	AVG(SALARY) 평균
FROM EMPLOYEE
WHERE SALARY > 3000000
GROUP BY DEPT_CODE;

SELECT DEPT_CODE,
	AVG(SALARY) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) > 3000000
ORDER BY 1;

--실습 6
-- 부서별 그룹의 급여 합계 중 900만원을 초과 하는
-- 부서의 코드와 급여 합계를 조회
SELECT DEPT_CODE,
	SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 9000000;

-- 실습 7.
-- 급여 합계가 가장 높은 부서를 찾고,
-- 해당 부서의 부서 코드와 급여 합계를 조회하시오.
-- 1) 급여 합계가 가장 큰 부서의    급여합
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;	--17700000
-- 2) 급여 합계가 가장 높은 급여 합계와 같은 부서
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- SUB QUERY --
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = ( SELECT MAX(SUM(SALARY) )
					   FROM EMPLOYEE
					   GROUP BY DEPT_CODE);




--1. 직원명과 주민번호를 조회함
-- 단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움
-- 예: 홍길동 771120-1******


--2. 직원명, 직급코드, 연봉(원) 조회
-- 단, 연봉은 ￦57,000,000으로 표시되게 함
--  연봉은 보너스포인트가 적용된 1년치 급여임


--3. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의
-- 수 조회함.
-- 사번 사원명 부서코드 입사일


--4. 직원명, 입사일, 입사한 달의 근무일수 조회
-- 단, 주말도 포함함



--5. 직원명, 부서코드, 생년월일, 나이(만) 조회
-- 단, 생년월일은 주민번호에서 추출해서,
-- 00년 00월 00일로 출력되게 함.
-- 나이는 주민번호에서 추출해서 날짜 데이터로 변환한 다음, 계산함



--6. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
-- 아래의 년도에 입사한 인원수를 조회하시오.
-- =>TO_CHAR, DECODE, SUM 사용

-------------------------------------------------------------
--	전체직원수   2001년   2002년   2003년   2004년
---------------------------------------------------------------



--7.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회함
--  => case 사용
--   부서코드 기준 오름차순 정렬함.
--  => case 사용
--   부서코드 기준 오름차순 정렬함.

















