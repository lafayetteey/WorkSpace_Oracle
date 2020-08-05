DECLARE
	E EMPLOYEE%ROWTYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('ID   NAME   EMAIL');
	DBMS_OUTPUT.PUT_LINE('---------------------------');
	FOR I IN 0..10 LOOP
		SELECT * 
		INTO E
		FROM EMPLOYEE
		WHERE EMP_ID=200+I;
		DBMS_OUTPUT.PUT_LINE(E.EMP_ID||'   '||E.EMP_NAME||'   '||E.EMAIL);
	END LOOP;
END;
/


--WHILE--
--제어 조건이 TRUE 인 동안만 문장이 반복 실행됨

--[사용형식]
-- WHILE 반복할조건식 LOOP
--	반복할 스크립트 내용
-- END LOOP;
DECLARE
	N INT := 5;
BEGIN
	WHILE N > 0 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
		N:= N-1;
	END LOOP;
END;
/

--WHILE을 이용하여 구구단 5단을 출력

DECLARE
	DAN NUMBER := 5;
	N NUMBER := 2;
BEGIN
	WHILE N<=9 LOOP
		DBMS_OUTPUT.PUT_LINE(DAN||' * '||N||' = ' || DAN*N);
		N := N+1;
	END LOOP;
END;
/

--PL/SQL 객체--
--프로시저, 트리거, 함수 
--프로시저: PL/SQL을 미리 저장해 놓았다가 프로시저를 호출하여 함수처럼 동작시키는 객체

--[사용형식]
--CREATE [OR REPLACE] PROCEDURE 프로시저명 (매개변수1 [IN/OUT/IN OUT] 자료형[, 매개변수 2 자료형 ])
--							IN: 프로시져에서 사용할 변수 값을 외부에서 받아 올때 사용하는 모드
--							OUT: 프로시져를 실행한 결과를 외부로 추출 할때 사용하는 모드
--							IN OUT: 두가지 기능을 선택해서 사용 할수 있는 모드
--IS	-> DECLARE(선언부) 
--	변수선언;
--BEGIN
--	실행할 코드;
--END;
--/

--[호출방식]
-- EXECUTE 프로시저명[(전달값1, 전달값2, ...)];
-- EXEC      ''           ''              
--[삭제]
--DROP PROCEDURE 프로시저명;

CREATE TABLE EMP_TMP
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_TMP;
SELECT COUNT(*) FROM EMP_TMP;

--프로시저생성
CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS -- 변수선언
BEGIN 
		DELETE FROM EMP_TMP;
		COMMIT;
END;
/

SELECT COUNT(*) FROM EMP_TMP;

--프로시저 실행
EXEC DEL_ALL_EMP;

DROP TABLE EMP_TMP;



-- 매개변수를 갖는 프로시저
-- IN -- IN모드는 외부의 값을 내부로 전달하는 방식
CREATE TABLE EMP_TMP_01
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_TMP_01 ;

--프로시저 생성
CREATE OR REPLACE PROCEDURE DEL_EMP_NAME(V_NAME IN EMP_TMP_01.EMP_NAME%TYPE)
IS
BEGIN 
	DELETE FROM EMP_TMP_01 
	WHERE EMP_NAME LIKE V_NAME;
	DBMS_OUTPUT.PUT_LINE(V_NAME || ' 직원 정보가 삭제되었습니당.');
	COMMIT;
END;
/
--실행
EXEC DEL_EMP_NAME('이준혁');

-- 성이 이씨인 사람들을 모두 삭제
EXEC DEL_EMP_NAME('이%');



--OUT -- 내부의값을 외부로 전달 하는 방식
--  외부에서도 값을 받을 수 있게 VARIABLE 객체를 생성


-- 내부의 값을 전달 받을 변수 선언
-- VARIABLE 변수명 자료형(크기);

-- EXEC 프로시저(전달값, :전달받을변수명);


CREATE OR REPLACE PROCEDURE 
	EMP_INFO(VEMP_ID IN EMPLOYEE.EMP_ID%TYPE,
			 VEMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
			 VPHONE OUT EMPLOYEE.PHONE%TYPE )
IS 
BEGIN 
	SELECT EMP_NAME, PHONE
	INTO VEMP_NAME, VPHONE
	FROM EMPLOYEE
	WHERE EMP_ID = VEMP_ID;
END;
/

--OUT되는 데이터를 담을 변수 선언
VARIABLE VAR_ENAME VARCHAR2(30);
VARIABLE VAR_PHONE VARCHAR2(30);

--PRINT 
PRINT VAR_ENAME;

