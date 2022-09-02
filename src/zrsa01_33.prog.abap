*&---------------------------------------------------------------------*
*& Report ZRSA01_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_33.
DATA gs_dep TYPE zssa0105.
"emp info
DATA: gt_emp TYPE TABLE OF zssa0104, "emp info
      gs_emp LIKE LINE OF gt_emp.
PARAMETERS pa_dep TYPE ztsa0102-edept.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa0102 "department table
    INTO CORRESPONDING FIELDS OF gs_dep
    WHERE edept = pa_dep.


*  cl_demo_output=>display_data( gs_dep ).

 SELECT *
   FROM ztsa0101
   INTO CORRESPONDING FIELDS OF TABLE gt_emp
   WHERE edept = gs_dep-edept.

   cl_demo_output=>display_data( gt_emp ).
