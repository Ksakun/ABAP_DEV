*&---------------------------------------------------------------------*
*& Report ZRSA01_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA01_34.

"Dep Info - structure type
DATA gs_dep TYPE ZSSA0111.
DATA gt_dep LIKE TABLE OF gs_dep.

"emp info ( structure vairable )

*DATA gs_emp TYPE zssa0104.
DATA gs_emp LIKE LINE OF gs_dep-emp_list.

PARAMETERS pa_dep TYPE ztsa0102-edept.

START-OF-SELECTION.

SELECT SINGLE *
  FROM ZTSA0102 "dep table
  INTO CORRESPONDING FIELDS OF gs_dep
  WHERE edept = pa_dep.

SELECT SINGLE dtext
  FROM ztsa0102_t
  INTO CORRESPONDING FIELDS OF gs_dep
  WHERE edept = pa_dep.

  IF sy-subrc <> 0.
    return.

  ENDIF.

cl_demo_output=>display_data( gs_dep ).
  SELECT *
    FROM ztsa0101 " emp table
    INTO CORRESPONDING FIELDS OF TABLE gs_dep-emp_list
    where edept = gs_dep-edept.


LOOP AT gs_dep-emp_list INTO gs_emp.
  "Get Gender Text


  MODIFY gs_dep-emp_list FROM gs_emp.
  CLEAR gs_emp.
ENDLOOP.