--프로시저실행 
EXEC EMP_INFO(201, :VAR_ENAME, :VAR_PHONE);

PRINT VAR_ENAME;
PRINT VAR_PHONE;

-- FUNCTION --
-- 내부에서 계산된 결과를 반환하는 객체
-- MAX, MIN, SUM, AVG ... 
-- 프로시저와 흡사.

--함수: 리턴값 존재. 목적은 결과를 도출해 내는것
--프로시저: 리턴값 없다. 수행하는 절차 그 자체를 목적


/*
 	[사용형식]
 	CREATE [OR REPLACE] FUNCTION 함수명(매개변수 [모드] 자료형)
 	RETURN 자료형;   -- 반환할 결과의 자료형
 	IS
 	BEGIN
 	RETURN 결과데이터;
 	END;
 	/ 
 */

CREATE OR REPLACE FUNCTION BONUS_CALC(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
   V_SAL EMPLOYEE.SALARY%TYPE;
   V_BONUS EMPLOYEE.BONUS%TYPE;
   RESULT NUMBER;
BEGIN
   SELECT SALARY, NVL(BONUS, 0)
   INTO V_SAL, V_BONUS
   FROM EMPLOYEE
   WHERE EMP_ID = V_EMP_ID;
   RESULT := V_SAL * V_BONUS;
   RETURN RESULT;
END;
/

VAR RESULT_SAL NUMBER;
EXEC :RESULT_SAL := BONUS_CALC('200');



--TRIGGER--
-- 특정 테이블이나 뷰가 DML을 통해 데이터 변환이 일어날때 
-- 그시점을 감지하여 자동으로 동작하는 스크립트
-- 사용자가 DML을 수행하는 것이 아니라 데이터 베이스에서 
-- 자동으로 처리하는 로직을 구현하는 객체

--제품관리 시스템
--제품 정보 테이블
CREATE TABLE PRODUCT(
	PCODE NUMBER PRIMARY KEY,
	PNAME VARCHAR2(30),
	BRAND VARCHAR2(30),
	PRICE NUMBER,
	STOCK NUMBER DEFAULT 0
);
-- 입출고 내역 테이블
CREATE TABLE PRODUCT_DETAIL(
	DCODE NUMBER PRIMARY KEY,
	PCODE NUMBER NOT NULL,
	PDATE DATE DEFAULT SYSDATE,
	AMOUNT NUMBER,
	STATUS CHAR(6) CHECK( STATUS IN ('입고','출고')),
	CONSTRAINT FK_PRODUCT FOREIGN KEY(PCODE) REFERENCES PRODUCT
);
SELECT * FROM PRODUCT;
SELECT * FROM PRODUCT_DETAIL;

CREATE SEQUENCE SEQ_PRODUCT;
CREATE SEQUENCE SEQ_DETAIL;
--제품 등록--
--INSERT INTO PRODUCT VALUES(SEQ_PRODUCT.NEXTVAL, '제품명', '브랜드', 가격, DEFAULT);
INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT.NEXTVAL, '노트북','APPLE',3000000,DEFAULT);

INSERT INTO PRODUCT 
VALUES(SEQ_PRODUCT.NEXTVAL, 'TV','LG',1000000,DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT.NEXTVAL, '핸드폰', 'SAMSUNG', 1200000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PRODUCT.NEXTVAL, '볼펜','모나미',50000,DEFAULT);
COMMIT;

SELECT * FROM PRODUCT;

--제품 입.출고 관련 재고 증감 트리거
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON PRODUCT_DETAIL
FOR EACH ROW 
BEGIN 
	IF :NEW.STATUS='입고'
	THEN 
		UPDATE PRODUCT
		SET STOCK = STOCK + :NEW.AMOUNT
		WHERE PCODE = :NEW.PCODE;
	END IF;
	IF :NEW.STATUS='출고'
	THEN
		UPDATE PRODUCT
		SET STOCK = STOCK - :NEW.AMOUNT
		WHERE PCODE = :NEW.PCODE;
	END IF;
END;
/


COMMIT;

INSERT INTO PRODUCT_DETAIL 
VALUES(SEQ_DETAIL.NEXTVAL, 1, SYSDATE, 3, '입고');

INSERT INTO PRODUCT_DETAIL 
VALUES(SEQ_DETAIL.NEXTVAL, 3, SYSDATE, 10, '입고');

INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 3, SYSDATE, 5, '출고');

SELECT * FROM PRODUCT_DETAIL;
SELECT * FROM PRODUCT;

COMMIT;






