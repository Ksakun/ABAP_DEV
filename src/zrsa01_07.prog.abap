*&---------------------------------------------------------------------*
*& Report ZRSA01_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_07.
*
*1. 사용자에게 오늘 일자를 입력받는다.
*2. 입력한 날짜가 일주일 후라면 'ABAP Dictionary'를 출력한다.
*3. 입력한 날짜가 일주일 전이라면 'SAP UI5'를 출력
*4. 입력한 날짜가 1년 후라면 '취업'이라고 출력
*5. 입력한 날짜가 2022.06.20이면 '교육 준비중이라고 출력한다.
*6. 사용자에게 과정 코드를 입력받는다.
*6-1. 입력받은 값이 SYNC가 아니라면 다음 기회에 수강이라고 출력한다.

PARAMETERS pa_date TYPE sy-datum.
DATA:gv_today LIKE pa_date,
     gv_past  LIKE pa_date,
     gv_futr  LIKE pa_date.

gv_past = pa_date - 7.

gv_futr = pa_date + 7.


*IF .
*
*ELSEIF .
*
*ELSEIF .
*
*ELSE.
*  WRITE 'ABAP Workbench'.
*ENDIF.
