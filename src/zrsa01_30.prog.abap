*&---------------------------------------------------------------------*
*& Report ZRSA01_30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_30.


*DATA gv_name TYPE zdname_a01. "도메인은 프로그램에서 사용할 수 없다.

*PARAMETERS pa_name TYPE zename_a01.

*TYPES: BEGIN OF ts_info,
*         stdno TYPE n LENGTH 8,
*         sname TYPE c LENGTH 40,
*       END OF ts_info.

DATA gs_std TYPE zssa0101. "글로벌타입을 만들어보자 "Student Info 선언한 Global Structure 타입을 사용하기

gs_std-stdno = '20220001'.
gs_std-sname = 'Kang JG'.
