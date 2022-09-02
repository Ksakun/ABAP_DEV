*&---------------------------------------------------------------------*
*& Report ZRSA01_40
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA01_40_TOP                           .    " Global Data

* INCLUDE ZRSA01_40_O01                           .  " PBO-Modules
* INCLUDE ZRSA01_40_I01                           .  " PAI-Modules
* INCLUDE ZRSA01_40_F01                           .  " FORM-Routines

INITIALIZATION.
  pa_emp = '20220001'.

START-OF-SELECTION.

  "Inner join two tables
  SELECT *
    FROM ztsa0101 AS emp INNER JOIN ztsa01pro as pro "employee table
      ON emp~pernr = pro~pernr "-
    INTO CORRESPONDING FIELDS OF TABLE gt_list
    WHERE emp~pernr = pa_emp.

*  cl_demo_output=>display_data( gt_list ).

  LOOP AT gt_list INTO gs_list.

    "Get depname
    SELECT SINGLE *
      FROM ztsa0102_t
      INTO CORRESPONDING FIELDS OF gs_list
      WHERE edept = gs_list-edept AND spras = sy-langu.

    "Get Product Name
    SELECT SINGLE *
      FROM ztsa01pro_t
      INTO CORRESPONDING FIELDS OF gs_list
      WHERE proid = gs_list-proid AND spras = sy-langu.

    MODIFY gt_list FROM gs_list.
    CLEAR gs_list.
  ENDLOOP.

  IF sy-subrc <> 0. " 0이 아니다
    MESSAGE i016(pn) WITH 'Wrong Persnal Number. Try it Again'.
    RETURN.
  ENDIF.





    cl_demo_output=>display_data( gt_list ).
