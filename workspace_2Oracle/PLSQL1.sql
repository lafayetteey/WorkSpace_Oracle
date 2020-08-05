-- PL/SQL --
--(PROCEDURAL LANGUAGE EXTENSION TO SQL)

--기능 : 변수선언, 비교 처리, 반복 처리


--PL/SQL의 구조
--선언부, 실행부, 예외처리부
-- 선언부 : DECLARE, 변수 선언 하는 부분
-- 실행부 : BEGIN,  제어문/반복문 등을 작성 하는 부분
-- 예외처리부 : EXCEPTION, 예외 발생시 처리 하는 내용 작성 하는 부분

-- 실행부를 사용해서 간단한 문장 출력
BEGIN
	DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
	DBMS_OUTPUT.PUT_LINE('I LIKE DBEAVER');
	--DBMS_OUTPUT패키지의 PUT_LINE 이라는 프로시저를 이용하여 호출
END;
/

--화면에 보이도록 설정
SET SERVEROUTPUT ON;


--변수 선언과 초기화, 출력
--[1] 일반 변수
DECLARE
	vid NUMBER;
BEGIN
	SELECT EMP_ID
	INTO vid		--변수에 조회한 값을 담음
	FROM EMPLOYEE
	WHERE EMP_NAME = '선동알';
	DBMS_OUTPUT.PUT_LINE('ID='||vid);
EXCEPTION
	WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No Data!!!!!!');
END;
/


DECLARE
	v_empno NUMBER(4);
	v_empname VARCHAR2(10);
	test_num NUMBER(5) := 10*20;
BEGIN
	v_empno := 1001;
	v_empname := '이대희';
	DBMS_OUTPUT.PUT_LINE(v_empno||'   '||v_empname||'   '||test_num);
END;
/

--[2] 레퍼런스 변수
--  (1)%TYPE : 한 컬럼의 자료형을 받아 올때 사용하는 자료형 타입
DECLARE
	EMP_ID EMPLOYEE.EMP_ID%TYPE;
	EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
	SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
	SELECT EMP_ID, EMP_NAME, SALARY
	INTO EMP_ID, EMP_NAME, SALARY
	FROM EMPLOYEE
	WHERE EMP_NAME = '송종기';
	DBMS_OUTPUT.PUT_LINE(EMP_ID||'   '||EMP_NAME||'   '||SALARY);
END;
/
-- (2) %ROWTYPE : 한 테이블의 모든 컬럼의 자료형을 참조할 때 사용하는 타입
DECLARE
	myrow EMPLOYEE%ROWTYPE;
BEGIN
	SELECT EMP_ID, EMP_NAME
	INTO myrow.emp_id, myrow.emp_name
	FROM EMPLOYEE
	WHERE EMP_NAME='선동일';
	DBMS_OUTPUT.PUT_LINE(myrow.emp_id||','||myrow.emp_name);
END;
/

-- IF 문 --
-- IF ~ THEN ~ END IF 문
/*
 * IF 조건 THEN 조건을 만족할 경우처리 구문;
 * END IF;
 */
BEGIN
	IF '이창진'='이창진' THEN
		DBMS_OUTPUT.PUT_LINE('이창진이냐?');
	END IF;
END;
/

--2. IF ~ THEN ~ ELSE ~ END IF

BEGIN
	IF '이창진'='이창진1' THEN
		DBMS_OUTPUT.PUT_LINE('이창진이네?');
	ELSE DBMS_OUTPUT.PUT_LINE('아니네....');
	END IF;
END;
/


--3. IF ~ THEN ~ ELSIF ~ ELSE ~ END IF;
/*
 * IF 조건1 THEN 
 * 		실행1;
 * ELSIF 조건2 THEN 
 * 		실행2;
 * ELSE
 * 		모든 조건 만족하지 않을때;
 * END IF;
 */

DECLARE 
	NAME VARCHAR2(30) :='이창진';
BEGIN
	IF NAME = '이창진' THEN DBMS_OUTPUT.PUT_LINE('이창진이네....');
	ELSIF NAME = '장동건' THEN DBMS_OUTPUT.PUT_LINE('장동건이구만....');
	ELSE DBMS_OUTPUT.PUT_LINE('누구여...?');
	END IF;
END;
/

--4. CASE 문
-- CASE ~ END CASE;
/*
 * CASE
 * 		WHEN 표현식1 THEN
 * 				실행문1;
 * 		WHEN 표현식2 THEN
 * 				실행문2;
 * 		ELSE 기본실행문3;
 * END CASE;
 */

DECLARE
	NUM NUMBER(10) := 3;
BEGIN
	CASE NUM
		WHEN 1 THEN
			DBMS_OUTPUT.PUT_LINE(NUM||' 입니다.');
		WHEN 2 THEN
			DBMS_OUTPUT.PUT_LINE(NUM||' 입니다아');
		WHEN 3 THEN
			DBMS_OUTPUT.PUT_LINE(NUM||' 일껄요?');
		ELSE
			DBMS_OUTPUT.PUT_LINE('으잉?');
	END CASE;
END;
/

SELECT * FROM EMPLOYEE;

--사원번호를 통해 조회한 직원의 직급코드로 대표,임원진, 일반직원을 구분하는 예제를 CASE로 구현
DECLARE
	JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
	EMP_TEAM VARCHAR2(15);
BEGIN
	SELECT JOB_CODE
	INTO JOB_CODE 
	FROM EMPLOYEE
	WHERE EMP_ID='211';
	CASE JOB_CODE
		WHEN 'J1' THEN EMP_TEAM := '대표';
		WHEN 'J2' THEN EMP_TEAM := '임원진';
		ELSE EMP_TEAM := '일반직원';
	END CASE;
	DBMS_OUTPUT.PUT_LINE('소속: '||EMP_TEAM);
END;
/


--PL/SQL 반복문
-- LOOP --
DECLARE
  E EMPLOYEE%ROWTYPE;
BEGIN
  SELECT *
  INTO E
  FROM EMPLOYEE;
  DBMS_OUTPUT.PUT_LINE(E.EMP_ID);
END;
/

-- LOOP, FOR, WHILE

-- 일반 LOOP문
/*
 	LOOP
 		반복시킬내용
 		IF 반복 종료 조건
 			EXIT;
 		END IF;
 		또는
 		EXIT [WHEN 종료 조건]
 	END LOOP;
 */
DECLARE 
	N INT := 5;
BEGIN
	LOOP
		DBMS_OUTPUT.PUT_LINE(N);
		N := N-1;
		EXIT WHEN N=0;
	END LOOP;
END;
/

-- FOR 반복문 --
-- 카운트용 변수는 자동 선언, 카운트 값은 자동으로 1씩 증가, REVERSE 1씩 감소
/*
 * FOR 카운트변수 IN [REVERSE] 시작값..종료값 LOOP
 * 	반복할 내용;
 * END LOOP;
 */

BEGIN
	FOR N IN 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;
/

--FOR문을 반대로 실행
BEGIN
	FOR N IN REVERSE 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;
/


-- FOR문을 통한 INSERT 사용










