*&---------------------------------------------------------------------*
*& Report ZSRA01_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa01_24_top                           .    " Global Data

* INCLUDE ZRSA01_24_O01                           .  " PBO-Modules
* INCLUDE ZRSA01_24_I01                           .  " PAI-Modules
INCLUDE zrsa01_24_f01                           .  " FORM-Routines



INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.


START-OF-SELECTION.

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_list
   WHERE carrid = pa_car AND ( connid = pa_con1 OR connid = pa_con2 ).


LOOP AT gt_list INTO gs_list.

  SELECT SINGLE carrname
    FROM scarr
    INTO gs_list-carrname
    WHERE carrid = gs_list-carrid.

  SELECT SINGLE cityfrom cityto
     FROM spfli
     INTO CORRESPONDING FIELDS OF gs_list
    WHERE carrid = gs_list-carrid AND connid = gs_list-connid.

  gs_list-remain = gs_list-seatsmax - gs_list-seatsocc.
  gs_list-remain_b = gs_list-seatsmax_b - gs_list-seatsocc_b.
  gs_list-remain_f = gs_list-seatsmax_f - gs_list-seatsocc_F.
  MODIFY gt_list FROM gs_list.

  CLEAR gs_list.
ENDLOOP.




  cl_demo_output=>display_data( gt_list ).
