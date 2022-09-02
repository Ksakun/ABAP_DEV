*&---------------------------------------------------------------------*
*& Report ZRSA01_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA01_37.

DATA: gs_info TYPE ZVSA0102,
      gt_info LIKE TABLE OF gs_info.

PARAMETERS pa_dep LIKE gs_info-edept.

START-OF-SELECTION.

*SELECT *
*  FROM zvsa0102 "database view
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*  WHERE edept = pa_dep.
* subroutine을 쓸 때 pa_dep -> using value
*  change gt_info -> call by ref로 받아야한다.
*  무튼간 subroutine 연습해볼것, 여태 했던것들.

************************Inner Join 문법
"Inner Join #1
*SELECT *
*  FROM ztsa0101 INNER JOIN ztsa0102
*    on ztsa0101~edept = ztsa0102~edept
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*  WHERE ztsa0101~edept = pa_dep.
"Inner Join #2
*SELECT  pernr ename a~edept phone
*  FROM ztsa0101 as a INNER JOIN ztsa0102 as b
*  on   a~edept = b~edept
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*  WHERE a~edept = pa_dep.

"Left Outer Join#2

SELECT *
  FROM ztsa0101 as emp LEFT OUTER JOIN ztsa0102 as dep
    ON emp~edept = dep~edept
  INTO CORRESPONDING FIELDS OF TABLE gt_info.

cl_demo_output=>display_data( gt_info ).
