*&---------------------------------------------------------------------*
*& Include          ZRSA01_91_E01
*&---------------------------------------------------------------------*
"When Select Radio button 'Undefined' Show all data.

INITIALIZATION.
  "Set Text for Push Button

  tab1 = 'Connections'.
  tab2 = 'Inflight Meal'.
  button = 'Get Info'.

AT SELECTION-SCREEN. "PAI
  CASE sscrfields-ucomm.
    WHEN 'PUSH'.
      IF pa_car IS NOT INITIAL.
        PERFORM get_name.
        MESSAGE i000(zmcsa01) WITH 'Airline Name is ' gv_name.
      ELSE.
        MESSAGE i000(zmcsa01) WITH 'Airline code is empty.'.
        EXIT.
      ENDIF.

  ENDCASE.

START-OF-SELECTION.

  CASE gc_mark.
    WHEN pa_und.
      SELECT *
        FROM ztsa0199
        INTO TABLE gt_data.
*       WHERE carrid = pa_car
*         AND mealnumber IN so_meal.
      cl_demo_output=>display_data( gt_data ).
    WHEN pa_b2c.
      SELECT *
        FROM ztsa0199
        INTO TABLE gt_data
       WHERE carrid = pa_car
         AND mealnumber IN so_meal
         AND venca  = 'B2C'.

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

        PERFORM get_domain.
        MODIFY gt_data FROM gs_data.
        CLEAR gs_data.
      ENDLOOP.

      cl_demo_output=>display_data( gt_data ).
    WHEN pa_b2b.

      SELECT *
        FROM ztsa0199
        INTO CORRESPONDING FIELDS OF TABLE gt_data
        WHERE carrid = pa_car
        AND mealnumber IN so_meal
        AND venca  = 'B2B'.

      cl_demo_output=>display_data( gt_data ).
    WHEN pa_b2g.

      SELECT *
        FROM ztsa0199
        INTO TABLE gt_data
       WHERE carrid = pa_car
         AND mealnumber IN so_meal
         AND venca  = 'B2G'.
      cl_demo_output=>display_data( gt_data ).
  ENDCASE.
