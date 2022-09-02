*&---------------------------------------------------------------------*
*& Include ZRSA01_31_TOP                            - Report ZRSA01_31
*&---------------------------------------------------------------------*
REPORT ZRSA01_31.

"employ 변수 선언
DATA: gs_emp TYPE ZSSA0103,
      gt_emp like TABLE OF gs_emp.

"selection screen 관련 변수 선언
PARAMETERS: pa_ent_b LIKE gs_emp-entdt,
            pa_ent_e LIKE gs_emp-entdt.
