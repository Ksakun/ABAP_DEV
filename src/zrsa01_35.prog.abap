*&---------------------------------------------------------------------*
*& Report ZRSA01_35
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_35.

TYPES: BEGIN OF ts_dep,
         budget TYPE ztsa0102-budget,
         waers  TYPE ztsa0102-waers,

       END OF ts_dep.

DATA: gs_dep TYPE zssa0120, "emp table ztsa0102
      gt_dep LIKE TABLE OF gs_dep.

DATA go_salv TYPE REF TO cl_salv_table.

PARAMETERS pa_dep LIKE gs_dep-budget.


START-OF-SELECTION.

*  SELECT SINGLE *
*    FROM ztsa0102
*    INTO CORRESPONDING FIELDS OF gs_dep
*    WHERE edept = pa_dep.


*  WRITE: gs_dep-budget CURRENCY gs_dep-waers, gs_dep-waers.

  SELECT *
    FROM ztsa0102
    INTO CORRESPONDING FIELDS OF TABLE gt_dep.

  cl_salv_table=>factory(
    IMPORTING r_salv_table  = go_salv
    CHANGING t_table = gt_dep

  ).
  go_salv->display( ).
*cl_demo_output=>display_data( gt_dep ).
