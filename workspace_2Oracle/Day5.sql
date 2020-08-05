-- SET OPERATOR --
-- 합집합
-- UNION : 중복되는 부분을 제거하여 합친다.
-- UNION ALL : UNION 과 동일하나 중복되는 결과를 그대로 보여준다.
-- 교집합
-- INTERSECT : 곂치는 결과만 조회
-- 차집합
-- MINUS : 두 개 이상의 테이블 정보 중 제일 앞에 선언된 결과를 기준으로 
--		      중복을 제외한 앞테이블의 결과만을 조회

-- JOIN --
-- JOIN : 두개 이상의 테이블의 결과를 하나의 테이블 형태로 합쳐서 사용하는 방법
-- INNER JOIN : 합치려는 테이블의 데이터를 각각이 모두 일치하는 정보만 연결지어 조회
-- OUTER JOIN : 
--		LEFT: 좌측 테이블의 정보를 모두 포함 
--		RIGHT: 우측  ''	''		''
--		FULL: 양측 '' 	''		''

-- CROSS JOIN , SELF JOIN, 다중 JOIN 

-- SUB QUERY  : 메인쿼리안에 또 하나의 쿼리를 추가


-- 인라인뷰 
-- FROM 위치에 사용되는 서브쿼리
-- 서브쿼리의 RESULT SET을 활용하여 데이터를 조회할 때 사용 할수 있다.
-- 이때 기존의 테이블을 대체한다는 의미에서
-- FROM 구문의 서브쿼리를 Inline View 라고 부른다.\

SELECT *
FROM (	SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
		FROM EMPLOYEE
		JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
		JOIN JOB USING(JOB_CODE) );

-- TOP-N 분석 조회
-- 맛있는 음식 상위 5개
-- 가장 많이 팔린 아이스크림 6개
-- 가장 조건에 부합하는 내용을 순위화 하여 특정 순번까지 조회하는 방식

-- ROWNUM : 데이터를 조회할때 각 행의 번호를 매겨주는 함수
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM < 6;

-- 연습
-- 급여기준으로 가장 높은 급여를 받는 사원 
-- 상위 5명 조회하여    사번, 사원명, 급여를 출력
SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

SELECT ROWNUM, A.*
FROM (SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
	  FROM EMPLOYEE
	  ORDER BY SALARY DESC) A
WHERE ROWNUM < 6;


-- RANK() : 순위를 매기는 함수  <==>  DENSE_RANK() : 순위를 매기는 함수
--1								1
--2								2
--2								2
--4								3

SELECT EMP_NAME, SALARY,
	RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;

SELECT *
FROM (SELECT EMP_NAME, SALARY,
	  RANK() OVER(ORDER BY SALARY DESC) "순위"
      FROM EMPLOYEE)
WHERE 순위 <4;

SELECT EMP_NAME, SALARY,
	DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

--실습 5.
-- EMPLOYEE 테이블에서
-- 보너스를 포함한 연봉이 가장 높은 사원 상위 5명을
-- RANK() 함수를 활용하여 조회
-- 사번, 사원명, 부서명, 직급명, 입사일, 연봉( 보너스포함 )

--직원들의 연봉 계산
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE,
	( SALARY+ (SALARY)*(NVL(BONUS,0)+1) )*12 연봉,
	RANK() OVER( ORDER BY (SALARY+ (SALARY)*(NVL(BONUS,0)+1) )*12 DESC ) 순위
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);

SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE,
		( SALARY+ (SALARY)*(NVL(BONUS,0)) )*12 연봉,
		RANK() OVER( ORDER BY (SALARY+ (SALARY)*(NVL(BONUS,0)+1) )*12 DESC ) 순위
	  FROM EMPLOYEE
	  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	  JOIN JOB USING(JOB_CODE))
WHERE 순위 < 6;




-- WITH AS 구문
-- 동일한 서브쿼리를 중복해서 사용할때 이를 별칭화 하여 사용하도록 하는 구문
-- 사용형식: WITH 별칭 AS ( 서브쿼리 )
-- **인라인 뷰에서만 가능
WITH TOP_N_SAL AS (
		SELECT EMP_NAME, SALARY
		FROM EMPLOYEE
		ORDER BY SALARY DESC
) SELECT * 
  FROM TOP_N_SAL;

-- 부서 별 급여 합계가 전체 부서 급여 총합의
-- 20%보다 많은 부서의 부서명과, 부서급여 합계를 조회
--1) 일반 단일행 서브쿼리
-- 전체 부서의 급여 합계의 20%조회
SELECT SUM(SALARY)*0.2
FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);


-- 2) 인라인 뷰 활용하여 해결
-- 서브쿼리
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--인라인 뷰
SELECT DEPT_CODE, SUMSAL
FROM (
		SELECT DEPT_CODE, SUM(SALARY) SUMSAL
		FROM EMPLOYEE
		GROUP BY DEPT_CODE
	 )
WHERE SUMSAL > (SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);

-- 3) WITH AS를 이용
WITH SUM_SAL_VIEW 
AS (
	SELECT DEPT_CODE, SUM(SALARY) SUMSAL
	FROM EMPLOYEE
	GROUP BY DEPT_CODE
) SELECT * 
  FROM SUM_SAL_VIEW
  WHERE SUMSAL > ( SELECT SUM(SALARY)*0.2 FROM EMPLOYEE);

-- WITH AS 여러개 등록하여 사용
WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
	 AVG_SAL AS (SELECT AVG(SALARY) FROM EMPLOYEE)
SELECT * FROM SUM_SAL
UNION ALL
SELECT * FROM AVG_SAL
UNION ALL
SELECT * FROM SUM_SAL;


 -- 상호 연관 쿼리 : 상관 쿼리
 -- 일반적으로 서브쿼리는 서브쿼리, 메인쿼리는 서브쿼리의 
 -- 결과만 받아서 실행하는 방식과 다르게
 -- 메인 쿼리가 사용하는 컬럼값, 계산식 등을 서브쿼리에 적용하여
 -- 서브쿼리 실행 시 메인 쿼리의 값도 함께 사용 하는 방식
 

 


















