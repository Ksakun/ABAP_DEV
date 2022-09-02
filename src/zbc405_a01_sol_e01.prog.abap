*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_SOL_E01
*&---------------------------------------------------------------------*

SELECT *
  FROM dv_flights
  INTO gs_flight
  WHERE carrid = pa_car
    AND connid = pa_con
    AND fldate IN so_date.
*
  WRITE:/ gs_flight-carrid,
         gs_flight-connid,
         gs_flight-fldate,
         gs_flight-price CURRENCY gs_flight-currency,
         gs_flight-currency.

ENDSELECT.

INITIALIZATION.

LOOP AT SCREEN.
  IF screen-group1 = 'MOD'.
    screen-input = 0.
    screen-output = 1.

  ENDIF.

  MODIFY SCREEN.
ENDLOOP.
