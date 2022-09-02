*&---------------------------------------------------------------------*
*& Report ZRSA01_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa01_25_top                           .    " Global Data

* INCLUDE ZRSA01_25_O01                           .  " PBO-Modules
* INCLUDE ZRSA01_25_I01                           .  " PAI-Modules
INCLUDE zrsa01_25_f01                           .  " FORM-Routines


START-OF-SELECTION.
  SELECT *
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid = pa_car
  AND connid IN so_con. "BETWEEN pa_con AND pa_con2.

 cl_demo_output=>display_data( gt_info ).
