*&---------------------------------------------------------------------*
*& Report ZRSA01_31
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA01_31_TOP                           .    " Global Data

* INCLUDE ZRSA01_31_O01                           .  " PBO-Modules
* INCLUDE ZRSA01_31_I01                           .  " PAI-Modules
INCLUDE ZRSA01_31_F01                           .  " FORM-Routines



INITIALIZATION.
  PERFORM set_default.

START-OF-SELECTION.

  SELECT *
    FROM ztsa0101
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE entdt BETWEEN pa_ent_b AND pa_ent_e.

   IF sy-subrc IS NOT INITIAL. "위에서 데이터를 찾지 못했다. sy-subrc <> 0
     MESSAGE i016(pn) WITH 'Data Not Found.'.
     RETURN.
   ENDIF.

 cl_demo_output=>display_data( gt_emp ).
