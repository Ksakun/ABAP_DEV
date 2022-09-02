*&---------------------------------------------------------------------*
*& Report ZRSA01_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa01_32_top                           .    " Global Data

* INCLUDE ZRSA01_32_O01                           .  " PBO-Modules
* INCLUDE ZRSA01_32_I01                           .  " PAI-Modules
INCLUDE zrsa01_32_f01                           .  " FORM-Routines

INITIALIZATION.
  pa_pernr = '20220001'.

START-OF-SELECTION.

  SELECT SINGLE *
    FROM ztsa0101 "employee table
    INTO CORRESPONDING FIELDS OF gs_emp
    WHERE pernr = pa_pernr.

*  IF sy-subrc IS NOT INITIAL.
*    MESSAGE i016(pn) WITH 'Data Not Found.'.
*    RETURN.
*  ENDIF.

  IF sy-subrc <> 0.
    MESSAGE i001(zmcsa01).
    RETURN.
  ENDIF.

*  WRITE gs_emp-edept.
*  NEW-LINE.
*  write gs_emp-dep.

SELECT SINGLE *
  FROM ZTSA0102
  INTO gs_emp-dep
  WHERE edept = gs_emp-edept.

  cl_demo_output=>display_data( gs_emp-dep ).
