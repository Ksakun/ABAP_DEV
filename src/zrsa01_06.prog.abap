*&---------------------------------------------------------------------*
*& Report ZRSA01_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA01_06.

PARAMETERS pa_i TYPE i.
"A,B,C,D만 입력가능
PARAMETERS pa_class TYPE c.
DATA gv_result LIKE pa_i.

*10보다 크면 출력
*20보다 크면 10을 추가로 더하세요
*A반이라면 입력한 값에 모두 100을 추가하세요
*IF pa_i BETWEEN 10 and 20.
*  WRITE pa_i.
*ELSEIF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*  CLEAR gv_result.
*ENDIF.
 IF pa_i > 20.
   gv_result = pa_i + 10.
   WRITE gv_result.
 ELSEIF pa_i > 10.
   gv_result = pa_i.
   WRITE gv_result.
 ELSE.
 ENDIF.

*CASE pa_clasee.
*	WHEN 'A'.
*    gv_result = pa_i + 100.
*	WHEN OTHERS.
*ENDCASE.
*IF pa_i > 20.
*  CLEAR gv_result.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*  CLEAR gv_result.
*ELSE.
*  IF pa_i > 10.
*    WRITE pa_i.
*  ENDIF.
*
*ENDIF.
