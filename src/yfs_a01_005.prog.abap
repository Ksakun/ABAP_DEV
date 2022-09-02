*&---------------------------------------------------------------------*
*& Report YTEST0002_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfs_a01_005.


TYPES : BEGIN OF t_str.
TYPES : col1 TYPE char15,
        col2 TYPE char15.
TYPES : END OF t_str.

DATA : dref1 TYPE REF TO data,
       dref2 TYPE REF TO data.

FIELD-SYMBOLS : <fs1> TYPE t_str,
                <fs2> TYPE char15.


CREATE DATA dref1 TYPE t_str.    "참조 변수 생성.  type 정보가지게 됨.

ASSIGN dref1->* TO  <fs1>.   " 실제 구조와 정보를 assign.(역참조)


<fs1>-col1 = 'Test data ref :'.
<fs1>-col2 = 'field symbol'.


dref2 = dref1.

ASSIGN dref2->* TO <fs2> CASTING.
WRITE : / <fs2>.


GET REFERENCE OF <fs1>-col2 INTO dref2.

ASSIGN dref2->* TO <fs2>.
WRITE : / <fs2>.
