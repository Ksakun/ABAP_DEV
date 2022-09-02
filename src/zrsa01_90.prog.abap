*&---------------------------------------------------------------------*
*& Report ZRSA01_90
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa01_90_top                           .    " Global Data

*INCLUDE zrsa01_90_o01                           .  " PBO-Modules
*INCLUDE zrsa01_90_i01                           .  " PAI-Modules
INCLUDE zrsa01_90_f01                           .  " FORM-Routines

INITIALIZATION.

START-OF-SELECTION.

  IF pa_venca IS INITIAL. "Undefined
    "When Vendor Category is 'undefined' show all
    SELECT *
      FROM ztsa0199
      INTO CORRESPONDING FIELDS OF TABLE gt_data
     WHERE carrid = pa_car
       AND mealnumber IN so_meal.


  ELSE. "b2b b2c b2g
    SELECT *
      FROM ztsa0199
      INTO CORRESPONDING FIELDS OF TABLE gt_data
     WHERE carrid = pa_car
       AND venca = pa_venca
       AND mealnumber IN so_meal.
  ENDIF.

  LOOP AT gt_data INTO gs_data.
    "Get Country Name
    SELECT SINGLE landx
      FROM t005t
      INTO gs_data-land1_t
      WHERE land1 = gs_data-land1
        AND spras = sy-langu.
    "Get Carrname
    SELECT SINGLE carrname
      FROM scarr
      INTO gs_data-carrname
      WHERE carrid = gs_data-carrid.
    "Get Meal Name
    SELECT SINGLE text
      FROM smealt
      INTO gs_data-mealnumber_t
      WHERE mealnumber = gs_data-mealnumber
        AND sprache = sy-langu.
    "Get Vendor Type Text
     "use 'Get_Domain_value
    PERFORM get_domain_text.

    MODIFY gt_data FROM gs_data.
    CLEAR gs_data.
  ENDLOOP.


cl_demo_output=>display_data( gt_data ).
